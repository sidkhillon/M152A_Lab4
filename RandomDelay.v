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

wire feedback = lfsr[15] ^ lfsr[14] ^ lfsr[12] ^ lfsr[3];

always @(posedge clk or posedge rst or posedge start) begin
    if (rst) begin
        lfsr <= 16'hACE1;
        delay_active <= 0;
        done_reg <= 0;
        counter <= 0;
        delay_ms <= 0;
    end else if (start) begin
        delay_active <= 1;
        done_reg <= 0;
        counter <= 0;
        delay_ms <= (lfsr[11:0] % 4000) + 1000;
    end else begin
        if (delay_active) begin
            lfsr <= {lfsr[14:0], feedback};
            if (counter == delay_ms - 1) begin
                delay_active <= 0;
                done_reg <= 1;
            end
        end
    end
end

always @(posedge clk_1kHz) begin
    if (delay_active && counter < delay_ms - 1) begin
        counter <= counter + 1;
    end
end

assign done = done_reg;

endmodule
