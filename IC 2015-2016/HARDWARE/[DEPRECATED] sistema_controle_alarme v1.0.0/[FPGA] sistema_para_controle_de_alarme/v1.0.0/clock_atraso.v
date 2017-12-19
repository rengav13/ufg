module clock_atraso(Clock, clock_out);
    input Clock;
    output reg clock_out;
	 
	 reg [25:0] slow_count;
	 
    initial begin
		slow_count <=0;
		clock_out <= 1'b0;
	 end 
    // A large counter to produce a 1 second (approx) enable
    always @(posedge Clock)
        slow_count <= slow_count + 1'b1;
		  
	always @(negedge slow_count[25])
		clock_out <= !clock_out;
endmodule
        
		  