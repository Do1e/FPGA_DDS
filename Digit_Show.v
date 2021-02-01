`timescale 1ns / 1ps

module Digit_Show(
    input wire [3:0]D3, wire [3:0]D2,
    input wire [3:0]D1, wire [3:0]D0,
    input wire clk_100MHz, wire En, wire rst,
    output reg [0:6]C = 0, reg [3:0]AN = 0
    );
    reg [31:0]count = 0;
    reg [1:0]CH = 0; // 选通位
    reg [3:0]I = 0; // 选通数据
    // 分频
    always @(posedge clk_100MHz)
    begin
        if(count != 199999)
            count <= count + 1;
        else
        begin
            count = 0;
            CH <= CH + 1;
        end
    end
    // 四选一
    always @(D3, D2, D1, D0, CH)
        case(CH)
            0: I = D0;
            1: I = D1;
            2: I = D2;
            3: I = D3;
        endcase
    // 二四译码器
    always @(CH, I, En)
    begin
        if(En) case(CH)
                0: AN = 4'b1110;
                1: AN = 4'b1101;
                2: AN = 4'b1011;
                3: AN = 4'b0111;
            endcase
        else AN = 4'b1111;
    end
    // 数码管译码器
    always @(I, rst)
    begin
        if(!rst) C = 7'b1111110;
        else case(I)
                4'h0: C = 7'b1111110;
                4'h1: C = 7'b0110000;
                4'h2: C = 7'b1101101;
                4'h3: C = 7'b1111001;
                4'h4: C = 7'b0110011;
                4'h5: C = 7'b1011011;
                4'h6: C = 7'b1011111;
                4'h7: C = 7'b1110000;
                4'h8: C = 7'b1111111;
                4'h9: C = 7'b1111011;
                4'ha: C = 7'b1110111;
                4'hb: C = 7'b0011111;
                4'hc: C = 7'b1001110;
                4'hd: C = 7'b0111101;
                4'he: C = 7'b1001111;
                4'hf: C = 7'b1000111;
            endcase
    end
endmodule
