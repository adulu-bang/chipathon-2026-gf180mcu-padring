v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -1370 360 -1370 400 {lab=GND}
N -1370 240 -1370 300 {lab=VDD}
N -150 -0 -80 -0 {lab=osc3}
N 700 0 750 0 {lab=osc3}
N 100 0 220 -0 {lab=#net1}
N 400 -0 520 0 {lab=#net2}
N 750 -0 750 130 {lab=osc3}
N -150 130 750 130 {lab=osc3}
N -150 0 -150 130 {lab=osc3}
N 700 310 750 310 {lab=osc5}
N 400 310 520 310 {lab=#net3}
N 750 310 750 440 {lab=osc5}
N -150 440 750 440 {lab=osc5}
N 750 130 980 130 {lab=osc3}
N 750 170 750 310 {lab=osc5}
N 750 170 980 170 {lab=osc5}
N 1090 150 1140 150 {lab=vx1}
N 980 130 1000 130 {lab=osc3}
N 1000 120 1000 130 {lab=osc3}
N 1000 120 1020 120 {lab=osc3}
N 980 170 1000 170 {lab=osc5}
N 1000 170 1000 180 {lab=osc5}
N 1000 180 1020 180 {lab=osc5}
N -500 310 -380 310 {lab=#net4}
N -200 310 -80 310 {lab=#net5}
N -740 440 -150 440 {lab=osc5}
N -740 310 -740 440 {lab=osc5}
N -740 310 -680 310 {lab=osc5}
N 100 310 220 310 {lab=#net6}
N 710 670 760 670 {lab=osc7}
N 410 670 530 670 {lab=#net7}
N 760 670 760 800 {lab=osc7}
N -140 800 760 800 {lab=osc7}
N -490 670 -370 670 {lab=#net8}
N -190 670 -70 670 {lab=#net9}
N -730 800 -140 800 {lab=osc7}
N -730 670 -670 670 {lab=#net10}
N 110 670 230 670 {lab=#net11}
N -1030 670 -910 670 {lab=#net12}
N -1280 670 -1210 670 {lab=osc7}
N -1280 670 -1280 800 {lab=osc7}
N -1280 800 -730 800 {lab=osc7}
N 1110 740 1160 740 {lab=vx2}
N 1020 710 1040 710 {lab=osc7}
N 1020 770 1040 770 {lab=osc9}
N 760 670 1020 670 {lab=osc7}
N 1020 670 1020 710 {lab=osc7}
N 710 970 760 970 {lab=osc9}
N 410 970 530 970 {lab=#net13}
N 760 970 760 1100 {lab=osc9}
N -140 1100 760 1100 {lab=osc9}
N -490 970 -370 970 {lab=#net14}
N -190 970 -70 970 {lab=#net15}
N -730 1100 -140 1100 {lab=osc9}
N 110 970 230 970 {lab=#net16}
N -1030 970 -910 970 {lab=#net17}
N -1280 1100 -730 1100 {lab=osc9}
N -1780 1100 -1280 1100 {lab=osc9}
N -1780 970 -1780 1100 {lab=osc9}
N -1780 970 -1700 970 {lab=osc9}
N -1520 970 -1460 970 {lab=#net18}
N -1280 970 -1210 970 {lab=#net19}
N -730 970 -670 970 {lab=#net20}
N 760 970 1020 970 {lab=osc9}
N 1020 770 1020 970 {lab=osc9}
N 1340 480 1390 480 {lab=vo}
N 1250 450 1270 450 {lab=vx1}
N 1250 510 1270 510 {lab=vx2}
N 1140 150 1240 150 {lab=vx1}
N 1240 150 1240 450 {lab=vx1}
N 1240 450 1250 450 {lab=vx1}
N 1160 520 1160 740 {lab=vx2}
N 1160 510 1160 520 {lab=vx2}
N 1160 510 1250 510 {lab=vx2}
N -1280 360 -1280 400 {lab=GND}
N -1280 160 -1280 300 {lab=#net21}
N -1280 160 -1160 160 {lab=#net21}
C {devices/code_shown.sym} -650 -250 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.include /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_sc_mcu7t5v0/spice/gf180mcu_fd_sc_mcu7t5v0.spice
.ic v(net1)=0 v(net4)=3.3 v(net7)=0 v(net13)=3.3
"}
C {inv_starved.sym} 0 0 0 0 {name=x1}
C {devices/vsource.sym} -1370 330 0 0 {name=V1 value=3.3 savecurrent=false}
C {devices/vdd.sym} -1370 240 0 0 {name=l2 lab=VDD}
C {devices/gnd.sym} -1370 400 0 0 {name=l4 lab=GND}
C {devices/vdd.sym} 10 -60 0 0 {name=l1 lab=VDD}
C {devices/gnd.sym} 10 60 0 0 {name=l6 lab=GND}
C {devices/code_shown.sym} 320 -430 0 0 {name=NGSPICE only_toplevel=true
value="
.control
set ngbehavior=hsa

save v(vo) v(osc3) v(osc5) v(osc7) v(osc9)

** Run 
tran 100p 100u

** Write data to project directory
wrdata /foss/designs/trng_analog/current_starved/ro_data.txt v(vo) v(osc3) v(osc5) v(osc7) v(osc9)

** plot v(osc3) v(osc5) v(vo)+4 v(osc7) v(osc9)
.endc
"}
C {lab_pin.sym} -80 -70 0 0 {name=p6 sig_type=std_logic lab=vbp}
C {lab_pin.sym} -80 70 0 0 {name=p7 sig_type=std_logic lab=vbn}
C {inv_starved.sym} 300 0 0 0 {name=x2}
C {devices/vdd.sym} 310 -60 0 0 {name=l7 lab=VDD}
C {devices/gnd.sym} 310 60 0 0 {name=l9 lab=GND}
C {inv_starved.sym} 600 0 0 0 {name=x3}
C {devices/vdd.sym} 610 -60 0 0 {name=l10 lab=VDD}
C {devices/gnd.sym} 610 60 0 0 {name=l11 lab=GND}
C {inv_starved.sym} 300 310 0 0 {name=x5}
C {devices/vdd.sym} 310 250 0 0 {name=l13 lab=VDD}
C {devices/gnd.sym} 310 370 0 0 {name=l14 lab=GND}
C {inv_starved.sym} 600 310 0 0 {name=x6}
C {devices/vdd.sym} 610 250 0 0 {name=l15 lab=VDD}
C {devices/gnd.sym} 610 370 0 0 {name=l16 lab=GND}
C {lab_pin.sym} 1140 150 2 0 {name=p1 sig_type=std_logic lab=vx1}
C {devices/vdd.sym} 1080 110 0 0 {name=l17 lab=VDD}
C {devices/gnd.sym} 1040 190 0 0 {name=l18 lab=GND}
C {xor_new.sym} 1020 150 0 0 {name=x7
type=subcircuit
format="@name @pinlist gf180mcu_fd_sc_mcu7t5v0__xor2_1"}
C {devices/gnd.sym} 1080 190 0 0 {name=l19 lab=GND}
C {devices/vdd.sym} 1040 110 0 0 {name=l20 lab=VDD}
C {capa.sym} 1140 180 0 0 {name=C1
m=1
value=10f
footprint=1206
device="ceramic capacitor"}
C {devices/gnd.sym} 1140 210 0 0 {name=l21 lab=GND}
C {lab_pin.sym} 750 0 2 0 {name=p3 sig_type=std_logic lab=osc3}
C {lab_pin.sym} 750 310 2 0 {name=p17 sig_type=std_logic lab=osc5}
C {inv_starved.sym} -600 310 0 0 {name=x8}
C {devices/vdd.sym} -590 250 0 0 {name=l22 lab=VDD}
C {devices/gnd.sym} -590 370 0 0 {name=l23 lab=GND}
C {lab_pin.sym} -680 240 0 0 {name=p18 sig_type=std_logic lab=vbp}
C {lab_pin.sym} -680 380 0 0 {name=p19 sig_type=std_logic lab=vbn}
C {inv_starved.sym} -300 310 0 0 {name=x9}
C {devices/vdd.sym} -290 250 0 0 {name=l24 lab=VDD}
C {devices/gnd.sym} -290 370 0 0 {name=l25 lab=GND}
C {inv_starved.sym} 0 310 0 0 {name=x10}
C {devices/vdd.sym} 10 250 0 0 {name=l26 lab=VDD}
C {devices/gnd.sym} 10 370 0 0 {name=l27 lab=GND}
C {lab_pin.sym} 220 -70 0 0 {name=p8 sig_type=std_logic lab=vbp}
C {lab_pin.sym} 220 70 0 0 {name=p9 sig_type=std_logic lab=vbn}
C {lab_pin.sym} 520 -70 0 0 {name=p10 sig_type=std_logic lab=vbp}
C {lab_pin.sym} 520 70 0 0 {name=p11 sig_type=std_logic lab=vbn}
C {inv_starved.sym} 310 670 0 0 {name=x4}
C {inv_starved.sym} 610 670 0 0 {name=x11}
C {lab_pin.sym} 760 670 2 0 {name=p28 sig_type=std_logic lab=osc7}
C {inv_starved.sym} -590 670 0 0 {name=x12}
C {devices/vdd.sym} -580 610 0 0 {name=l32 lab=VDD}
C {devices/gnd.sym} -580 730 0 0 {name=l33 lab=GND}
C {inv_starved.sym} -290 670 0 0 {name=x13}
C {devices/vdd.sym} -280 610 0 0 {name=l34 lab=VDD}
C {devices/gnd.sym} -280 730 0 0 {name=l35 lab=GND}
C {inv_starved.sym} 10 670 0 0 {name=x14}
C {devices/vdd.sym} 20 610 0 0 {name=l36 lab=VDD}
C {devices/gnd.sym} 20 730 0 0 {name=l37 lab=GND}
C {inv_starved.sym} -1130 670 0 0 {name=x16}
C {lab_pin.sym} -1210 600 0 0 {name=p37 sig_type=std_logic lab=vbp}
C {lab_pin.sym} -1210 740 0 0 {name=p38 sig_type=std_logic lab=vbn}
C {inv_starved.sym} -830 670 0 0 {name=x17}
C {devices/vdd.sym} -820 610 0 0 {name=l42 lab=VDD}
C {devices/gnd.sym} -820 730 0 0 {name=l43 lab=GND}
C {lab_pin.sym} 1160 740 2 0 {name=p35 sig_type=std_logic lab=vx2}
C {devices/vdd.sym} 1100 700 0 0 {name=l38 lab=VDD}
C {devices/gnd.sym} 1060 780 0 0 {name=l39 lab=GND}
C {xor_new.sym} 1040 740 0 0 {name=x15
type=subcircuit
format="@name @pinlist gf180mcu_fd_sc_mcu7t5v0__xor2_1"}
C {devices/gnd.sym} 1100 780 0 0 {name=l44 lab=GND}
C {devices/vdd.sym} 1060 700 0 0 {name=l45 lab=VDD}
C {capa.sym} 1160 770 0 0 {name=C2
m=1
value=10f
footprint=1206
device="ceramic capacitor"}
C {devices/gnd.sym} 1160 800 0 0 {name=l46 lab=GND}
C {lab_pin.sym} -910 600 0 0 {name=p24 sig_type=std_logic lab=vbp}
C {lab_pin.sym} -910 740 0 0 {name=p25 sig_type=std_logic lab=vbn}
C {lab_pin.sym} -670 600 0 0 {name=p26 sig_type=std_logic lab=vbp}
C {lab_pin.sym} -670 740 0 0 {name=p27 sig_type=std_logic lab=vbn}
C {lab_pin.sym} -370 600 0 0 {name=p29 sig_type=std_logic lab=vbp}
C {lab_pin.sym} -370 740 0 0 {name=p30 sig_type=std_logic lab=vbn}
C {lab_pin.sym} -70 600 0 0 {name=p31 sig_type=std_logic lab=vbp}
C {lab_pin.sym} -70 740 0 0 {name=p32 sig_type=std_logic lab=vbn}
C {lab_pin.sym} 230 600 0 0 {name=p33 sig_type=std_logic lab=vbp}
C {lab_pin.sym} 230 740 0 0 {name=p34 sig_type=std_logic lab=vbn}
C {lab_pin.sym} 530 600 0 0 {name=p36 sig_type=std_logic lab=vbp}
C {lab_pin.sym} 530 740 0 0 {name=p39 sig_type=std_logic lab=vbn}
C {inv_starved.sym} 310 970 0 0 {name=x18}
C {inv_starved.sym} 610 970 0 0 {name=x19}
C {devices/vdd.sym} 620 910 0 0 {name=l28 lab=VDD}
C {devices/gnd.sym} 620 1030 0 0 {name=l29 lab=GND}
C {lab_pin.sym} 760 970 2 0 {name=p40 sig_type=std_logic lab=osc9}
C {inv_starved.sym} -590 970 0 0 {name=x20}
C {devices/vdd.sym} -580 910 0 0 {name=l47 lab=VDD}
C {devices/gnd.sym} -580 1030 0 0 {name=l48 lab=GND}
C {inv_starved.sym} -290 970 0 0 {name=x21}
C {devices/vdd.sym} -280 910 0 0 {name=l49 lab=VDD}
C {devices/gnd.sym} -280 1030 0 0 {name=l50 lab=GND}
C {inv_starved.sym} 10 970 0 0 {name=x22}
C {devices/vdd.sym} 20 910 0 0 {name=l51 lab=VDD}
C {devices/gnd.sym} 20 1030 0 0 {name=l52 lab=GND}
C {inv_starved.sym} -1130 970 0 0 {name=x23}
C {devices/vdd.sym} -1120 910 0 0 {name=l53 lab=VDD}
C {devices/gnd.sym} -1120 1030 0 0 {name=l54 lab=GND}
C {inv_starved.sym} -830 970 0 0 {name=x24}
C {devices/vdd.sym} -820 910 0 0 {name=l55 lab=VDD}
C {devices/gnd.sym} -820 1030 0 0 {name=l56 lab=GND}
C {inv_starved.sym} -1380 970 0 0 {name=x25}
C {devices/vdd.sym} -1370 910 0 0 {name=l57 lab=VDD}
C {devices/gnd.sym} -1370 1030 0 0 {name=l58 lab=GND}
C {inv_starved.sym} -1620 970 0 0 {name=x26}
C {lab_pin.sym} -1700 900 0 0 {name=p55 sig_type=std_logic lab=vbp}
C {lab_pin.sym} -1700 1040 0 0 {name=p56 sig_type=std_logic lab=vbn}
C {lab_pin.sym} -1460 900 0 0 {name=p41 sig_type=std_logic lab=vbp}
C {lab_pin.sym} -1460 1040 0 0 {name=p42 sig_type=std_logic lab=vbn}
C {lab_pin.sym} -1210 900 0 0 {name=p43 sig_type=std_logic lab=vbp}
C {lab_pin.sym} -1210 1040 0 0 {name=p44 sig_type=std_logic lab=vbn}
C {lab_pin.sym} -910 900 0 0 {name=p45 sig_type=std_logic lab=vbp}
C {lab_pin.sym} -910 1040 0 0 {name=p46 sig_type=std_logic lab=vbn}
C {lab_pin.sym} -670 900 0 0 {name=p47 sig_type=std_logic lab=vbp}
C {lab_pin.sym} -670 1040 0 0 {name=p48 sig_type=std_logic lab=vbn}
C {lab_pin.sym} -370 900 0 0 {name=p49 sig_type=std_logic lab=vbp}
C {lab_pin.sym} -370 1040 0 0 {name=p50 sig_type=std_logic lab=vbn}
C {lab_pin.sym} -70 900 0 0 {name=p51 sig_type=std_logic lab=vbp}
C {lab_pin.sym} -70 1040 0 0 {name=p52 sig_type=std_logic lab=vbn}
C {lab_pin.sym} 230 900 0 0 {name=p53 sig_type=std_logic lab=vbp}
C {lab_pin.sym} 230 1040 0 0 {name=p54 sig_type=std_logic lab=vbn}
C {lab_pin.sym} 530 900 0 0 {name=p57 sig_type=std_logic lab=vbp}
C {lab_pin.sym} 530 1040 0 0 {name=p58 sig_type=std_logic lab=vbn}
C {lab_pin.sym} 1390 480 2 0 {name=p59 sig_type=std_logic lab=vo}
C {devices/vdd.sym} 1330 440 0 0 {name=l61 lab=VDD}
C {devices/gnd.sym} 1290 520 0 0 {name=l62 lab=GND}
C {xor_new.sym} 1270 480 0 0 {name=x27
type=subcircuit
format="@name @pinlist gf180mcu_fd_sc_mcu7t5v0__xor2_1"}
C {devices/gnd.sym} 1330 520 0 0 {name=l63 lab=GND}
C {devices/vdd.sym} 1290 440 0 0 {name=l64 lab=VDD}
C {capa.sym} 1390 510 0 0 {name=C3
m=1
value=10f
footprint=1206
device="ceramic capacitor"}
C {devices/gnd.sym} 1390 540 0 0 {name=l65 lab=GND}
C {lab_pin.sym} -380 240 0 0 {name=p13 sig_type=std_logic lab=vbp}
C {lab_pin.sym} -380 380 0 0 {name=p14 sig_type=std_logic lab=vbn}
C {lab_pin.sym} -80 240 0 0 {name=p15 sig_type=std_logic lab=vbp}
C {lab_pin.sym} -80 380 0 0 {name=p16 sig_type=std_logic lab=vbn}
C {lab_pin.sym} 220 240 0 0 {name=p20 sig_type=std_logic lab=vbp}
C {lab_pin.sym} 220 380 0 0 {name=p21 sig_type=std_logic lab=vbn}
C {lab_pin.sym} 520 240 0 0 {name=p22 sig_type=std_logic lab=vbp}
C {lab_pin.sym} 520 380 0 0 {name=p23 sig_type=std_logic lab=vbn}
C {devices/vdd.sym} -1610 910 0 0 {name=l40 lab=VDD}
C {devices/vdd.sym} -1120 610 0 0 {name=l41 lab=VDD}
C {devices/gnd.sym} -1120 730 0 0 {name=l59 lab=GND}
C {devices/gnd.sym} -1610 1030 0 0 {name=l60 lab=GND}
C {devices/vdd.sym} 320 610 0 0 {name=l30 lab=VDD}
C {devices/vdd.sym} 620 610 0 0 {name=l31 lab=VDD}
C {devices/gnd.sym} 320 730 0 0 {name=l70 lab=GND}
C {devices/gnd.sym} 620 730 0 0 {name=l71 lab=GND}
C {devices/vdd.sym} 320 910 0 0 {name=l72 lab=VDD}
C {devices/gnd.sym} 320 1030 0 0 {name=l73 lab=GND}
C {biasing.sym} -1010 190 0 0 {name=x28}
C {lab_pin.sym} -860 180 2 0 {name=p2 sig_type=std_logic lab=vbp}
C {lab_pin.sym} -860 200 2 0 {name=p4 sig_type=std_logic lab=vbn}
C {devices/vdd.sym} -860 160 0 0 {name=l3 lab=VDD}
C {devices/gnd.sym} -860 220 0 0 {name=l5 lab=GND}
C {devices/vsource.sym} -1280 330 0 0 {name=V2 value=1.05 savecurrent=false}
C {devices/gnd.sym} -1280 400 0 0 {name=l12 lab=GND}
