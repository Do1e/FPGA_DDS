`timescale 1ns / 1ps

module BlockROM #(
    parameter ADDR_WIDTH = 4,
    parameter DATA_WIDTH = 4
    )(
    input wire clk,
    input wire [ADDR_WIDTH - 1: 0] addr,
    output reg [DATA_WIDTH - 1: 0] data
    );
    (* romstyle = "block" *) reg [DATA_WIDTH - 1: 0] mem[2**ADDR_WIDTH - 1: 0];
    initial begin
        $readmemb("D:/Study/Verilog/vivado_project/DDS/ROM_sin_data.hex", mem);
    end
    always @(posedge clk)
        data <= mem[addr];
endmodule
