module ClockFactory(
    input  wire clk,
    input  wire rst,
    output wire clk_1kHz,
    output wire clk_display,
    output wire clk_blink,
    output wire clk_countdown
);

    // 1kHz clock (toggle every 50_000 cycles)
    reg [26:0] counter_1kHz = 0;
    reg clk_1kHz_tmp = 0;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter_1kHz <= 0;
            clk_1kHz_tmp <= 0;
        end else begin
            if (counter_1kHz == 50_000 - 1) begin
                counter_1kHz <= 0;
                clk_1kHz_tmp <= ~clk_1kHz_tmp;
            end else begin
                counter_1kHz <= counter_1kHz + 1;
            end
        end
    end

    // Display clock (500 Hz) (toggle every 100_000 cycles)
    reg [26:0] counter_display = 0;
    reg clk_display_tmp = 0;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter_display <= 0;
            clk_display_tmp <= 0;
        end else begin
            if (counter_display == 100_000 - 1) begin
                counter_display <= 0;
                clk_display_tmp <= ~clk_display_tmp;
            end else begin
                counter_display <= counter_display + 1;
            end
        end
    end

    // Blink clock (2 Hz) (toggle every 25_000_000 cycles)
    reg [26:0] counter_blink = 0;
    reg clk_blink_tmp = 0;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter_blink <= 0;
            clk_blink_tmp <= 0;
        end else begin
            if (counter_blink == 25_000_000 - 1) begin
                counter_blink <= 0;
                clk_blink_tmp <= ~clk_blink_tmp;
            end else begin
                counter_blink <= counter_blink + 1;
            end
        end
    end

    // Countdown clock (1 Hz) (toggle every 50_000_000 cycles)
    reg [26:0] counter_countdown = 0;
    reg clk_countdown_tmp = 0;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter_countdown <= 0;
            clk_countdown_tmp <= 0;
        end else begin
            if (counter_countdown == 50_000_000 - 1) begin
                counter_countdown <= 0;
                clk_countdown_tmp <= ~clk_countdown_tmp;
            end else begin
                counter_countdown <= counter_countdown + 1;
            end
        end
    end

    assign clk_1kHz = clk_1kHz_tmp;
    assign clk_display = clk_display_tmp;
    assign clk_blink = clk_blink_tmp;
    assign clk_countdown = clk_countdown_tmp;


endmodule