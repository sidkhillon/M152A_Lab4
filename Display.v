module Display(
    input wire clk,
    input wire clk_display,
    input wire clk_blink,
    input wire rst,
    input wire [1:0] game_mode, // 00: countdown, 01: stopwatch, 10: score
    input wire [1:0] winner, // 00: no winner, 01: player 1, 10: player 2
    // 7-segment display values
    input wire [6:0] p1Score_left, 
    input wire [6:0] p1Score_right, 
    input wire [6:0] p2Score_left,
    input wire [6:0] p2Score_right,
    input wire [6:0] sec0,
    input wire [6:0] ms2,
    input wire [6:0] ms1,
    input wire [6:0] ms0,
    input wire jump_start,

    input wire [1:0] anode_countdown,

    output wire [6:0] cathode,
    output wire [3:0] anode,
    output wire dp
);

    reg [6:0] cathode_tmp;
    reg [3:0] anode_tmp;
    reg dp_tmp;
    reg [1:0] screen = 0;

    always @(posedge clk_display) begin
        screen <= screen + 1;
        if (game_mode == 0) begin
            dp_tmp = 1;
            case (screen)
                0: begin
                    anode_tmp = 4'b1110;
                    if (anode_countdown >= 0) begin
                        cathode_tmp = 7'b0011100;
                    end else begin
                        cathode_tmp = 7'b1111111;
                    end
                end
                1: begin
                    anode_tmp = 4'b1101;
                    if (anode_countdown >= 1) begin
                        cathode_tmp = 7'b0011100;
                    end else begin
                        cathode_tmp = 7'b1111111;
                    end
                end
                2: begin
                    anode_tmp = 4'b1011;
                    if (anode_countdown >= 2) begin
                        cathode_tmp = 7'b0011100;
                    end else begin
                        cathode_tmp = 7'b1111111;
                    end
                end
                3: begin
                    anode_tmp = 4'b0111;
                    if (anode_countdown >= 3) begin
                        cathode_tmp = 7'b0011100;
                    end else begin
                        cathode_tmp = 7'b1111111;
                    end
                end
                default: begin
                    anode_tmp = 4'b1111;
                    cathode_tmp = 7'b1111111;
                end
            endcase
        end

        if (game_mode == 1 || game_mode == 2) begin
            if (jump_start) begin
                dp_tmp = 1;
                cathode_tmp = 7'b1111110; // slash
                case(screen)
                    2'd0: begin
                        anode_tmp = 4'b1110;
                    end
                    2'd1: begin
                        anode_tmp = 4'b1101;
                    end
                    2'd2: begin
                        anode_tmp = 4'b1011;
                    end
                    2'd3: begin
                        anode_tmp = 4'b0111;
                    end
                    default: begin
                        anode_tmp = 4'b1111;
                    end
                endcase
            end else begin
                case (screen)
                    2'd0: begin
                        cathode_tmp = sec0;
                        anode_tmp = 4'b1110;
                        dp_tmp = 0;
                    end
                    2'd1: begin
                        cathode_tmp = ms2;
                        anode_tmp = 4'b1101;
                        dp_tmp = 1;
                    end
                    2'd2: begin
                        cathode_tmp = ms1;
                        anode_tmp = 4'b1011;
                        dp_tmp = 1;
                    end
                    2'd3: begin
                        cathode_tmp = ms0;
                        anode_tmp = 4'b0111;
                        dp_tmp = 1;
                    end
                    default: begin
                        cathode_tmp = 7'b1111111;
                        anode_tmp = 4'b1111;
                        dp_tmp = 1;
                    end
                endcase
            end
        end

        if (game_mode == 3) begin
            dp_tmp = 1;
            case (screen)
                2'd0: begin
                    cathode_tmp = p1Score_left;
                    anode_tmp = 4'b1110;
                    if (winner == 1 && !clk_blink) begin
                        cathode_tmp = 7'b1111111;
                    end
                end
                2'd1: begin
                    cathode_tmp = p1Score_right;
                    anode_tmp = 4'b1101;
                    if (winner == 1 && !clk_blink) begin
                        cathode_tmp = 7'b1111111;
                    end
                end
                2'd2: begin
                    cathode_tmp = p2Score_left;
                    anode_tmp = 4'b1011;
                    if (winner == 2 && !clk_blink) begin
                        cathode_tmp = 7'b1111111;
                    end
                end
                2'd3: begin
                    cathode_tmp = p2Score_right;
                    anode_tmp = 4'b0111;
                    if (winner == 2 && !clk_blink) begin
                        cathode_tmp = 7'b1111111;
                    end
                end
                default: begin
                    cathode_tmp = 7'b1111111;
                    anode_tmp = 4'b1111;
                end
            endcase
        end
    end

    assign cathode = cathode_tmp;
    assign anode = anode_tmp;
    assign dp = dp_tmp;

endmodule
