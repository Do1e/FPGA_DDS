`timescale 1ns / 1ps

module DDS_TOP(
	input wire clk_100MHz, rst,
	input wire KEY_Uin, KEY_Din, KEY_Lin, KEY_Rin,
	// ���� ��С ��һλ ��һλ
	output wire [0:3] AN, wire [0:6] C, wire [3:0]DA,
	output wire [7:0] DAC
	);
	parameter N = 16; parameter BIT = 8;
	//--------------------------��������--------------------------//
	wire KEY_U, KEY_D, KEY_L, KEY_R;
	//assign {KEY_U, KEY_D, KEY_L, KEY_R} = {KEY_Uin, KEY_Din, KEY_Lin, KEY_Rin};
	key_filter key_filterU (.clk(clk_100MHz), .rstn(rst), .key_in(KEY_Uin), .key_deb(KEY_U));
	key_filter key_filterD (.clk(clk_100MHz), .rstn(rst), .key_in(KEY_Din), .key_deb(KEY_D));
	key_filter key_filterL (.clk(clk_100MHz), .rstn(rst), .key_in(KEY_Lin), .key_deb(KEY_L));
	key_filter key_filterR (.clk(clk_100MHz), .rstn(rst), .key_in(KEY_Rin), .key_deb(KEY_R));
	//--------------------------ʱ�ӷ�Ƶ--------------------------//
	wire clk;
	Div_f #(.f(1000000)) Div_1MHz(.clk_100MHz(clk_100MHz), .Y(clk));

	//-------------------------�ı�Ƶ�ʿ�����----------------------//
	wire [3:0] D3, D2, D1, D0; assign DA[3:2] = 2'b00;
	Change_F CHANGE(.KEY_U(KEY_U), .KEY_D(KEY_D), .KEY_L(KEY_L), .KEY_R(KEY_R), .clk(clk),
		.rst(rst), .D3(D3), .D2(D2), .D1(D1), .D0(D0), .Bit_Sel(DA[1:0]));
	Digit_Show DynShow(.D3(D3), .D2(D2), .D1(D1), .D0(D0), .clk_100MHz(clk_100MHz),
		.En(1), .rst(rst), .C(C), .AN(AN));
	
	//--------------------------��λ�ۼ���------------------------//
	wire [N - 1: 0] Addr;
	Adder #(.N(N)) ADDER(.rst(rst), .clk(clk), .M({D3, D2, D1, D0}), .Addr(Addr));

	//-------------------------��ȡROM����------------------------//
	BlockROM #(.ADDR_WIDTH(9), .DATA_WIDTH(BIT)) ReadROM(.clk(clk_100MHz), .addr(Addr[15:7]), .data(DAC));
endmodule
