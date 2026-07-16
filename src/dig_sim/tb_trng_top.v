`timescale 1ns/1ps

module tb_trng_top;



    reg clk;
    reg rst_n;
    reg enable;



    reg ro1;
    reg ro2;
    reg ro3;
    reg ro4;

    wire trng_async;

    assign trng_async = ro1 ^ ro2 ^ ro3 ^ ro4;



    wire uart_tx;
    wire uart_busy;
    wire apt_pass;
    wire rct_pass;



    trng_top dut (
        .clk(clk),
        .rst_n(rst_n),
        .enable(enable),

        .trng_async(trng_async),

        .uart_tx(uart_tx),
        .uart_busy(uart_busy),

        .apt_pass(apt_pass),
        .rct_pass(rct_pass)
    );


    initial
        clk = 1'b0;

    always #50 clk = ~clk;      // 100 ns period (10 MHz)


    initial begin
        ro1 = 1'b0;
        ro2 = 1'b0;
        ro3 = 1'b0;
        ro4 = 1'b0;
    end

    always #2.43 ro1 = ~ro1;
    always #2.51 ro2 = ~ro2;
    always #2.47 ro3 = ~ro3;
    always #2.56 ro4 = ~ro4;



    initial begin
        enable = 1'b0;
        rst_n  = 1'b0;

        #500;

        rst_n  = 1'b1;
        enable = 1'b1;
    end


    initial begin
        $dumpfile("trng.vcd");
        $dumpvars(0, tb_trng_top);
    end


    initial begin
        #2000000;  
        $finish;
    end

endmodule
