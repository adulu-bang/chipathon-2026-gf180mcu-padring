v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -570 90 -570 130 {lab=GND}
N -570 -30 -570 30 {lab=VDD}
N -440 90 -440 130 {lab=GND}
N -440 -30 -440 30 {lab=#net1}
N -440 -30 -30 -30 {lab=#net1}
C {biasing.sym} 120 0 0 0 {name=x1}
C {devices/code_shown.sym} -450 -220 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.include /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_sc_mcu7t5v0/spice/gf180mcu_fd_sc_mcu7t5v0.spice
.ic v(net1)=0 v(net4)=3.3 v(net7)=0 v(net13)=3.3
"}
C {devices/vsource.sym} -570 60 0 0 {name=V1 value=3.3 savecurrent=false}
C {devices/vdd.sym} -570 -30 0 0 {name=l2 lab=VDD}
C {devices/gnd.sym} -570 130 0 0 {name=l4 lab=GND}
C {devices/vsource.sym} -440 60 0 0 {name=V3 value=2.4 savecurrent=false}
C {devices/gnd.sym} -440 130 0 0 {name=l3 lab=GND}
C {lab_pin.sym} 270 -10 2 0 {name=p4 sig_type=std_logic lab=vbp}
C {lab_pin.sym} 270 10 2 0 {name=p5 sig_type=std_logic lab=vbn}
C {devices/vdd.sym} 270 -30 0 0 {name=l1 lab=VDD}
C {devices/gnd.sym} 270 30 0 0 {name=l5 lab=GND}
C {devices/code_shown.sym} 570 -140 0 0 {name=NGSPICE only_toplevel=true
value="
.control
* Sweep V3 (VinVCO) from 0V to 3.3V in 10mV increments
dc v3 0 3.3 0.01

* Plot the generated bias voltages
plot v(vbp) v(vbn)

* Automatically calculate the exact VinVCO needed for our targets
meas dc target_vin_for_nmos FIND v-sweep WHEN v(vbn)=1.1
meas dc target_vin_for_pmos FIND v-sweep WHEN v(vbp)=2.2
.endc
"}
