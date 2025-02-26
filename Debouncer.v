module Debouncer(
    input wire clk,
    input wire btn,
    output wire btn_db
);

reg [15:0] counter;
reg btn_db_tmp;

always @(posedge clk) begin
    if (btn) begin
        if (counter == 16'hffff) begin
            btn_db_tmp <= 1;
        end
        else begin
            counter <= counter + 1;
        end
    end
    else begin
        counter <= 0;
        btn_db_tmp <= 0;
    end
end

assign btn_db = btn_db_tmp;

endmodule
