v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 540 -430 600 -430 {lab=vi}
N 540 -430 540 -270 {lab=vi}
N 540 -270 600 -270 {lab=vi}
N 510 -350 540 -350 {lab=vi}
N 640 -400 640 -300 {lab=vo}
N 640 -350 760 -350 {lab=vo}
N 640 -520 640 -460 {lab=#net1}
N 640 -430 670 -430 {lab=vdd}
N 670 -490 670 -430 {lab=vdd}
N 640 -240 640 -200 {lab=#net2}
N 640 -270 670 -270 {lab=vss}
N 670 -270 670 -210 {lab=vss}
N 640 -170 650 -170 {lab=vss}
N 650 -170 650 -140 {lab=vss}
N 640 -140 650 -140 {lab=vss}
N 640 -550 650 -550 {lab=vdd}
N 650 -580 650 -550 {lab=vdd}
N 640 -580 650 -580 {lab=vdd}
N 670 -580 670 -490 {lab=vdd}
N 650 -580 670 -580 {lab=vdd}
N 670 -210 670 -140 {lab=vss}
N 640 -140 670 -140 {lab=vss}
C {devices/title.sym} 170 -50 0 0 {name=l1 author="M. Koefinger"}
C {symbols/nfet_03v3.sym} 620 -270 0 0 {name=M1
L=0.28u
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
C {symbols/pfet_03v3.sym} 620 -430 0 0 {name=M2
L=0.28u
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
C {devices/iopin.sym} 640 -580 3 0 {name=p1 lab=vdd}
C {devices/iopin.sym} 640 -140 1 0 {name=p2 lab=vss}
C {devices/ipin.sym} 510 -350 0 0 {name=p3 lab=vi}
C {devices/opin.sym} 760 -350 0 0 {name=p4 lab=vo}
C {symbols/pfet_03v3.sym} 620 -550 0 0 {name=M3
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
C {symbols/nfet_03v3.sym} 620 -170 0 0 {name=M4
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
C {devices/ipin.sym} 600 -550 0 0 {name=p5 lab=vbp}
C {devices/ipin.sym} 600 -170 0 0 {name=p6 lab=vbn}
