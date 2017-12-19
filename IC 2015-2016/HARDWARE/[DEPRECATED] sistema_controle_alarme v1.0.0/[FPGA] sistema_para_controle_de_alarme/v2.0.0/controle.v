/* Projeto cadeirinha de bebe - Iniciação Cientifica UFG - PIBIC 2015-2
	Autor: Vagner Luciano da Costa Silva
	
	Descrição:
		Modulo responsavel por integrar os diferentes niveis do projeto.
                     
						  TOP-LEVEL
							______
   communication -->|      |-->saida
   button        -->|      |
	clk           -->|      |
	crianca       -->|______|
						  
	Tarefas a serem desenvolvidas:
		
*/

module controle(
		input clk,
		input button,
		input[1:0] crianca,
		input communication,
		output wire[2:0] saida,
		output wire led,
		output wire led_PIR,
		output wire led_peso
		);
		
wire[7:0] GPin;
wire[7:0] GPout;
wire clk_out;

assign led = communication;
assign led_PIR = crianca[1];
assign led_peso = crianca[0];

//Add modulo de suavização_diego para preparar o sinal para ser enviado via bluetooth
suav suave(crianca[0]|crianca[1],GPin[0],clk);

//Comunicacao comunicacao(clk,communication_RX,communication_TX,GPout,GPin);

clock_atraso clock_atraso(clk,clk_out);
controle2 control(saida, GPin[0], communication, button, clk_out);

endmodule