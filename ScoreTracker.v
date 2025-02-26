module ScoreTracker(
    input wire clk,
    input wire rst,
    input wire countdown_in_action,
    input wire delay_done,
    input wire round_in_action,
    input wire switchP1,
    input wire switchP2,

    output wire [3:0] p1Score_left,
    output wire [3:0] p1Score_right,
    output wire [3:0] p2Score_left,
    output wire [3:0] p2Score_right,
    output wire round_over,
    output wire jump_start,
    output wire [1:0] winner
);

reg [6:0] p1Score_tmp;
reg [6:0] p2Score_tmp;
reg round_over_tmp;
reg jump_start_tmp;
reg [1:0] winner_tmp;
reg legal_to_end;


always @(posedge clk or posedge rst) begin
    if (rst) begin
        p1Score_tmp <= 7'b0000000;
        p2Score_tmp <= 7'b0000000;
        round_over_tmp <= 0;
        jump_start_tmp <= 0;
        winner_tmp <= 2'b00;
        legal_to_end <= 0;
    end
    if (round_in_action) begin
        // False start
        if (!legal_to_end) begin
            if (switchP1 && !switchP2) begin
                p2Score_tmp <= p2Score_tmp + 1;
                round_over_tmp <= 1;
                jump_start_tmp <= 1;
                winner_tmp <= 2'b10;
            end else if (switchP2 && !switchP1) begin
                p1Score_tmp <= p1Score_tmp + 1;
                round_over_tmp <= 1;
                jump_start_tmp <= 1;
                winner_tmp <= 2'b01;
            end
        end else begin
            if (switchP1 && !switchP2) begin
                p1Score_tmp <= p1Score_tmp + 1;
                round_over_tmp <= 1;
                winner_tmp <= 2'b01;
            end else if (switchP2 && !switchP1) begin
                p2Score_tmp <= p2Score_tmp + 1;
                round_over_tmp <= 1;
                winner_tmp <= 2'b10;
            end
        end
    end
end

always @(posedge round_in_action) begin
    round_over_tmp <= 0;
    jump_start_tmp <= 0;
    winner_tmp <= 2'b00;
    legal_to_end <= 0;
end

always @(posedge delay_done) begin
    legal_to_end <= 1;
end

assign p1Score = p1Score_tmp;
assign p2Score = p2Score_tmp;
assign round_over = round_over_tmp;
assign jump_start = jump_start_tmp;
assign winner = winner_tmp;

endmodule