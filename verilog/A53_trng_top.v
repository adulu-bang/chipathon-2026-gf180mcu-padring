module A53_trng_top (
    `ifdef USE_POWER_PINS
        inout  wire VDD,
        inout  wire GND,
   `endif
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
    wire trng_out;


    // Connect raw analog signal directly to digital async input and pad
    assign analog_raw_out = raw_trng_sig;
    assign bist_flag_out  = apt_pass_w & rct_pass_w;

    assign data_serial_out = test_mode_en? test_data_in : trng_out;

    //Analog Macro Instance
    ring_oscillator_final u_analog (
        `ifdef USE_POWER_PINS
        .VDD(VDD),
        .GND(GND),
       `endif
        .VinVCO(vin_vco),
        .VO(raw_trng_sig)
    );

    
    // Digital Core Instance
    trng_top u_digital (
        `ifdef USE_POWER_PINS
        .vccd1(VDD),      
        .vssd1(GND),
        `endif
        .clk(clk),
        .rst_n(rst_n),
        .enable(test_mode_en),
        .trng_async(raw_trng_sig),
        .uart_tx(trng_out),
        .uart_busy(uart_busy_w),
        .apt_pass(apt_pass_w),
        .rct_pass(rct_pass_w)
    );

endmodule