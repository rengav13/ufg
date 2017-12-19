////////////////////////////////////////////////////////
// RS-232 RX and TX module
// (c) fpga4fun.com & KNJN LLC - 2003 to 2013

//Modulo responsavel por controlar a comunicação 

module Comunicacao(
		input clk,
		input RxD,
		output TxD,

		output reg [7:0] GPout,  // general purpose outputs
		input [7:0] GPin  // general purpose inputs
);

wire RxD_data_ready;
wire [7:0] RxD_data;

async_receiver RX(.clk(clk), .RxD(RxD), .RxD_data_ready(RxD_data_ready), .RxD_data(RxD_data));
always @(posedge clk) if(RxD_data_ready) GPout <= RxD_data;

async_transmitter TX(.clk(clk), .TxD(TxD), .TxD_start(RxD_data_ready), .TxD_data(GPin));
endmodule