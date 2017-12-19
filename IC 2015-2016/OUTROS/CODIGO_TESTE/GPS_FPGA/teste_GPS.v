/* -Usando um clock de 27MHz a transmissao e o envio de dados são conrrompidos.
 *
 *	Primeira linha do LCD apresenta os dados interessantes do GPS
 * Segunda linha do LCD apresenta dados vindos do modulo bluetooth/GSM/GPS
 */
module teste_GPS(
    input clk,				//N2
    output TxD,			//D25
	 input RxD,				//E25
	 input switch,			//N25
	 output reg[(10+1+11+1+9+1)*8-1:0] position
);

wire RxD_data_ready;
wire [7:0] RxD_data;

assign led_RX = RxD;
reg[7:0] GPout = 0;
//Recebe do GPS
					//clk     ,Baud(9600),oversample	
async_receiver #(50000000,9600,16) RX_arduino(.clk(clk), .RxD(RxD), .RxD_data_ready(RxD_data_ready), .RxD_data(RxD_data));
always @(posedge clk) begin
	if(RxD_data_ready)begin
		GPout <= RxD_data;
	end
end
/*
wire[14*8-1:0] out_line1,out_line2;
filtra_position_GPGLL filter_GPGLL(RxD_data_ready,GPout,out_line1,out_line2);
*/
/*
always@(posedge clk) begin
	data_line1 <= out_line1;
	data_line2 <= out_line2;
end
*/

wire[10*8-1:0] latitude;
wire[1*8-1:0] latitude_orientation;
wire[11*8-1:0] longitude;
wire[1*8-1:0] longitude_orientation;
wire[9*8-1:0] altitude;
wire[1*8-1:0] altitude_unidade;
filtra_position_GPGGA filter_GPGGA(	
				.clk(RxD_data_ready),
				.data_in(GPout),
				.latitude(latitude),
				.latitude_orientation(latitude_orientation),
				.longitude(longitude),
				.longitude_orientation(longitude_orientation),
				.altitude(altitude),
				.altitude_unidade(altitude_unidade)
		);

always@(posedge clk) begin
	position = {latitude,latitude_orientation,longitude,longitude_orientation,altitude,altitude_unidade};
end
		
endmodule

module filtra_position_GPGGA(
				input clk,
				input wire[7:0] data_in,
				output reg[10*8-1:0] latitude,
				output reg[1*8-1:0] latitude_orientation,
				output reg[11*8-1:0] longitude,
				output reg[1*8-1:0] longitude_orientation,
				output reg[9*8-1:0] altitude,
				output reg[1*8-1:0] altitude_unidade
				);

reg[2:0] state = 0;
reg[3:0] state_pos = 0;
reg[3:0] count_commas = 0;

reg[10*8-1:0] buffer_latitude = 0;
reg[1*8-1:0] buffer_latitude_orientation = 0;
reg[11*8-1:0] buffer_longitude = 0;
reg[1*8-1:0] buffer_longitude_orientation = 0;
reg[9*8-1:0] buffer_altitude = 0;
reg[1*8-1:0] buffer_altitude_unidade = 0;

localparam STATE_IDLE = 0, STATE_LATITUDE = 1, STATE_LATITUDE_ORIENTATION = 2, STATE_LONGITUDE = 3,
				STATE_LONGITUDE_ORIENTATION = 4,STATE_ALTITUDE = 5,STATE_ALTITUDE_UNIDADE = 6,
				STATE_SET_DADOS_OUT = 7,STATE_WAIT = 8;
localparam NUMBER_COMMAS_START_FILTER = 2, NUMBER_COMMAS_UNTIL_GET_ALTITUDE = 3;
				
always@(posedge clk)begin
//Inicio FSM para filtragem de dados vindos do GPS
//Modelo de dado para ser filtrado $GPGGA,002454,3553.5295,N,13938.6570,E,1,05,2.2,18.3,M,39.0,M,,*7F
case(state)
		0: begin	if(data_in == "$") state = 1; else state = 0; end
		1: if(data_in == "G") state = 2; else state = 0;
		2:	if(data_in == "P") state = 3; else state = 0;
		3:	if(data_in == "G") state = 4; else state = 0;
		4:	if(data_in == "G") state = 5; else state = 0;
		5:	if(data_in == "A") state = 6; else state = 0;
		6: begin	
				case(state_pos)
				STATE_IDLE:begin if(data_in == ",")begin
										count_commas = count_commas+1;
										if(count_commas == NUMBER_COMMAS_START_FILTER)begin
											state_pos = STATE_LATITUDE;
											count_commas = 0;
										end
									end else state_pos = STATE_IDLE; 
								end
				STATE_LATITUDE:begin 
					if(data_in == ",")begin state_pos = STATE_LATITUDE_ORIENTATION; end 
					else begin buffer_latitude = {buffer_latitude[9*8-1:0],data_in};  
									state_pos = STATE_LATITUDE;
						  end
					end
				STATE_LATITUDE_ORIENTATION:begin 
					if(data_in == ",")begin state_pos = STATE_LONGITUDE; end 
					else begin buffer_latitude_orientation = data_in;  
									state_pos = STATE_LATITUDE_ORIENTATION;
						  end
					end
				STATE_LONGITUDE:begin 
					if(data_in == ",")begin state_pos = STATE_LONGITUDE_ORIENTATION;	end 
					else begin buffer_longitude = {buffer_longitude[10*8-1:0],data_in};  
									state_pos = STATE_LONGITUDE;
						  end
					end
				STATE_LONGITUDE_ORIENTATION:begin 
					if(data_in == ",")begin state_pos = STATE_WAIT; end 
					else begin buffer_longitude_orientation = data_in;  
									state_pos = STATE_LONGITUDE_ORIENTATION;
						  end
					end
				STATE_WAIT:begin if(data_in == ",")begin
										count_commas = count_commas+1;
										if(count_commas == NUMBER_COMMAS_UNTIL_GET_ALTITUDE)begin
											state_pos = STATE_ALTITUDE;
											count_commas = 0;
										end
									end else state_pos = STATE_WAIT; 
								end
				STATE_ALTITUDE:begin 
					if(data_in == ",")begin state_pos = STATE_ALTITUDE_UNIDADE;	end 
					else begin buffer_altitude = {buffer_altitude[8*8-1:0],data_in};  
									state_pos = STATE_ALTITUDE;
						  end
					end
				STATE_ALTITUDE_UNIDADE:begin 
					if(data_in == ",")begin state_pos = STATE_SET_DADOS_OUT; end 
					else begin buffer_altitude_unidade = data_in;  
									state_pos = STATE_ALTITUDE_UNIDADE;
						  end
					end
				STATE_SET_DADOS_OUT:begin
											state_pos = STATE_IDLE;
											state = 0;
											
											latitude = buffer_latitude;
											latitude_orientation = buffer_latitude_orientation;
											longitude = buffer_longitude;
											longitude_orientation = buffer_longitude_orientation;
											altitude = buffer_altitude;
											altitude_unidade = buffer_altitude_unidade;
						
											buffer_latitude = 0;
											buffer_latitude_orientation = 0;
											buffer_longitude = 0;
											buffer_longitude_orientation = 0;
											buffer_altitude = 0;
											buffer_altitude_unidade = 0;
										end
				default: state_pos = STATE_IDLE;
				endcase
			end
		default: state = STATE_IDLE;
		endcase
end
endmodule

module filtra_position_GPGLL(
				input clk,
				input wire[7:0]GPout,
				output reg[14*8-1:0] data_line1,
				output reg[14*8-1:0] data_line2
				);

				
reg[2:0] state = 0;
reg[2:0] state_pos = 0;
reg[10:0] count = 0;
reg[14*8-1:0] buffer1 = 0;
reg[14*8-1:0] buffer2 = 0;

localparam STATE_IDLE = 0, STATE_LATITUDE = 1, STATE_LATITUDE_ORIENTATION = 2, STATE_LONGITUDE = 3,STATE_LONGITUDE_ORIENTATION = 4;
localparam STATE_FILTRO_IDLE = 0,STATE_FILTRO_G1 = 1,
				STATE_FILTRO_P = 2, STATE_FILTRO_G2 = 3,STATE_FILTRO_L1 = 4,
				STATE_FILTRO_L2 = 5, STATE_FILTRO_POSITION=6;
				
always@(posedge clk)begin
//Inicio FSM para filtragem de dados vindos do GPS
//Modelo de dado para ser filtrado $GPGLL,,,,,215808.00,V,N*4C 
case(state)
		STATE_FILTRO_IDLE: begin	if(GPout == "$") state = STATE_FILTRO_G1; else state = STATE_FILTRO_IDLE; end
		STATE_FILTRO_G1: if(GPout == "G") state = STATE_FILTRO_P; else state = STATE_FILTRO_IDLE;
		STATE_FILTRO_P:	if(GPout == "P") state = STATE_FILTRO_G2; else state = STATE_FILTRO_IDLE;
		STATE_FILTRO_G2:	if(GPout == "G") state = STATE_FILTRO_L1; else state = STATE_FILTRO_IDLE;
		STATE_FILTRO_L1:	if(GPout == "L") state = STATE_FILTRO_L2; else state = STATE_FILTRO_IDLE;
		STATE_FILTRO_L2:	if(GPout == "L") state = STATE_FILTRO_POSITION; else state = STATE_FILTRO_IDLE;
		STATE_FILTRO_POSITION: begin	
				case(state_pos)
				STATE_IDLE:begin if(GPout == ",") state_pos = STATE_LATITUDE; else state_pos = STATE_IDLE; end 
				STATE_LATITUDE:begin 
					if(GPout == ",")begin state_pos = STATE_LATITUDE_ORIENTATION; end 
					else begin buffer1 = {buffer1[13*8-1:0],GPout};  
									state_pos = STATE_LATITUDE;
						  end
					end
				STATE_LATITUDE_ORIENTATION:begin 
					if(GPout == ",")begin state_pos = STATE_LONGITUDE; end 
					else begin buffer1 = {buffer1[13*8-1:0],GPout};  
									state_pos = STATE_LATITUDE_ORIENTATION;
						  end
					end
				STATE_LONGITUDE:begin 
					if(GPout == ",")begin state_pos = STATE_LONGITUDE_ORIENTATION;	end 
					else begin buffer2 = {buffer2[13*8-1:0],GPout};  
									state_pos = STATE_LONGITUDE;
						  end
					end
				STATE_LONGITUDE_ORIENTATION:begin 
					if(GPout == ",")begin 
											state_pos = STATE_IDLE;
											state = STATE_FILTRO_IDLE;
											data_line1 = {"LAT",buffer1[11*8-1:0]}; 
											data_line2 = {"LO",buffer2[12*8-1:0]};
											buffer1=0;
											buffer2=0;
											end 
					else begin buffer2 = {buffer2[13*8-1:0],GPout};  
									state_pos = STATE_LONGITUDE_ORIENTATION;
						  end
					end
				default: state_pos = STATE_IDLE;
				endcase
			end
		default: state = STATE_FILTRO_IDLE;
		endcase
end
endmodule