/* Modulo de verificação de erro
 *
 * -V0.0: recebe caracteres aleatorios e verifica se são iguais aos comandos de erros
 *
*/
module verificacao_erro(
						input clk,
						input[7:0] data,
						input data_ready,
						output reg[1:0] erro
								);

//tamanho do comando a ser avaliado
localparam comand_error_lenght = 8;	
		
reg[8*comand_error_lenght-1:0] buffer_data = 63'b0;

always@(negedge data_ready) begin
	buffer_data = {buffer_data[comand_error_lenght*7-1:0],data};
end

always@(posedge clk)begin	
		case(buffer_data)
			"OK+CONNE" : erro = 2'b11;
			"OK+CONNF" : erro = 2'b10;
			"OK+CONNA" : erro = 2'b01;
			"OK+CONNL" : erro = 2'b11;
			0 : erro = 2'b11;
			default: erro= 2'b00;
		endcase
end
endmodule