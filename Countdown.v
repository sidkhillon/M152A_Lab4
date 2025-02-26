module Countdown(
    input wire clk_countdown,
    input wire rst,
    input wire start,
    output wire [1:0] anode,
    output wire countdown_done,
    output wire countdown_in_action
);

reg [1:0] anode_tmp;
reg countdown_in_action_tmp = 0;
reg countdown_done_tmp;

always @(posedge clk_countdown or posedge rst or posedge start) begin
    if (rst) begin
        anode_tmp <= 2'b00;
        countdown_done_tmp <= 0;
        countdown_in_action_tmp <= 0;
    end
    if (start) begin
        anode_tmp <= 2'b00;
        countdown_done_tmp <= 0;
        countdown_in_action_tmp <= 1;
    end
    if (countdown_in_action) begin
        if (anode_tmp == 3) begin
            countdown_done_tmp <= 1;
            countdown_in_action_tmp <= 0;
        end else begin
            anode_tmp <= anode_tmp + 1;
        end
    end
end

assign anode = anode_tmp;
assign countdown_done = countdown_done_tmp;
assign countdown_in_action = countdown_in_action_tmp;

endmodule