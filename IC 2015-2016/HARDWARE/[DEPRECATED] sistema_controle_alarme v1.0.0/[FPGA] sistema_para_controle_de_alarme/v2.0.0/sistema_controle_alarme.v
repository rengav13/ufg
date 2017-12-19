module sistema_controle_alarme(saida,crianca, communication, button, clk);

input crianca,communication,button,clk;
output saida;

wire led;

controle control(saida,led, communication, button, clk);

endmodule