module Countdown(
    input wire clk_countdown,
    input wire rst,
    input wire start,
    output reg [1:0] anode,
    output reg countdown_done,
    output reg countdown_in_action
);

always @(posedge clk_countdown or posedge rst or posedge start) begin
    if (rst) begin
        anode <= 2'b00;
        countdown_done <= 0;
        countdown_in_action <= 0;
    end else if (start) begin
        anode <= 2'b00;
        countdown_done <= 0;
        countdown_in_action <= 1;
    end else begin
        if (countdown_in_action) begin
            if (anode == 2'd3) begin
                countdown_done <= 1;
                countdown_in_action <= 0;
            end else begin
                anode <= anode + 1;
                countdown_done <= 0;
            end
        end else begin
            countdown_done <= 0;
        end
    end
end

endmodule
