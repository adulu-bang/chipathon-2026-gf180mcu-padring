module trng_top (
    input  wire clk,
    input  wire rst_n,
    input  wire enable,

    // outp from analog XOR (ip to dig bbox)
    input  wire trng_async,

    // uart op
    output wire uart_tx,
    output wire uart_busy,

    // optional
    output wire apt_pass,
    output wire rct_pass
);


    wire sync_bit;

    wire whiten_bit;
    wire whiten_valid;

    wire bist_bit;
    wire bist_valid;


    sync_2ff u_sync (
        .clk      (clk),
        .rst_n    (rst_n),
        .async_in (trng_async),
        .sync_out (sync_bit)
    );


    von_neumann_whitener u_whitener (
        .clk        (clk),
        .rst_n      (rst_n),
        .trng_bit   (sync_bit),
        .whiten_bit (whiten_bit),
        .valid      (whiten_valid)
    );


    bist u_bist (
        .clk              (clk),
        .rst_n            (rst_n),
        .enable           (enable),
        .whitened_in      (whiten_bit),
        .whitened_valid   (whiten_valid),

        .bitstream_out    (bist_bit),
        .a_p_test_valid   (apt_pass),
        .r_c_test_valid   (rct_pass),
        .valid_out        (bist_valid)
    );


    uart_tx #(
        .CLKS_PER_BIT(87)
    ) u_uart (

        .clk        (clk),
        .rst_n      (rst_n),
        .enable     (enable),

        .data_in    (bist_bit),
        .valid_in   (bist_valid),

        .uart_tx    (uart_tx),
        .uart_busy  (uart_busy)
    );

endmodule
