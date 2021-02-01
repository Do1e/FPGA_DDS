`timescale 1ns / 1ps

module Change_F(
    input wire KEY_U, KEY_D, KEY_L, KEY_R, rst, clk,
    output reg [3:0] D3, D2, D1, D0,
    output reg [1:0] Bit_Sel
    );

    //--------------------------位选--------------------------//
    reg flag1 = 0; reg flag2 = 0;
    always @(posedge clk, negedge rst) begin
        if(!rst) begin Bit_Sel <= 0; flag1 <= 0; flag2 <= 0; end
        else if(!KEY_L && !flag1) begin Bit_Sel <= Bit_Sel + 1; flag1 <= 1; end
        else if(!KEY_R && !flag2) begin Bit_Sel <= Bit_Sel - 1; flag2 <= 1; end
        else if(KEY_L || KEY_R) begin
            if(KEY_L) flag1 <= 0;
            if(KEY_R) flag2 <= 0;
        end
    end

    //--------------------------改变--------------------------//
    reg flag3 = 0; reg flag4 = 0;
    always @(posedge clk, negedge rst) begin
        if(!rst) begin
            D3 <= 0; D2 <= 0; D1 <= 0; D0 <= 0;
            flag3 <= 0; flag4 <= 0;
        end
        else if(!KEY_U && !flag3) begin
            flag3 <= 1;
            case(Bit_Sel)
                0: D0 <= D0 + 1;
                1: D1 <= D1 + 1;
                2: D2 <= D2 + 1;
                3: D3 <= D3 + 1;
            endcase
        end
        else if(!KEY_D && !flag4) begin
            flag4 <= 1;
            case(Bit_Sel)
                0: D0 <= D0 - 1;
                1: D1 <= D1 - 1;
                2: D2 <= D2 - 1;
                3: D3 <= D3 - 1;
            endcase
        end
        else if(KEY_U || KEY_D) begin
            if(KEY_U) flag3 <= 0;
            if(KEY_D) flag4 <= 0;
        end
    end
endmodule
