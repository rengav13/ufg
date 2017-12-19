`include "ShiftRegN.v"

module suav(
	input in,
	output reg out,
	input CLK);

integer t_Count;
parameter N = 8;
wire BIT_OUT;
shift_register_v vec(CLK, in, BIT_OUT);

initial begin 
	t_Count = 0;
	out = 0;
	
end

always @ (posedge CLK) begin
	if ( BIT_OUT )
		t_Count = t_Count-1;
	if ( in )
		t_Count = t_Count+1;
	if ( t_Count > (N/2) )
		out =  1'b1;
	else
		out =  1'b0;
end
endmodule
//to do: tratar possivel overflow da var t_Count; Quantos bits um integer tem?
