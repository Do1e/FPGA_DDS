`timescale 1ns / 1ps

module Adder #(parameter N = 16)(
    input wire rst, clk,
    input wire [N - 1: 0] M,
    output reg [N - 1: 0] Addr
    );
    always @(posedge clk, negedge rst) begin
        if(!rst) Addr = 0;
        else Addr <= Addr + M;
    end
endmodule
