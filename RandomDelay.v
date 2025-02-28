module RandomDelay(
    input wire clk,
    input wire clk_1kHz,
    input wire rst,
    input wire start,
    output wire done
);

reg [15:0] lfsr;
reg [12:0] counter;
reg [12:0] delay_ms;
reg delay_active;
reg done_reg;
reg clk_1kHz_prev;

wire feedback = lfsr[15] ^ lfsr[14] ^ lfsr[12] ^ lfsr[3];

// Main logic block
always @(posedge clk or posedge rst) begin
    if (rst) begin
        lfsr <= 16'hACE1;
        delay_active <= 0;
        done_reg <= 0;
        counter <= 0;
        delay_ms <= 0;
        clk_1kHz_prev <= 0;
    end else if (start) begin
        delay_active <= 1;
        done_reg <= 0;
        counter <= 0;
        delay_ms <= (lfsr[11:0] % 4000) + 1000;
        clk_1kHz_prev <= clk_1kHz;
    end else begin
        // Update LFSR on every clock
        lfsr <= {lfsr[14:0], feedback};
        
        // Detect rising edge of clk_1kHz
        clk_1kHz_prev <= clk_1kHz;
        
        // Only increment counter on rising edge of clk_1kHz
        if (clk_1kHz && !clk_1kHz_prev && delay_active) begin
            if (counter == delay_ms - 1) begin
                delay_active <= 0;
                counter <= 0;
                done_reg <= 1;
            end else begin
                counter <= counter + 1;
            end
        end
    end
end

assign done = done_reg;

endmodule