v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 80 -110 120 -110 {lab=va1}
N 120 -120 120 -110 {lab=va1}
N 120 -120 130 -120 {lab=va1}
N 80 -70 120 -70 {lab=va2}
N 120 -70 120 -60 {lab=va2}
N 120 -60 130 -60 {lab=va2}
N 200 -90 250 -90 {lab=vout}
C {vsource.sym} -390 0 0 0 {name=V1 value=5 savecurrent=false}
C {gnd.sym} -390 30 0 0 {name=l19 lab=0}
C {vdd.sym} -390 -30 0 0 {name=l20 lab=VDD}
C {vsource.sym} -330 0 0 0 {name=V2 value="PULSE(0 5 0 100p 100p 2n 4n)" savecurrent=false}
C {gnd.sym} -330 30 0 0 {name=l21 lab=0}
C {lab_pin.sym} -330 -30 1 0 {name=p21 sig_type=std_logic lab=va1}
C {gnd.sym} -160 -40 0 0 {name=l1 lab=0}
C {lab_pin.sym} -160 -100 1 0 {name=p3 sig_type=std_logic lab=va2}
C {vsource.sym} -160 -70 0 0 {name=V3 value="PULSE(0 5 0 100p 100p 4n 8n)" savecurrent=false}
C {simulator_commands.sym} 470 -390 0 0 {name=COMMANDS
simulator=ngspice
only_toplevel=false 
value="
.control
save all


** Simulations
op
tran 10p 10n

** Plots
setplot tran1

plot v(va1) v(va2) v(vout)

setplot op1
write xor_tb.raw
.endc
"}
C {devices/code_shown.sym} -595.128375 -364.5474999999999 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.include /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_sc_mcu7t5v0/spice/gf180mcu_fd_sc_mcu7t5v0.spice
"}
C {lab_pin.sym} 80 -110 0 0 {name=p1 sig_type=std_logic lab=va1}
C {vdd.sym} 150 -130 0 0 {name=l2 lab=VDD}
C {vdd.sym} 190 -130 0 0 {name=l3 lab=VDD}
C {gnd.sym} 150 -50 0 0 {name=l4 lab=0}
C {gnd.sym} 190 -50 0 0 {name=l5 lab=0}
C {lab_pin.sym} 80 -70 0 0 {name=p2 sig_type=std_logic lab=va2}
C {xor_new.sym} 130 -90 0 0 {name=x1
type=subcircuit
format="@name @pinlist gf180mcu_fd_sc_mcu7t5v0__xor2_1"}
C {lab_pin.sym} 250 -90 2 0 {name=p4 sig_type=std_logic lab=vout}
