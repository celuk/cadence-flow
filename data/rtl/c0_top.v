module c0_top(
    input clk,
    input rstn,
    input wire [1:0] d,
    output reg [0:4] seg
    );

    always @(posedge clk) begin
        if(!rstn) begin
            seg <= 0;
        end
        else begin
            case (d)
            2'h0: seg <= 5'b00001;
            2'h1: seg <= 5'b10011;
            2'h2: seg <= 5'b10010;
            2'h3: seg <= 5'b00110;
            default: seg <= 5'b11110;
            endcase
        end
    end
endmodule
