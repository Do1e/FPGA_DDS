`timescale 1ns / 1ps

module Div_f #(parameter f = 1000)(
    input wire clk_100MHz,
    output reg Y
    );
    reg [31:0]count = 0;
    always @(posedge clk_100MHz)
    begin
        if(count != (50000000 / f - 1))
            count <= count + 1;
        else
        begin
            count = 0;
            Y = ~Y;
        end
    end
endmodule
