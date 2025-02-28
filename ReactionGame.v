module ReactionGame(
    input wire clk,
    input wire rst,
    input wire start,
    input wire switchP1,
    input wire switchP2,
    output wire [6:0] cathode,
    output wire [3:0] anode
);

wire rst_db;
wire start_db;

reg start_countdown;
reg start_reaction;

reg [1:0] game_mode; // 00: countdown, 01: stopwatch, 10: score

Debouncer rst_debouncer(
    .clk(clk),
    .btn(rst),
    .btn_db(rst_db)
);

Debouncer start_debouncer(
    .clk(clk),
    .btn(start),
    .btn_db(start_db)
);

Debouncer switchP1_debouncer(
    .clk(clk),
    .btn(switchP1),
    .btn_db(switchP1_db)
);

Debouncer switchP2_debouncer(
    .clk(clk),
    .btn(switchP2),
    .btn_db(switchP2_db)
);

// Clocks
wire clk_1kHz, clk_display, clk_blink, clk_countdown;
ClockFactory clock_factory(
    .clk(clk),
    .rst(rst_db),
    .clk_1kHz(clk_1kHz),
    .clk_display(clk_display),
    .clk_blink(clk_blink),
    .clk_countdown(clk_countdown)
);

wire [1:0] anode_countdown;
wire countdown_done, countdown_in_action;
Countdown countdown(
    .clk_countdown(clk_countdown),
    .rst(rst_db),
    .start(start_db),
    .anode(anode_countdown),
    .countdown_done(countdown_done),
    .countdown_in_action(countdown_in_action)
);

wire delay_done;
RandomDelay random_delay(
    .clk(clk),
    .clk_1kHz(clk_1kHz),
    .rst(rst_db),
    .start(countdown_done),
    .done(delay_done)
);

wire [3:0] p1Score_left, p1Score_right, p2Score_left, p2Score_right;
wire round_over, jump_start;
wire [1:0] winner;
ScoreTracker score_tracker(
    .clk(clk),
    .rst(rst_db),
    .countdown_in_action(countdown_in_action),
    .delay_done(delay_done),
    .round_in_action(countdown_done),
    .switchP1(switchP1_db),
    .switchP2(switchP2_db),
    .p1Score_left(p1Score_left),
    .p1Score_right(p1Score_right),
    .p2Score_left(p2Score_left),
    .p2Score_right(p2Score_right),
    .round_over(round_over),
    .jump_start(jump_start),
    .winner(winner)
);

wire [3:0] sec0, ms2, ms1, ms0;
Stopwatch stopwatch(
    .clk_1kHz(clk_1kHz),
    .rst(rst_db),
    .pause(round_over),
    .sec0(sec0),
    .ms2(ms2),
    .ms1(ms1),
    .ms0(ms0)
);



wire [6:0] p1Score_left_7seg, p1Score_right_7seg, p2Score_left_7seg, p2Score_right_7seg;
SevenSegment p1Score_left_encoder(
    .digit(p1Score_left),
    .seg(p1Score_left_7seg)
);
SevenSegment p1Score_right_encoder(
    .digit(p1Score_right),
    .seg(p1Score_right_7seg)
);
SevenSegment p2Score_left_encoder(
    .digit(p2Score_left),
    .seg(p2Score_left_7seg)
);
SevenSegment p2Score_right_encoder(
    .digit(p2Score_right),
    .seg(p2Score_right_7seg)
);

wire [6:0] sec0_7seg, ms2_7seg, ms1_7seg, ms0_7seg;
SevenSegment sec0_encoder(
    .digit(sec0),
    .seg(sec0_7seg)
);
SevenSegment ms2_encoder(
    .digit(ms2),
    .seg(ms2_7seg)
);
SevenSegment ms1_encoder(
    .digit(ms1),
    .seg(ms1_7seg)
);
SevenSegment ms0_encoder(
    .digit(ms0),
    .seg(ms0_7seg)
);

wire [6:0] cathode_tmp;
wire [3:0] anode_tmp;
Display display(
    .clk(clk),
    .clk_display(clk_display),
    .clk_blink(clk_blink),
    .rst(rst_db),
    .game_mode(game_mode),
    .winner(winner),
    .p1Score_left(p1Score_left_7seg),
    .p1Score_right(p1Score_right_7seg),
    .p2Score_left(p2Score_left_7seg),
    .p2Score_right(p2Score_right_7seg),
    .sec0(sec0_7seg),
    .ms2(ms2_7seg),
    .ms1(ms1_7seg),
    .ms0(ms0_7seg),
    .jump_start(jump_start),
    .anode_countdown(anode_countdown),
    .cathode(cathode_tmp),
    .anode(anode_tmp)
);

always @(posedge start_db or posedge delay_done or posedge round_over) begin
    if (start_db)
        game_mode <= 2'b00;
    else if (delay_done)
        game_mode <= 2'b01;
    else if (round_over)
        game_mode <= 2'b10;
end

assign cathode = cathode_tmp;
assign anode = anode_tmp;


endmodule