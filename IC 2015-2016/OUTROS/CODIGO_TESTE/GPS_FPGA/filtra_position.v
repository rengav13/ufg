module filtra_position(
				input reg[8:0] GPout);

reg[2:0] state = 0;
reg[2:0] state_pos = 0;
reg[10:0] count = 0;
reg[14*8-1:0] buffer1 = 0;
reg[14*8-1:0] buffer2 = 0;
reg[5*8-1:0] buffer_comand = 0;

localparam STATE_IDLE = 0, STATE_LATITUDE = 1, STATE_LATITUDE_ORIENTATION = 2, STATE_LONGITUDE = 3,STATE_LONGITUDE_ORIENTATION = 4;
localparam STATE_FILTRO_IDLE = 0;
always@(posedge clk) begin
		
		case(state)
		0: begin	if(GPout == "$") state = 1; else state = 0; end
		1: if(GPout == "G") state = 2; else state = 0;
		2:	if(GPout == "P") state = 3; else state = 0;
		3:	if(GPout == "G") state = 4; else state = 0;
		4:	if(GPout == "L") state = 5; else state = 0;
		5:	if(GPout == "L") state = 6; else state = 0;
		6: begin	
				case(state_pos)
				STATE_IDLE:begin if(GPout == ",") state_pos = STATE_LATITUDE; else state_pos = STATE_IDLE; end 
				STATE_LATITUDE:begin 
					if(GPout == ",")begin state_pos = STATE_LATITUDE_ORIENTATION; end 
					else begin buffer1 = {buffer1[13*8-1:0],GPout};  
									state_pos = STATE_LATITUDE;
						  end
					end
				STATE_LATITUDE_ORIENTATION:begin 
					if(GPout == ",")begin state_pos = STATE_LONGITUDE; end 
					else begin buffer1 = {buffer1[13*8-1:0],GPout};  
									state_pos = STATE_LATITUDE_ORIENTATION;
						  end
					end
				STATE_LONGITUDE:begin 
					if(GPout == ",")begin state_pos = STATE_LONGITUDE_ORIENTATION;	end 
					else begin buffer2 = {buffer2[13*8-1:0],GPout};  
									state_pos = STATE_LONGITUDE;
						  end
					end
				STATE_LONGITUDE_ORIENTATION:begin 
					if(GPout == ",")begin 
											state_pos = STATE_IDLE;
											state = 0;
											data_line1 = {"LAT",buffer1[11*8-1:0]}; 
											data_line2 = {"LO",buffer2[12*8-1:0]};
											buffer1=0;
											buffer2=0;
											end 
					else begin buffer2 = {buffer2[13*8-1:0],GPout};  
									state_pos = STATE_LONGITUDE_ORIENTATION;
						  end
					end
				default: state_pos = STATE_IDLE;
				endcase
			end
		default: state = 0;
		endcase
end
endmodule


/*case(state)
		0: if(GPout == "$")state = 1; else state = 0;
		1: begin if(buffer_comand == "GPGLL")begin state = 6; end
				else if(GPout != ",")begin state = 1;
					buffer_comand = {buffer_comand[4*8-1:0],GPout};
				end else state = 0;
			end
		6: begin	
				case(state_pos)
				STATE_IDLE:begin if(GPout == ",") state_pos = STATE_LATITUDE; else state_pos = STATE_IDLE; end 
				STATE_LATITUDE:begin 
					if(GPout == ",")begin state_pos = STATE_LATITUDE_ORIENTATION; end 
					else begin buffer1 = {buffer1[13*8-1:0],GPout};  
									state_pos = STATE_LATITUDE;
						  end
					end
				STATE_LATITUDE_ORIENTATION:begin 
					if(GPout == ",")begin state_pos = STATE_LONGITUDE; end 
					else begin buffer1 = {buffer1[13*8-1:0],GPout};  
									state_pos = STATE_LATITUDE_ORIENTATION;
						  end
					end
				STATE_LONGITUDE:begin 
					if(GPout == ",")begin state_pos = STATE_LONGITUDE_ORIENTATION;	end 
					else begin buffer2 = {buffer2[13*8-1:0],GPout};  
									state_pos = STATE_LONGITUDE;
						  end
					end
				STATE_LONGITUDE_ORIENTATION:begin 
					if(GPout == ",")begin 
											state_pos = STATE_IDLE;
											state = 0;
											data_line1 = {"LAT",buffer1[11*8-1:0]}; 
											data_line2 = {"LO",buffer2[12*8-1:0]};
											buffer1=0;
											buffer2=0;
											end 
					else begin buffer2 = {buffer2[13*8-1:0],GPout};  
									state_pos = STATE_LONGITUDE_ORIENTATION;
						  end
					end
				default: state_pos = STATE_IDLE;
				endcase
			end
		default: state = 0;
		endcase
		*/
		