## Track: A <br>Team: A53 IRIS Labs Hardware <br>Project: Ring Oscillator Based True Random Number Generator With Built In Self Test

| Discord | Github | Affiliation (experience) | Role |
|---|---|---|---|
| adulubang | @adulu-bang | NITK, Surathkal (senior undergrad) | Team Lead |
| qwerty_1_4_ | @Adithya1435 | NITK, Surathkal (senior undergrad) | - |
| theswiftykoala | @shamithoysal  | NITK, Surathkal (junior undergrad) | - |
| c9546r | @ChetanSK7 | NITK, Surathkal (junior undergrad) | - |
| Parthip Dev | @PDK34 | NITK, Surathkal (junior undergrad) | - |
| krishmehta1002 | @krishmehta5760-design | NITK, Surathkal (junior undergrad) | - |
| vishva_0711| @Vishva2006chavada | NITK, Surathkal (junior undergrad) | - |

Overview: This project implements a secure True Random Number Generator (TRNG) on GF180MCU using thermal noise induced jitter. It features a dual-oscillator entropy source, a [Von Neumann hardware whitener](https://en.wikipedia.org/wiki/Randomness_extractor#Von_Neumann_extractor) to eliminate silicon bias, and a [NIST SP 800-90B compliant BIST](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-90B.pdf) engine for real-time security monitoring. The design integrates via a 32-bit Wishbone interface, providing validated entropy with automatic hardware interrupts upon statistical failure.

Target Specs: 3.3V, ~2.5 Mbps (Whitened) throughput, NIST-compliant health monitoring, and Wishbone integration.


Size: Comfortably within **Block D** constraints (< 312,000 μm^2)
Required pins (10): 

1. VDD (3.3V)
2. rst
3. clk
4. analog_raw_out
5. raw_bitstream_out
6. whitened_bitstream_out
7. test_data_in
8. test_mode_en
9. data_serial_out
10. bist_flag_out

## Acknowledgments
This project is built using the Chipathon 2026 GF180MCU Padring wrapper, derived from the `wafer-space/gf180mcu-project-template` and Juan Moya's `padring_gf180`. See `CREDITS.md` and `NOTICE` for full upstream attribution.