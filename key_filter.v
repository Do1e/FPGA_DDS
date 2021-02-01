`timescale 1ns / 1ps

module key_filter(clk,rstn,key_in,key_deb);
    input clk;
    input rstn;
    input key_in;
    output key_deb;
    //分频计数
    parameter CNTMAX = 999_999;
    reg [19:0] cnt = 0;
    always@(posedge clk or negedge rstn) begin
        if(~rstn)
            cnt <= 0;
        else if(cnt == CNTMAX)
            cnt <= 0;
        else
            cnt <= cnt + 1'b1;
     end
     //每20ms采样一次按键电平
     reg key_reg0;
     reg key_reg1;
     reg key_reg2; 
     always@(posedge clk or negedge rstn) begin
        if(~rstn) begin
            key_reg0 <= 1'b1;
            key_reg1 <= 1'b1;
            key_reg2 <= 1'b1;
        end
        else if(cnt == CNTMAX) begin
            key_reg0 <= key_in;
            key_reg1 <= key_reg0;
            key_reg2 <= key_reg1;
        end
    end
    assign key_deb = ~((~key_reg0 & ~key_reg1 & ~key_reg2) | (~key_reg0 & ~key_reg1 & key_reg2));
endmodule
