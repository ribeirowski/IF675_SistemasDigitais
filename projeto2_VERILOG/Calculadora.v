module Calculadora (CLK, B1, B2, B3, B4, N1, N2, Dec1, Uni1, Dec2, Uni2, MilResult, CentResult, DecResult, UniResult, Signal);

	input B1, B2, B3, B4, CLK, Signal;
	input [6:0] N1, N2;
	output [0:6] Dec1, Uni1, Dec2, Uni2, MilResult, CentResult, DecResult, UniResult;
	parameter Off = 0, Soma = 1, Sub = 2, Mult = 3, On = 4;
	reg [2:0] Estado = Off;
	reg On_Off = 0, Som, Subt, Mul = 0;
	reg b1 = 0, b2 = 0, b3 = 0, b4 = 0;
	reg Reset = 1;
	wire [31:0] Data;
	
	always @ (posedge CLK) begin
		
		if(~B1 || Data[31:16] == 16'h8e71) begin
			b1 = 1;
			Reset = 0;
		end
		else if(B1 && b1) begin
			Reset = 1;
			b1 = 0;
			if(Estado != Soma) begin
				Som = 1;
				Subt = 0;
				Mul = 0;
			end
			else
				Som = 0;
		end
		if(~B2 || Data[31:16] == 16'h9c63) begin
			b2 = 1;
			Reset = 0;
		end
		else if(B2 && b2) begin
			Reset = 1;
			b2 = 0;
			if(Estado != Sub) begin
				Subt = 1;
				Mul = 0;
				Som = 0;
			end
			else
				Subt = 0;
		end
		if(~B3 || Data[31:16] == 16'h9e61) begin
			b3 = 1;
			Reset = 0;
		end
		else if(B3 && b3) begin
			Reset = 1;
			b3 = 0;
			if(Estado != Mult) begin
				Mul = 1;
				Subt = 0;
				Som = 0;
			end
			else
				Mul = 0;
		end
		if(~B4 || Data[31:16] == 16'h8d72) begin
			b4 = 1;
			Reset = 0;
		end
		else if(B4 && b4) begin
			Reset = 1;
			b4 = 0;
			if(Estado == Off) begin
				On_Off = 1;
				Subt = 0;
				Mul = 0;
				Som = 0;
			end
			else
				On_Off = 0;
		end
	end
	
	always @(posedge CLK) begin
		case(Estado)
			Off: begin
				if(On_Off) begin
					Estado <= On;
				end
			end
			Soma: begin
				if(~On_Off) begin
					Estado <= Off;
				end
				if(~Som) begin
					Estado <= On;
				end
				if(Subt) begin
					Estado <= Sub;
				end
				if(Mul) begin
					Estado <= Mult;
				end
			end
			Sub: begin
				if(~On_Off) begin
					Estado <= Off;
				end
				if(Som) begin
					Estado <= Soma;
				end
				if(~Subt) begin
					Estado <= On;
				end
				if(Mul) begin
					Estado <= Mult;
				end
			end
			Mult: begin
				if(~On_Off) begin
					Estado <= Off;
				end
				if(Som) begin
					Estado <= Soma;
				end
				if(Subt) begin
					Estado <= Sub;
				end
				if(~Mul) begin
					Estado <= On;
				end
			end
			On: begin
				if(~On_Off) begin
					Estado <= Off;
				end
				if(Som) begin
					Estado <= Soma;
				end
				if(Subt) begin
					Estado <= Sub;
				end
				if(Mul) begin
					Estado <= Mult;
				end
			end
		endcase
	end
	
	Seletor select (Estado, N1, N2, Dec1, Uni1, Dec2, Uni2, MilResult, CentResult, DecResult, UniResult);
	
	InfraRed IR (CLK, Signal, Data, Reset);

	
endmodule