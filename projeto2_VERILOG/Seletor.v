module Seletor (Estado, N1, N2, Dec1, Uni1, Dec2, Uni2, MilResult, CentResult, DecResult, UniResult);

	input [6:0] N1, N2;
	input [2:0] Estado;
	output [0:6] Dec1, Uni1, Dec2, Uni2, MilResult, CentResult, DecResult, UniResult;
	parameter Off = 0, Soma = 1, Sub = 2, Mult = 3, On = 4;
	reg [3:0] OperMil, OperCent, OperDec, OperUni, N1Dec, N1Uni, N2Dec, N2Uni;
	reg [13:0] Resultado;
	reg [6:0] Num1, Num2;
	
	always @ (N1, N2) begin
	
		if(Estado != Off) begin
			if (N1 > 99) begin
				Num1 = 99;
				N1Dec = 9;
				N1Uni = 9;
			end
			
			else if(N1 <= 99) begin
				Num1 = N1;
				N1Dec = N1/10;
				N1Uni = N1%10;
			end
			
			if (N2 > 99) begin
				Num2 = 99;
				N2Dec = 9;
				N2Uni = 9;
			end
			
			else if (N2 <= 99) begin
				Num2 = N2;
				N2Dec = N2/10;
				N2Uni = N2%10;
			end
		end
		else begin
			N1Dec = 11;
			N1Uni = 11;
			N2Dec = 11;
			N2Uni = 11;
		end
		
	end
	
	always @ (Resultado, Estado) begin
		case(Estado)
			Off: begin
				OperMil = 11;
				OperCent = 11;
				OperDec = 11;
				OperUni = 11;
			end
			On: begin
				OperMil = 11;
				OperCent = 11;
				OperDec = 11;
				OperUni = 11;
			end
			Soma: begin
				Resultado = Num1 + Num2;
				OperMil = 11;
				OperCent = Resultado/100;
				OperDec = (Resultado%100)/10;
				OperUni = (Resultado%100)%10;
			end
			Sub: begin
				OperMil = 11;
				if(Num1 < Num2) begin
					OperCent = 10;
					Resultado = Num2 - Num1;
				end
				else begin
					OperCent = 11;
					Resultado = Num1 - Num2;
				end
				OperDec = Resultado/10;
				OperUni = Resultado%10;
			end
			Mult: begin
				Resultado = Num1 * Num2;
				OperMil = Resultado/1000;
				OperCent = (Resultado%1000)/100;
				OperDec = (Resultado%100)/10;
				OperUni = (Resultado%100)%10;
			end
		endcase
	end
			
	Display MilR(OperMil, MilResult);
	Display CentR(OperCent, CentResult);
	Display DecR(OperDec, DecResult);
	Display UniR(OperUni, UniResult);
	Display DecN1(N1Dec, Dec1);
	Display UniN1(N1Uni, Uni1);
	Display DecN2(N2Dec, Dec2);
	Display UniN2(N2Uni, Uni2);
	
endmodule
	