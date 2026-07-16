module von_neumann_whitener (
    input  wire clk,
    input  wire rst_n,
    input  wire trng_bit,

    output reg  whiten_bit,
    output reg  valid
);

    reg first_bit;
    reg bit_count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            first_bit  <= 1'b0;
            bit_count  <= 1'b0;
            whiten_bit <= 1'b0;
            valid      <= 1'b0;
        end
        else begin
            if (bit_count == 1'b0) begin
                first_bit <= trng_bit;
                bit_count <= 1'b1;
                valid     <= 1'b0;
            end
            else begin
                bit_count <= 1'b0;

                if (first_bit != trng_bit) begin
                    whiten_bit <= first_bit;
                    valid      <= 1'b1;
                end
                else begin
                    valid <= 1'b0;
                end
            end
        end
    end

endmodule
