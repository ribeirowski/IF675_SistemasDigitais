module InfraRed(clk,	Signal, Data, Reset);

	parameter Inicio = 2'b00, Espera = 2'b01, Leia = 2'b10, Inicio_Maior_Dur =  262143, Espera_Menor_Dur =  230000, Espera_Maior_Dur =  210000, Data_Maior_Dur =  41500;

	input clk, Reset, Signal;      
	output reg [31:0] Data;

	reg Inicio_count_flag, state_count_flag, data_count_flag, data_ready;                       
	reg [17:0] Inicio_count, state_count, data_count;                        
	reg [31:0] data, data_buf; 
	reg [5:0] bitcount;        
	reg [1:0] state;          

	always @(posedge clk or negedge Reset) begin
			if (!Reset)
				Inicio_count <= 0;
			else if (Inicio_count_flag)
				 Inicio_count <= Inicio_count + 1'b1;
			else  
				 Inicio_count <= 0; 
	end

	always @(posedge clk or negedge Reset) begin
			if (!Reset)
				 Inicio_count_flag <= 1'b0;
			else if ((state == Inicio) && !Signal)
				 Inicio_count_flag <= 1'b1;
			else                           
				 Inicio_count_flag <= 1'b0;		     		 	
	end  

	always @(posedge clk or negedge Reset) begin
			if (!Reset)
				state_count <= 0;
			else if (state_count_flag)
				 state_count <= state_count + 1'b1;
			else  
				 state_count <= 0;	      		 	
	end

	always @(posedge clk or negedge Reset) begin
			if (!Reset)
				state_count_flag <= 1'b0;
			else if ((state == Espera) && Signal)
				 state_count_flag <= 1'b1;
			else  
				 state_count_flag <= 1'b0;     		 	
	end

	always @(posedge clk or negedge Reset) begin
			if (!Reset)
				data_count <= 1'b0;
			else if(data_count_flag)
				 data_count <= data_count + 1'b1;
			else 
				 data_count <= 1'b0;
	end

	always @(posedge clk or negedge Reset) begin	
			if (!Reset)
				data_count_flag <= 0;	
			else if ((state == Leia) && Signal)
				 data_count_flag <= 1'b1;  
			else
				 data_count_flag <= 1'b0; 
	end
	 
	always @(posedge clk or negedge Reset) begin
			if (!Reset)
				bitcount <= 6'b0;
			else if (state == Leia)
			begin
				if (data_count == 20000)
						bitcount <= bitcount + 1'b1;
			end   
				else
					bitcount <= 6'b0;
	end

	always @(posedge clk or negedge Reset) begin 
			if (!Reset)
				state <= Inicio;
			else 
				case (state)
					Inicio     : if (Inicio_count > Espera_Menor_Dur)
										 state <= Espera; 
					Espera : if (state_count > Espera_Maior_Dur)
										 state <= Leia;
					Leia : if ((data_count >= Inicio_Maior_Dur) || (bitcount >= 33))
													state <= Inicio;
					default  : state <= Inicio;
			  endcase
	end

	always @(posedge clk or negedge Reset) begin
			if (!Reset)
				data <= 0;
			else if (state == Leia)
			begin
				 if (data_count >= Data_Maior_Dur) 
					 data[bitcount-1'b1] <= 1'b1;
			end
			else
				 data <= 0;
	end	

	always @(posedge clk or negedge Reset) begin
			if (!Reset)
				data_ready <= 1'b0;
			else if (bitcount == 32)   
				begin
					 if (data[31:24] == ~data[23:16])
					 begin		
							data_buf <= data; 
						  data_ready <= 1'b1; 
					 end	
					 else
						  data_ready <= 1'b0 ;
				end
				else
					data_ready <= 1'b0 ;
	end

	always @(posedge clk or negedge Reset) begin
			if (!Reset)
				Data <= 32'b0000;
			else if (data_ready)
			  Data<= data_buf;
	end				
endmodule