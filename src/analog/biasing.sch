v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 90 50 100 50 {lab=Vss}
N 100 50 100 80 {lab=Vss}
N 90 -10 90 20 {lab=VbpOUT}
N 280 -40 290 -40 {lab=Vdd}
N 290 -70 290 -40 {lab=Vdd}
N 280 -70 290 -70 {lab=Vdd}
N 280 50 290 50 {lab=Vss}
N 290 50 290 80 {lab=Vss}
N 280 80 290 80 {lab=Vss}
N 280 -10 280 20 {lab=VbnOUT}
N 80 -40 90 -40 {lab=Vdd}
N 80 -70 80 -40 {lab=Vdd}
N 80 -70 280 -70 {lab=Vdd}
N 130 -40 240 -40 {lab=VbpOUT}
N 180 -40 180 -20 {lab=VbpOUT}
N 240 20 280 20 {lab=VbnOUT}
N 240 20 240 50 {lab=VbnOUT}
N 90 80 280 80 {lab=Vss}
N 90 -10 130 -10 {lab=VbpOUT}
N 130 -40 130 -10 {lab=VbpOUT}
C {symbols/pfet_03v3.sym} 110 -40 0 1 {name=M3
L=0.5u
W=2u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 70 50 0 0 {name=M4
L=0.5u
W=1u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {iopin.sym} 180 -70 3 0 {name=p2 lab=Vdd}
C {iopin.sym} 180 80 1 0 {name=p1 lab=Vss}
C {ipin.sym} 50 50 0 0 {name=p5 lab=VinVCO

}
C {opin.sym} 180 -20 1 0 {name=p4 lab=VbpOUT}
C {symbols/pfet_03v3.sym} 260 -40 0 0 {name=M1
L=0.5u
W=2u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 260 50 0 0 {name=M2
L=0.5u
W=1u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {opin.sym} 280 10 0 0 {name=p3 lab=VbnOUT}
