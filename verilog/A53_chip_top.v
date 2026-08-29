`default_nettype none

module A53_chip_top (
    inout  wire GND,
    inout  wire VDD,

    // ----------------------------------------------------
    // Input Pins (Pad pull-up/pull-down control)
    // ----------------------------------------------------
    input  wire clk,
    output wire clk_PU,
    output wire clk_PD,

    input  wire rst_n,
    output wire rst_n_PU,
    output wire rst_n_PD,

    input  wire test_mode_en,
    output wire test_mode_en_PU,
    output wire test_mode_en_PD,

    input  wire test_data_in,
    output wire test_data_in_PU,
    output wire test_data_in_PD,

    // ----------------------------------------------------
    // Output Pad: data_serial_out
    // ----------------------------------------------------
    output wire data_serial_out_CS,
    output wire data_serial_out_SL,
    output wire data_serial_out_IE,
    output wire data_serial_out_OE,
    output wire data_serial_out_PU,
    output wire data_serial_out_PD,
    output wire data_serial_out_OUT,
    output wire data_serial_out_PDRV0,
    output wire data_serial_out_PDRV1,
    input  wire data_serial_out_IN,

    // ----------------------------------------------------
    // Output Pad: bist_flag_out
    // ----------------------------------------------------
    output wire bist_flag_out_CS,
    output wire bist_flag_out_SL,
    output wire bist_flag_out_IE,
    output wire bist_flag_out_OE,
    output wire bist_flag_out_PU,
    output wire bist_flag_out_PD,
    output wire bist_flag_out_OUT,
    output wire bist_flag_out_PDRV0,
    output wire bist_flag_out_PDRV1,
    input  wire bist_flag_out_IN,

    // ----------------------------------------------------
    // Analog / Direct INOUTs
    // ----------------------------------------------------
    inout  wire vin_vco,
    inout  wire analog_raw_out
);

    // ====================================================
    // 1. Input Pad Configuration (Pull-ups / Pull-downs)
    // ====================================================
    assign clk_PU = 1'b0;
    assign clk_PD = 1'b0;
    
    assign rst_n_PU = 1'b1;  // Pull-up active for active-low reset
    assign rst_n_PD = 1'b0;
    
    assign test_mode_en_PU = 1'b0;
    assign test_mode_en_PD = 1'b1; // Pull-down so test mode is disabled by default
    
    assign test_data_in_PU = 1'b0;
    assign test_data_in_PD = 1'b0;

    // ====================================================
    // 2. Output Pad Configuration (data_serial_out)
    // ====================================================
    assign data_serial_out_OE    = 1'b1; // OE=1, IE=0: Output Enabled
    assign data_serial_out_IE    = 1'b0;
    assign data_serial_out_CS    = 1'b0; // CMOS Buffer
    assign data_serial_out_SL    = 1'b0; // Fast Slew
    assign data_serial_out_PU    = 1'b0; // No pulls
    assign data_serial_out_PD    = 1'b0;
    assign data_serial_out_PDRV0 = 1'b1; // 8mA Drive (01)
    assign data_serial_out_PDRV1 = 1'b0;

    // ====================================================
    // 3. Output Pad Configuration (bist_flag_out)
    // ====================================================
    assign bist_flag_out_OE    = 1'b1; // OE=1, IE=0: Output Enabled
    assign bist_flag_out_IE    = 1'b0;
    assign bist_flag_out_CS    = 1'b0; // CMOS Buffer
    assign bist_flag_out_SL    = 1'b0; // Fast Slew
    assign bist_flag_out_PU    = 1'b0; // No pulls
    assign bist_flag_out_PD    = 1'b0;
    assign bist_flag_out_PDRV0 = 1'b1; // 8mA Drive (01)
    assign bist_flag_out_PDRV1 = 1'b0;

    // Sink unused _IN signals from output pads to prevent linter warnings
    wire _unused_in;
    assign _unused_in = data_serial_out_IN ^ bist_flag_out_IN;

    // ====================================================
    // 4. Instantiate Inner Core (A53_trng_top)
    // ====================================================
    A53_trng_top u_trng_core (
        .VDD(VDD),
        .GND(GND),
        .clk(clk),
        .rst_n(rst_n),
        .test_mode_en(test_mode_en),
        .test_data_in(test_data_in),
        .vin_vco(vin_vco),
        .analog_raw_out(analog_raw_out),
        // Connect core outputs to the _OUT pin of the digital pad
        .data_serial_out(data_serial_out_OUT),
        .bist_flag_out(bist_flag_out_OUT)
    );

endmodule
`default_nettype wire