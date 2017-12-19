/* Projeto cadeirinha de BEBE - PIBIC-2015-2/2016-1
 * @Vagner Luciano da Costa Silva
 * Modulo de teste para integração de modulos suavização e package_slicer
 *
 * Problemas com apresentação de dados 
 *
 *
 *
*/
module teste_Mod_comm(
					input child,
					input clock,
					output reg[7:0] data_sliced
					);

wire[7:0] out;
wire[31:0] latitude = 2634267423;
wire[31:0] longitude = 3637248237;

wire[7:0] data_out;	
wire busy;
assign out[7:1] = 7'b1111111;

suav suaviza(.in(child),.out(out[0]),.CLK(clock));
Package_slicer slicer(.child(out),
							.clock(clock),
							.latitude(latitude),
							.longitude(longitude),
							.data_out(data_out),
							.busy(busy));
						
reg state=0;
reg[71:0] buffer = 0;	
//@Teste para vizualização dos dados
always@(posedge clock)
begin
		if(data_out[7] == 1'b1)	state = 1'b1; else if(data_out == 0) state = 1'b0;
		
		if(state == 1'b1)begin
			buffer = {buffer[63:0],data_out};
			//data_sliced = buffer[71:64];
		end
end

reg[25:0] count;
always@(posedge clock) count = count+1'b1;
reg[3:0] estado=0;
always@(posedge count[25])begin
		case(estado)
		4'b0000: begin
						data_sliced = buffer[71:64];
						estado = 4'b0001;
					end
		4'b0001: begin
						data_sliced = buffer[63:56];
						estado = 4'b0010;
					end
		4'b0010: begin
						data_sliced = buffer[55:48];
						estado = 4'b0011;
					end
		4'b0011: begin
						data_sliced = buffer[47:40];
						estado = 4'b0100;
					end
		4'b0100: begin
						data_sliced = buffer[39:32];
						estado = 4'b0101;
					end
		4'b0101: begin
						data_sliced = buffer[31:24];
						estado = 4'b0110;
					end
		4'b0110: begin
						data_sliced = buffer[23:16];
						estado = 4'b0111;
					end
		4'b0111: begin
						data_sliced = buffer[15:8];
						estado = 4'b1000;
					end
		4'b1000: begin
						data_sliced = buffer[7:0];
						estado = 4'b1001;
					end
		default : estado = 4'b0000;
		endcase
end	

endmodule
