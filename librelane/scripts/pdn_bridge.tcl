# =============================================================================
# pdn_bridge.tcl -- PDN_CFG for A53_chip_top (LibreLane 3.x, gf180mcu)
#
# 1. Builds the normal LibreLane PDN by sourcing LibreLane's own default
#    pdn_cfg.tcl, so all the PDN_* variables in config.json still apply.
# 2. Wraps `pdngen` so that right after the grid is built (and BEFORE the
#    grid check, write-out, placement and routing) every Metal2 VDD/GND
#    boundary pin is bridged to its own net's core ring:
#
#       pin (Metal2, at die edge)
#         -> Metal2 strip, as wide as the pin, from the die edge across the ring
#         -> plates on every layer between Metal2 and the ring layer
#         -> via arrays at every level, inside the strip/ring overlap
#
#    West/East pins land on the vertical ring layer (Metal4).
#    North/South pins land on the horizontal ring layer (Metal5).
#
# Nothing is hardcoded: pin boxes come from the design (FP_DEF_TEMPLATE with
# FP_TEMPLATE_COPY_POWER_PINS=true), ring positions are read from what pdngen
# just built, vias are LEF single-cut vias from the tech. Any existing special
# shape on an intermediate layer (e.g. Metal4 stripes running through the top
# ring) is cut out of the bridge, so no plate/via can short to the other net
# or crowd pdngen's own vias.
#
# The bridge shapes are written as ROUTED special wires on the power net, so
# the detailed router treats them as existing metal and routes around them.
#
# Required config.json:
#   "PDN_CFG": "dir::scripts/pdn_bridge.tcl",
#   "FP_TEMPLATE_COPY_POWER_PINS": true,
#   "PDN_CORE_RING": true
# =============================================================================

source $::env(SCRIPTS_DIR)/openroad/common/pdn_cfg.tcl

namespace eval bridge {
    # Cut spacing used inside via arrays. 0.36um satisfies gf180mcu V2.2b /
    # V3.2b / V4.2b (spacing in 4x4-or-larger arrays) regardless of array size.
    variable cut_spacing_um 0.36
    # Keep-out kept around foreign shapes on intermediate layers. Generous on
    # purpose (covers wide-metal spacing on the wide PDN stripes).
    variable obs_margin_um 1.0
    variable dbu 1000
    variable mgrid 1
}

proc bridge::um {v} {
    variable dbu
    return [expr {int(round($v * $dbu))}]
}

proc bridge::snap {v} {
    variable mgrid
    return [expr {int(round(double($v) / $mgrid)) * $mgrid}]
}

# Wire-shape type as a string, whichever way the odb Tcl binding returns it.
proc bridge::shape_type {s} {
    set t [$s getWireShapeType]
    if {[string match "_*_p_*" $t]} { set t [$t getString] }
    return $t
}

proc bridge::layer_type {l} {
    set t [$l getType]
    if {[string match "_*_p_*" $t]} { set t [$t getString] }
    return $t
}

# Single-cut tech via between two routing layers (prefers LEF DEFAULT vias).
proc bridge::find_via {tech bot top} {
    set fallback ""
    foreach v [$tech getVias] {
        if {[[$v getBottomLayer] getName] ne [$bot getName]} continue
        if {[[$v getTopLayer] getName] ne [$top getName]} continue
        set ncut 0
        foreach b [$v getBoxes] {
            if {[bridge::layer_type [$b getTechLayer]] eq "CUT"} { incr ncut }
        }
        if {$ncut != 1} continue
        if {[$v isDefault]} { return $v }
        if {$fallback eq ""} { set fallback $v }
    }
    if {$fallback eq ""} {
        error "\[bridge\] no single-cut via between [$bot getName] and [$top getName]"
    }
    return $fallback
}

# {half_w half_h cut_w cut_h}: extent of all via boxes around the via origin.
proc bridge::via_info {v} {
    set hw 0; set hh 0; set cw 0; set ch 0
    foreach b [$v getBoxes] {
        set hw [expr {max($hw, abs([$b xMin]), abs([$b xMax]))}]
        set hh [expr {max($hh, abs([$b yMin]), abs([$b yMax]))}]
        if {[bridge::layer_type [$b getTechLayer]] eq "CUT"} {
            set cw [expr {[$b xMax] - [$b xMin]}]
            set ch [expr {[$b yMax] - [$b yMin]}]
        }
    }
    return [list $hw $hh $cw $ch]
}

# Remove [lo,hi] from a list of {a b} intervals.
proc bridge::subtract {intervals lo hi} {
    set out {}
    foreach iv $intervals {
        lassign $iv a b
        if {$hi <= $a || $lo >= $b} { lappend out $iv; continue }
        if {$lo > $a} { lappend out [list $a $lo] }
        if {$hi < $b} { lappend out [list $hi $b] }
    }
    return $out
}

# Via centres along one axis: as many as fit in [lo,hi], centred, on grid.
proc bridge::positions {lo hi half pitch} {
    set a [expr {$lo + $half}]
    set b [expr {$hi - $half}]
    if {$b < $a} { return {} }
    set n [expr {int(($b - $a) / $pitch) + 1}]
    set start [expr {$a + (($b - $a) - ($n - 1) * $pitch) / 2}]
    set out {}
    for {set i 0} {$i < $n} {incr i} {
        set p [bridge::snap [expr {$start + $i * $pitch}]]
        # snapping may push the outermost cut half a grid out; pull it back
        if {$p - $half < $lo} { incr p [expr {$lo - ($p - $half)}] }
        if {$p + $half > $hi} { incr p [expr {$hi - ($p + $half)}] }
        lappend out $p
    }
    return $out
}

# Every special (PDN) non-via shape in the block, by layer name.
proc bridge::collect_special_shapes {block} {
    set shapes [dict create]
    foreach n [$block getNets] {
        if {![$n isSpecial]} continue
        foreach sw [$n getSWires] {
            foreach s [$sw getWires] {
                if {[$s isVia]} continue
                set l [$s getTechLayer]
                if {$l eq "NULL"} continue
                dict lappend shapes [$l getName] \
                    [list [$n getName] [$s xMin] [$s yMin] [$s xMax] [$s yMax]]
            }
        }
    }
    return $shapes
}

proc bridge::run {} {
    variable dbu
    variable mgrid
    variable cut_spacing_um
    variable obs_margin_um

    set block [ord::get_db_block]
    set tech  [ord::get_db_tech]
    set dbu   [$block getDbUnitsPerMicron]
    set mgrid [$tech getManufacturingGrid]
    if {$mgrid <= 0} { set mgrid 1 }
    set cut_sp [bridge::um $cut_spacing_um]
    set obs_m  [bridge::um $obs_margin_um]

    set die [$block getDieArea]
    set dx0 [$die xMin]; set dy0 [$die yMin]
    set dx1 [$die xMax]; set dy1 [$die yMax]

    set vlayer $::env(PDN_VERTICAL_LAYER)
    set hlayer $::env(PDN_HORIZONTAL_LAYER)
    if {[info exists ::env(PDN_CORE_VERTICAL_LAYER)]}   { set vlayer $::env(PDN_CORE_VERTICAL_LAYER) }
    if {[info exists ::env(PDN_CORE_HORIZONTAL_LAYER)]} { set hlayer $::env(PDN_CORE_HORIZONTAL_LAYER) }

    # Snapshot of the grid exactly as pdngen built it.
    set special [bridge::collect_special_shapes $block]

    set total 0
    foreach netname [concat $::env(VDD_NETS) $::env(GND_NETS)] {
        set net [$block findNet $netname]
        if {$net eq "NULL"} { continue }

        set rings {}
        foreach sw [$net getSWires] {
            foreach s [$sw getWires] {
                if {[$s isVia]} continue
                if {[bridge::shape_type $s] ne "RING"} continue
                lappend rings $s
            }
        }

        set boxes {}
        foreach bterm [$net getBTerms] {
            foreach bpin [$bterm getBPins] {
                foreach box [$bpin getBoxes] {
                    if {[$box getTechLayer] ne "NULL"} { lappend boxes $box }
                }
            }
        }
        if {![llength $boxes]} {
            puts "\[bridge\] WARNING: net $netname has no boundary pin shapes\
                  (is FP_TEMPLATE_COPY_POWER_PINS true?) -- nothing to bridge."
            continue
        }
        if {![llength $rings]} {
            error "\[bridge\] net $netname has pins but no core ring.\
                   Set PDN_CORE_RING to true."
        }

        # Add the bridge to the net's EXISTING special wire (the one pdngen
        # made). A second dbSWire makes OpenROAD write a second "+ ROUTED"
        # statement for the net, which Magic's DEF reader rejects
        # ("Unknown layer type "+" for NEW route").
        set sws [$net getSWires]
        if {[llength $sws]} {
            set sw_new [lindex $sws 0]
        } else {
            set sw_new [odb::dbSWire_create $net ROUTED]
        }

        set net_bridged 0
        foreach box $boxes {
            set pl [$box getTechLayer]
            set x0 [$box xMin]; set y0 [$box yMin]
            set x1 [$box xMax]; set y1 [$box yMax]

            if     {$x0 <= $dx0} { set edge W } \
            elseif {$x1 >= $dx1} { set edge E } \
            elseif {$y1 >= $dy1} { set edge N } \
            elseif {$y0 <= $dy0} { set edge S } \
            else {
                puts "\[bridge\] WARNING: $netname pin box ($x0 $y0 $x1 $y1) is\
                      not on the die edge, skipped."
                continue
            }

            # Nearest ring segment of this net facing that edge, spanning the pin.
            set ring ""
            foreach r $rings {
                set rl [[$r getTechLayer] getName]
                set rw [expr {[$r xMax] - [$r xMin]}]
                set rh [expr {[$r yMax] - [$r yMin]}]
                if {$edge in {W E}} {
                    if {$rl ne $vlayer || $rh <= $rw} continue
                    if {[$r yMin] > $y0 || [$r yMax] < $y1} continue
                } else {
                    if {$rl ne $hlayer || $rw <= $rh} continue
                    if {[$r xMin] > $x0 || [$r xMax] < $x1} continue
                }
                if {$ring eq ""} { set ring $r; continue }
                switch $edge {
                    W { if {[$r xMin] < [$ring xMin]} { set ring $r } }
                    E { if {[$r xMax] > [$ring xMax]} { set ring $r } }
                    N { if {[$r yMax] > [$ring yMax]} { set ring $r } }
                    S { if {[$r yMin] < [$ring yMin]} { set ring $r } }
                }
            }
            if {$ring eq ""} {
                error "\[bridge\] no $netname ring segment on the $edge side\
                       spans pin ($x0 $y0 $x1 $y1)"
            }
            set rx0 [$ring xMin]; set ry0 [$ring yMin]
            set rx1 [$ring xMax]; set ry1 [$ring yMax]

            # Strip on the pin layer, die edge -> far side of the ring, and the
            # overlap region R where the via stack goes. `axis` is the axis
            # along the pin's width (where foreign stripes get cut out).
            switch $edge {
                W { set s [list $dx0 $y0 $rx1 $y1]; set R [list $rx0 $y0 $rx1 $y1]; set axis y }
                E { set s [list $rx0 $y0 $dx1 $y1]; set R [list $rx0 $y0 $rx1 $y1]; set axis y }
                N { set s [list $x0 $ry0 $x1 $dy1]; set R [list $x0 $ry0 $x1 $ry1]; set axis x }
                S { set s [list $x0 $dy0 $x1 $ry1]; set R [list $x0 $ry0 $x1 $ry1]; set axis x }
            }
            lassign $s sx0 sy0 sx1 sy1
            lassign $R Rx0 Ry0 Rx1 Ry1

            # Foreign special shapes on the pin layer along the strip = short.
            if {[dict exists $special [$pl getName]]} {
                foreach sh [dict get $special [$pl getName]] {
                    lassign $sh n ax0 ay0 ax1 ay1
                    if {$n eq $netname} continue
                    if {$ax1 > $sx0 && $ax0 < $sx1 && $ay1 > $sy0 && $ay0 < $sy1} {
                        error "\[bridge\] $netname strip ($s) would short $n on [$pl getName]"
                    }
                }
            }
            odb::dbSBox_create $sw_new $pl $sx0 $sy0 $sx1 $sy1 STRIPE

            # Layers in the stack.
            set lo [$pl getRoutingLevel]
            set hi [[$ring getTechLayer] getRoutingLevel]
            set mids {}
            for {set k [expr {$lo + 1}]} {$k < $hi} {incr k} {
                lappend mids [$tech findRoutingLayer $k]
            }
            set vias {}
            for {set k $lo} {$k < $hi} {incr k} {
                lappend vias [bridge::find_via $tech \
                    [$tech findRoutingLayer $k] [$tech findRoutingLayer [expr {$k + 1}]]]
            }
            set hw 0; set hh 0; set cw 0; set ch 0
            foreach v $vias {
                lassign [bridge::via_info $v] a b c d
                set hw [expr {max($hw, $a)}]; set hh [expr {max($hh, $b)}]
                set cw [expr {max($cw, $c)}]; set ch [expr {max($ch, $d)}]
            }
            set px [expr {$cw + $cut_sp}]
            set py [expr {$ch + $cut_sp}]

            # Free intervals of R along `axis` after cutting out every special
            # shape (any net -- includes pdngen's own stripes/vias there) on
            # the intermediate layers.
            if {$axis eq "y"} { set free [list [list $Ry0 $Ry1]] } \
            else              { set free [list [list $Rx0 $Rx1]] }
            foreach ml $mids {
                if {![dict exists $special [$ml getName]]} continue
                foreach sh [dict get $special [$ml getName]] {
                    lassign $sh n ax0 ay0 ax1 ay1
                    if {$ax1 + $obs_m <= $Rx0 || $ax0 - $obs_m >= $Rx1} continue
                    if {$ay1 + $obs_m <= $Ry0 || $ay0 - $obs_m >= $Ry1} continue
                    if {$axis eq "y"} {
                        set free [bridge::subtract $free [expr {$ay0 - $obs_m}] [expr {$ay1 + $obs_m}]]
                    } else {
                        set free [bridge::subtract $free [expr {$ax0 - $obs_m}] [expr {$ax1 + $obs_m}]]
                    }
                }
            }

            set ncuts 0
            foreach iv $free {
                lassign $iv a b
                if {$axis eq "y"} { set P [list $Rx0 $a $Rx1 $b] } \
                else              { set P [list $a $Ry0 $b $Ry1] }
                lassign $P qx0 qy0 qx1 qy1
                set xs [bridge::positions $qx0 $qx1 $hw $px]
                set ys [bridge::positions $qy0 $qy1 $hh $py]
                if {![llength $xs] || ![llength $ys]} continue

                foreach ml $mids {
                    odb::dbSBox_create $sw_new $ml $qx0 $qy0 $qx1 $qy1 STRIPE
                }
                foreach v $vias {
                    foreach x $xs {
                        foreach y $ys {
                            odb::dbSBox_create $sw_new $v $x $y STRIPE
                        }
                    }
                }
                incr ncuts [expr {[llength $xs] * [llength $ys]}]
            }
            if {$ncuts == 0} {
                error "\[bridge\] $netname pin ($x0 $y0 $x1 $y1): no room for vias\
                       between the strip and the [[$ring getTechLayer] getName] ring"
            }
            incr total
            incr net_bridged
            puts [format "\[bridge\] %-4s %s-edge pin (%.2f %.2f %.2f %.2f)um -> %s ring, %d cuts per via level" \
                $netname $edge [expr {double($x0)/$dbu}] [expr {double($y0)/$dbu}] \
                [expr {double($x1)/$dbu}] [expr {double($y1)/$dbu}] \
                [[$ring getTechLayer] getName] $ncuts]
        }
        if {$net_bridged == 0} {
            error "\[bridge\] net $netname has no pin shapes on the die edge, so\
                   nothing was bridged. The DEF-template Metal2 pins must exist\
                   before PDN: run Odb.ApplyDEFTemplate before OpenROAD.GeneratePDN\
                   (meta.substituting_steps) and set PDN_ENABLE_PINS to false."
        }
    }
    puts "\[bridge\] bridged $total power/ground pin shapes to the core ring."
}

# Run the bridge right after pdngen, inside LibreLane's PDN step.
if {[info commands ::bridge::_orig_pdngen] eq ""} {
    rename ::pdngen ::bridge::_orig_pdngen
    proc ::pdngen {args} {
        ::bridge::_orig_pdngen {*}$args
        ::bridge::run
    }
}
