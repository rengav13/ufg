module shift_register_v(
input CLK,
input DATA_IN,
output BIT_OUT
);

parameter N = 21;
reg [N-1 : 0] bitShiftReg;
integer i;

initial begin
	bitShiftReg = 0;
end
always @(posedge CLK)
begin
	bitShiftReg <= { bitShiftReg[N-2:0], DATA_IN };
end 
assign BIT_OUT = bitShiftReg[ N-1 ];
endmodule


//http://www.bitweenie.com/listings/verilog-shift-register/



/*module regN(reset, CLK, D, Q);
input reset;
input CLK;
parameter N = 8; //AllowNtobechanged

input[N-1:0] D;
output [N-1:0] Q;
reg [N-1:0] Q;
always @(posedge CLK or posedge reset)
	if( reset )
		Q = 0;
	else if(CLK == 1)
		Q = D;
endmodule
//regN*/
