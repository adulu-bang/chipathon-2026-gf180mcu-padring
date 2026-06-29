# Ring Oscillator Based True Random Number Generator With Built-In Self Test

## 1. Project Information
* **Track:** A
* **Team:** A53 IRIS Labs Hardware
* **Team Members:**
  * @adulu-bang (NITK, Surathkal - Senior Undergrad) - Team Lead
  * @Adithya1435 (NITK, Surathkal - Senior Undergrad)
  * @shamithoysal (NITK, Surathkal - Junior Undergrad)
  * @ChetanSK7 (NITK, Surathkal - Junior Undergrad)
  * @PDK34 (NITK, Surathkal - Junior Undergrad)
  * @krishmehta5760-design (NITK, Surathkal - Junior Undergrad)
  * @Vishva2006chavada (NITK, Surathkal - Junior Undergrad)

## 2. Design Objectives
Implement a secure True Random Number Generator (TRNG) on GF180MCU using thermal noise-induced jitter, providing validated entropy with automatic hardware interrupts upon statistical failure.

**Target Specifications:**
* **Supply Voltage:** 3.3V
* **Throughput:** ~2.5 Mbps (Whitened)
* **Features:** NIST-compliant health monitoring, 32-bit Wishbone integration
* **Area Constraints:** Comfortably within Block D constraints (< 312,000 μm²)

## 3. System Overview
* **Entropy Source:** Dual-oscillator (Ring Oscillators)
* **Post-Processing:** [Von Neumann hardware whitener](https://en.wikipedia.org/wiki/Randomness_extractor#Von_Neumann_extractor) to eliminate silicon bias.
* **Health Monitoring:** [NIST SP 800-90B compliant BIST](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-90B.pdf) engine for real-time security monitoring.
* **Interface:** 32-bit Wishbone interface.

## 4. Schematic Summary
**Required Pins (10 for Block D):**
1. `VDD` (3.3V)
2. `rst`
3. `clk`
4. `analog_raw_out`
5. `raw_bitstream_out`
6. `whitened_bitstream_out`
7. `test_data_in`
8. `test_mode_en`
9. `data_serial_out`
10. `bist_flag_out`

* **Purpose:** [ ]
* **Important Design Decisions:** [ ]
* **Interfaces to other blocks:** 32-bit Wishbone

## 5. Design Assumptions
* **Process:** GF180MCU
* **Supply Voltages:** 3.3V
* **Temperature Range:** [ ]
* **Process Corners:** [ ]
* **Expected Loads:** [ ]

## 6. Verification Status
* **Functional Simulations:** [ ]
* **Corner Simulations:** [ ]
* **Monte Carlo:** [ ]
* **ERC Status:** [ ]
* **LVS Status:** [ ]
* **DRC Status:** [ ]

## 7. Design Checklist
* **Functionality:** [ ]
* **Analog:** [ ]
* **Digital:** [ ]
* **Mixed Signal:** [ ]
* **Reliability:** [ ]
* **Documentation:** [ ]

## 8. Open Issues
* [ ]

## 9. Questions for Reviewers
* [ ]

## 10. Review Outcome
* [ ]

## Appendix
* **Embedded Video Link:** [ ]
* **Full Schematic Review Link:** [ ]

## Acknowledgments
This project is built using the Chipathon 2026 GF180MCU Padring wrapper, derived from the `wafer-space/gf180mcu-project-template` and Juan Moya's `padring_gf180`. See `CREDITS.md` and `NOTICE` for full upstream attribution.