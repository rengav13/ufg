/* Modulo maquina de estados
 * Autor: Vagner Luciano da Costa Silva
 *
 * Descrição:
 *		-O modulo é o responsavel por controlar os sinais da saida(LED, VIBRADOR, AUTO FALANTE),
 *    dado um conjunto de entradas que são: Sensores e comunicação.
 *
 *                         ______   3b
 *			clk          --->|      |--/->saida
 *       button       --->|      |
 *       communication--->|      |
 *       crianca      --->|______|
 *
 * Problemas:
 *		-Quando a maquina de estados entra nos estados que dependem de um delay para acionamento
 *    das saidas, o delay aparenta nao estar funcionando, os 3 sinais estão ligando ao mesmo
 *    tempo, nao respeitando o delay esperado.
 *
 * Modificações:
 *    -Troca de delay por loops
*/


module controle2(saida, crianca, communication, button, clk);

input clk, button, communication, crianca;
output[2:0] saida;
reg[2:0] saida=3'b000;

reg [2:0] state=3'b000;

//registrador utilizado pra contar as repetições nos loops
reg[32:0] count;

//estados
parameter WAIT=3'b000,
			STAND_BY= 3'b001,
			LED=3'b010,
			LED_VIBRA1=3'b011,
			LED_VIBRA2=3'b100,
			LED_VIBRA_APITA=3'b101;

// saidas
parameter 	nula=3'b000,
				led0=3'b001,
				led_vibra0=3'b011,
				led_vibra_apita0=3'b111;
				
				
always @(posedge clk)
begin
	case(state)
		WAIT 				: begin
								if(communication==1'b0 && crianca==1'b0) 
								begin
									state<=STAND_BY;
									saida<=nula;
								end else
								if(communication==1'b0 && crianca==1'b1)
								begin
									state<=LED;
									saida<=led0;
								end else
										begin 
											state<=WAIT;
											saida<=nula;
										end
							 end
		STAND_BY 		: begin
								if(communication==1'b1)
								begin
									state<=WAIT;
									saida<=nula;
								end 
							 end											
		LED				: begin
								if(crianca==1'b0 && communication==1'b1)
								begin
									state<=WAIT;
									saida<=nula;
								end else
								if(button==1'b1)
								begin
									//TEMPO 4
									//#10;
									//Função de delay
									/*count = 0;
									repeat(1000) begin
										count = count+1;
										#10;
									end
									*/
									state<=#5 LED_VIBRA2;
									saida<=#5 led_vibra0;
								end else
										begin
											//TEMPO 1
											//#10;
											//Funçao de delay 
											/*count = 0;
											repeat(1000) begin
												count = count+1;
												#10;
											end
											*/
											state<=#5 LED_VIBRA1;
											saida<=#5 led_vibra0;
										end
						 end
		LED_VIBRA1 		: begin
								if(crianca==1'b0 && communication==1'b1)
								begin
									state<=WAIT;
									saida<=nula;
								end else
								if(button==1'b1)
								begin
									state<=LED_VIBRA2;
									saida<=led_vibra0;
								end else		
										begin
											//TEMPO 2
											//#10;
											//função de delay
											/*count = 0;
											repeat(1000) begin
												count = count+1;
												#10;
											end
											*/
											state<=#5 LED_VIBRA_APITA;
											saida<=#5 led_vibra_apita0;
										end
							 end
		LED_VIBRA_APITA: begin
								if(crianca==1'b0 && communication==1'b1)
								begin
									state<=WAIT;
									saida<=nula;
								end else
								if(button==1'b1)
								begin
									state<=LED_VIBRA2;
									saida<=led_vibra0;
								end else
										begin
											state<=LED_VIBRA_APITA;
											saida<=led_vibra_apita0;
										end
							 end
		LED_VIBRA2		: begin
								if(crianca==1'b0 && communication==1'b1)
								begin
									state<=WAIT;
									saida<=nula;
								end else
										begin
											//TEMPO 3
											//#10;
											/*count = 0;
											repeat(1000) begin
												count = count+1;
												#10;
											end
											*/
											state<=#5 LED_VIBRA_APITA;
											saida<=#5 led_vibra_apita0;
										end
								
							 end
		default			: begin	
								state<=WAIT;
								saida<=nula;
							 end
		endcase
end
endmodule
