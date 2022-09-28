module Display (number, display);

input [13:0] number;
output reg [0:6] display;

always @ (number) begin
	case (number)
		1: display <= 7'b1001111;
		2: display <= 7'b0010010;
		3: display <= 7'b0000110;
		4: display <= 7'b1001100;
		5: display <= 7'b0100100;
		6: display <= 7'b0100000;
		7: display <= 7'b0001101;
		8: display <= 7'b0000000;
		9: display <= 7'b0000100;
		10: display <= 7'b1111110;
		11: display <= 7'b1111111;
		default: display <= 7'b0000001;
	endcase
end

endmodule