module SevenSegment(
    input wire [3:0] digit,
    output wire [6:0] seg
);

reg [6:0] seg_tmp;

always @(digit) begin
    case (digit)
        4'h0: seg_tmp = 7'b0000001;
        4'h1: seg_tmp = 7'b1001111;
        4'h2: seg_tmp = 7'b0010010;
        4'h3: seg_tmp = 7'b0110000;
        4'h4: seg_tmp = 7'b1001100;
        4'h5: seg_tmp = 7'b0100100;
        4'h6: seg_tmp = 7'b0100000;
        4'h7: seg_tmp = 7'b0001111;
        4'h8: seg_tmp = 7'b0000000;
        default: seg_tmp = 7'b0000100; // Default 9
    endcase
end

assign seg = seg_tmp;

endmodule 