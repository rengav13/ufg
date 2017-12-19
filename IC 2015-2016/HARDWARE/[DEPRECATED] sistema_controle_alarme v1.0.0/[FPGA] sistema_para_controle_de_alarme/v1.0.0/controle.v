/* Projeto cadeirinha de bebe - Iniciação Cientifica UFG - PIBIC 2015-2
	Autor: Vagner Luciano da Costa Silva
	
	Descrição:
		Modulo responsavel por integrar os diferentes niveis do projeto.
                     
						  TOP-LEVEL
							______
   communication -->|      |-->saida
   button        -->|      |
	clk           -->|      |
	                 |______|
						  
	Tarefas a serem desenvolvidas:
		-Problema da temporização do acionamento das saídas
      -Testar no FPGA modificações
		
	Modificações
		-Adicionado modulo para gerar um atraso no clock para testar se o problema esta na temporização das saidas ou no clock.
*/

module controle(
		input clk,
		input button,
		input RxD,
		input communication,
		output wire[2:0] saida,
		output wire led
		);
		
wire[7:0] GPout,GPin;
wire TxD;
wire crianca;
wire clk_out;

/*
Comunicacao comunicacao(clk,RxD,TxD,GPout,GPin);
*/
clock_atraso clock_atraso(clk,clk_out);
controle2 control(saida, RxD, communication, button, clk_out);

//assign crianca = GPout[0];

assign led = communication;

endmodule