/* Projeto cadeirinha de BEBE - PIBIC-2015-2/2016-1
 * @Vagner Luciano da Costa Silva
 *	Modulo para teste do modulo divisor de pacotes
 *	Recebe sinais do modulo interface_sensores e dados de localização do GSM/GPS 
 * e transforma em pacotes de 1byte para serem enviados para transmissão via GSM/BLUETOOTH
 *
 * clock --> 50MHz
 * Envia dados de 86 em 86 segundos
 *                __________________
 * latitude  --->|            		|--->data_out
 *	longitude --->| Package_slicer   |
 * child     --->|			   		|--->busy
 * 				  |			   		|
 * clock     --->|__________________|
 *
 * Definida a FSM para transferencia de dados por pacotes
 *
 * Proximas tarefas:
 * 	- Testar funcionalidades do modulo OK
 *    - Integrar com modulo de suavização dos sensores(	Diego)
 *	  - Integrar com modulo interface_GPS/GSM
 * 
 * Protocolo
 *	-Envia sinal(pulso) de start a cada 86 segundos
 *	-Começa a divisão em pacotes de 1byte
 *	-Envia cada pacote
 */
module Package_slicer(			
				input wire[7:0] child,
				input clock,
				input[31:0] latitude,
				input[31:0] longitude,
				output reg[7:0] data_out,
				output reg busy
				);

wire data_start;		
		
//@TESTANDO
reg[31:0] count = 0;
reg[31:0] count_delay = 2147483647;	//Sinal utilizado para geração de pulso, para DATA_START (valor 2^n - 1

always@(posedge clock)begin
	count = count + 1'b1; 
	count_delay = count_delay+1'b1;
end

//Gerador de pico
//@TESTANDO
assign data_start = count[31] & count_delay[31] ;

//FSM para envio de dados
reg[2:0] state = 3'b0;
reg[3:0] count_FSM = 2'b0;
reg[63:0] position;

always@(posedge clock)begin
	if(data_start == 1'b1)begin
		busy <= 1'b1;
		position = {latitude,longitude};
	end
	
	if(busy == 1'b1)begin
		case(state)
		3'b000: begin
					state <= 3'b001; 
					end
		3'b001:begin
					data_out <= child;
					state <= 3'b010;
				end
		3'b010:begin
					data_out = position[63:56];
					position = {position[55:0],8'b0};  
					count_FSM = count_FSM + 1'b1;
					if(count_FSM == 8) begin state <= 3'b111; count_FSM <= 0; end 
					else state <= 3'b010; 
				end
		3'b111:begin
					state <= 3'b000;
					data_out <= 0;
					busy <= 1'b0;
				end
		endcase
	end
end

endmodule
