module uart_tx #(parameter CLKS_PER_BIT = 87)(
    input wire clk,
    input wire rst_n,
    input wire enable,
    input wire data_in,
    input wire valid_in,
    output wire uart_tx,
    output wire uart_busy
);
    reg [7:0] assemble_reg;
    reg [2:0] assemble_count;
    reg byte_ready;
    reg [7:0] tx_buffer;
    reg [1:0] state;
    reg [6:0] clk_count;
    reg [2:0] bit_index;
    reg tx_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            assemble_count <= 3'd0;
            assemble_reg <= 8'd0;
            byte_ready <= 1'b0;
            tx_buffer <= 8'd0;
        end else if (enable) begin
            if (byte_ready && state == 2'b00) byte_ready <= 1'b0;
            if (valid_in && !byte_ready) begin
                assemble_reg <= {data_in, assemble_reg[7:1]};
                if (assemble_count == 3'd7) begin
                    assemble_count <= 3'd0;
                    tx_buffer <= {data_in, assemble_reg[7:1]};
                    byte_ready <= 1'b1;
                end else begin
                    assemble_count <= assemble_count + 1'b1;
                end
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= 2'b00;
            clk_count <= 7'd0;
            bit_index <= 3'd0;
            tx_reg <= 1'b1;
        end else if (enable) begin
            case (state)
                2'b00: begin
                    tx_reg <= 1'b1;
                    clk_count <= 7'd0;
                    bit_index <= 3'd0;
                    if (byte_ready) state <= 2'b01;
                end
                2'b01: begin
                    tx_reg <= 1'b0;
                    if (clk_count < CLKS_PER_BIT - 1) clk_count <= clk_count + 1'b1;
                    else begin
                        clk_count <= 7'd0;
                        state <= 2'b10;
                    end
                end
                2'b10: begin
                    tx_reg <= tx_buffer[bit_index];
                    if (clk_count < CLKS_PER_BIT - 1) clk_count <= clk_count + 1'b1;
                    else begin
                        clk_count <= 7'd0;
                        if (bit_index < 3'd7) bit_index <= bit_index + 1'b1;
                        else begin
                            bit_index <= 3'd0;
                            state <= 2'b11;
                        end
                    end
                end
                2'b11: begin
                    tx_reg <= 1'b1;
                    if (clk_count < CLKS_PER_BIT - 1) clk_count <= clk_count + 1'b1;
                    else begin
                        clk_count <= 7'd0;
                        state <= 2'b00;
                    end
                end
            endcase
        end
    end
    
    assign uart_tx = tx_reg;
    assign uart_busy = (state != 2'b00) || byte_ready;
endmodule