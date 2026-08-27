module A53_trng_top (
    inout  wire VDD,
    inout  wire GND,
    input  wire clk,
    input  wire rst_n,
    input  wire test_mode_en,
    input  wire test_data_in,
    input  wire vin_vco,
    output wire analog_raw_out,
    output wire data_serial_out,
    output wire bist_flag_out
);

    // Internal inter-block wires
    wire raw_trng_sig;
    wire apt_pass_w;
    wire rct_pass_w;
    wire uart_busy_w;

    // Connect raw analog signal directly to digital async input and pad
    assign analog_raw_out = raw_trng_sig;
    assign bist_flag_out  = apt_pass_w & rct_pass_w;

    //Analog Macro Instance
    ring_oscillator_final u_analog (
        .VDD(VDD),
        .GND(GND),
        .VinVCO(vin_vco),
        .VO(raw_trng_sig)
    );

    // Digital Core Instance
    trng_top u_digital (
        .vccd1(VDD),      
        .vssd1(GND),
        .clk(clk),
        .rst_n(rst_n),
        .enable(test_mode_en),
        .trng_async(raw_trng_sig),
        .uart_tx(data_serial_out),
        .uart_busy(uart_busy_w),
        .apt_pass(apt_pass_w),
        .rct_pass(rct_pass_w)
    );

endmodule