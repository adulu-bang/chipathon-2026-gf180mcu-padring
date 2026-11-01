(* blackbox *)
module trng_top (
    `ifdef USE_POWER_PINS
    inout wire vccd1,
    inout wire vssd1,
`endif

    input  wire clk,
    input  wire rst_n,
    input  wire enable,
    input  wire trng_async,
    output wire uart_tx,
    output wire uart_busy,
    output wire apt_pass,
    output wire rct_pass
);
// Dummy module for the hardened digital macro
endmodule