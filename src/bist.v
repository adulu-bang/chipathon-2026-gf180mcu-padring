module bist #(
    parameter RCT_CUTOFF = 41,
    parameter APT_CUTOFF = 589,
    parameter APT_WINDOW = 1024
) (
    input wire clk,
    input wire rst_n,
    input wire enable,
    input wire whitened_in,
    input wire whitened_valid,

    output wire bitstream_out,
    output reg a_p_test_valid,
    output reg r_c_test_valid,
    output wire valid_out
);

    reg rct_input_bit;
    reg [5:0] rct_counter;

    reg apt_input_bit;
    reg [9:0] window;
    reg [9:0] apt_counter;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rct_input_bit <= 1'b0;
            rct_counter <= 6'd1;
            r_c_test_valid <= 1'b1;
            
            apt_input_bit <= 1'b0;
            window <= 10'd0;
            apt_counter <= 10'd0;
            a_p_test_valid <= 1'b1;
        end else if (enable) begin
            if (whitened_valid) begin
                // -----------------------------
                // RCT Logic
                // -----------------------------
                if (rct_input_bit == whitened_in) begin
                    rct_counter <= rct_counter + 1'b1;
                    if (rct_counter >= RCT_CUTOFF - 1) begin
                        r_c_test_valid <= 1'b0;
                        // handle correction logic in future 
                    end
                end else begin
                    rct_counter <= 6'd1;
                    rct_input_bit <= whitened_in;
                end            

                // -----------------------------
                // APT Logic
                // -----------------------------
                if (window == 10'd0) begin
                    apt_counter <= 10'd1;
                    window <= 10'd1;
                    apt_input_bit <= whitened_in;
                end else begin
                    window <= window + 1'b1;

                    if (apt_input_bit == whitened_in) begin
                        apt_counter <= apt_counter + 1'b1;
                        if (apt_counter >= APT_CUTOFF - 1) begin
                            a_p_test_valid <= 1'b0;
                            // handle correction logic in future 
                        end
                    end

                    if (window == APT_WINDOW - 1) begin
                        window <= 10'd0;
                    end
                end
            end
        end
    end

    assign valid_out = a_p_test_valid && r_c_test_valid;
    assign bitstream_out = valid_out ? whitened_in : 1'b0;

endmodule