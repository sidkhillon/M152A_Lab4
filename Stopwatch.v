module Stopwatch(
    input wire clk_1kHz,
    input wire rst,
    input wire pause,
    output wire [3:0] sec0,
    output wire [3:0] ms2,
    output wire [3:0] ms1,
    output wire [3:0] ms0
);

reg [3:0] seconds;
reg [9:0] ms;

always @(posedge clk_1kHz or posedge rst) begin
    if (rst) begin
        seconds <= 4'd0;
        ms <= 10'd0;
    end else begin
        if (!pause) begin
            if (ms == 10'd999) begin
                ms <= 10'd0;
                seconds <= seconds + 1;
            end else begin
                ms <= ms + 1;
            end
        end
    end
end

assign sec0 = seconds[3:0];
assign ms2 = ms / 100;
assign ms1 = (ms % 100) / 10;
assign ms0 = ms % 10;

endmodule