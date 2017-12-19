/*Procurar o programa DE1_control_panel.exe no CD-rom de da DE1(para tentar usar o terminal no computador)
 * -Usando um clock de 27MHz a transmissao e o envio de dados são conrrompidos.
 * Consegui usar o modulo para testar o bluetooth e consegui resultados
 * -Medi a distancia maxima que ele consegue trabalhar que seria por volta de uns 20m
 * -E string foi enviada corretamente
 *
 *Proximos passos:
 * -Testar no FPGA os comandos sendo enviados para o GSM
 * -Vizualizar a recepção no display (Da pra melhorar kkk)
 *
 *
 *	Primeira linha do LCD apresenta os comandos AT que estao sendo enviados
 * Segunda linha do LCD apresenta dados vindos do modulo bluetooth/GSM/GPS
 */

module teste_GSM(
    input clk,				//N2
	 input RxD,				//J22
	 input switch,			//N25
    output TxD,			//D25
	 
	 //Sinais para controle LCD
	 output LCD_ON,			//L4
	 output LCD_BLON,			//K2
	 output LCD_RW,			//K4
	 output LCD_EN,			//K3
	 output LCD_RS,			//K1
	 inout[7:0] LCD_DATA,	//H3,H4,J3,J4,H2,H1,J2,J1
	
	//Sinais para teste
    output reg [7:0] GPout,  // led_RX_data //AC21,AD21,AD23,AD22,AC22,AB21,AF23,AE23
	 output wire [7:0] led_TX_data,	//Y18,AA20,U17,U18,V18,W19,AF22,AE22
	 output wire led_TX,			//AE12
	 output wire led_RX,			//AD12
	 output wire[1:0] erro		
);

wire RxD_data_ready;
wire [7:0] RxD_data;
wire TxD_busy;

reg[7:0] GPin = 0;

assign led_TX = TxD;
assign led_RX = RxD;
assign led_TX_data = GPin;

//Codigo de verificação de erro
//verificacao_erro verifica(.clk(clk),.data(GPout),.data_ready(RxD_data_ready_arduino),.erro(erro));

reg[14*8-1:0] data_line1="-PIBIC 2015-2-",data_line2;
//Controle do LCD
Ctrl_LCD LCD(
	.CLOCK_50(clk),    //    50 MHz clock
  .data_line1(data_line1),
  .data_line2(data_line2),
//    LCD Module 16X2
  .LCD_ON(LCD_ON),    // LCD Power ON/OFF
  .LCD_BLON(LCD_BLON),    // LCD Back Light ON/OFF
  .LCD_RW(LCD_RW),    // LCD Read/Write Select, 0 = Write, 1 = Read
  .LCD_EN(LCD_EN),    // LCD Enable
  .LCD_RS(LCD_RS),    // LCD Command/Data Select, 0 = Command, 1 = Data
  .LCD_DATA(LCD_DATA)    // LCD Data bus 8 bits
);


//Recebe do GSM
					//clk     ,Baud(9600),oversample	
async_receiver #(50000000,9600,16) RX_arduino(.clk(clk), .RxD(RxD), .RxD_data_ready(RxD_data_ready), .RxD_data(RxD_data));
always @(posedge clk) begin
	if(RxD_data_ready)begin
		GPout <= RxD_data;
		data_line2 <= {data_line2[13*8-1:0],GPout};   			//Dados aprensatados no LCD;
	end
end

reg TxD_start;
						//clk     ,baud (Default 9600)
async_transmitter #(50000000,9600) TX_arduino(.clk(clk), .TxD(TxD), .TxD_start(TxD_start), .TxD_data(GPin),.TxD_busy(TxD_busy));

//@TESTANDO
reg[26:0] count=0;
reg[26:0] count_delay=67108863;

always@(posedge clk)begin
	count = count+1'b1;
	count_delay = count_delay +1'b1;
end

//@TESTANDO
assign Tx_time = count[26]&count_delay[26];

wire Tx_time;
reg[2:0] state=0;
reg[3:0] count_FSM=0;
localparam comand_size = 8;
reg[comand_size*8-1:0] buffer_comand ={"AT+NAME?"};
always@(posedge clk) begin
	if(Tx_time == 1'b1) begin
		TxD_start = 1'b1;
	end
	if((TxD_start)&(!TxD_busy))begin
	case(state)
		3'b000:begin
					state = 3'b001;
					GPin = 0;
				end
		3'b001:begin
					state = 3'b001;	
					GPin = buffer_comand[comand_size*8-1:(comand_size-1)*8];
					buffer_comand = {buffer_comand[(comand_size-1)*8-1:0],buffer_comand[comand_size*8-1:(comand_size-1)*8]};
					count_FSM = count_FSM+1'b1;
					data_line1 = {data_line1[13*8-1:0],GPin};  //PRINTF
					if(count_FSM == comand_size)begin
						count_FSM = 1'b0;
						state = 3'b010;
					end
				end
		3'b010:begin
					state = 3'b000;
					GPin = 0;
					TxD_start = 1'b0;
				end
		default: state = 3'b000;
	endcase
	end
end

endmodule