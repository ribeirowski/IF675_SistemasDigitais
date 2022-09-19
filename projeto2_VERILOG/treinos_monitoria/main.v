module main(number, display0, display1);

input [3:0] number;
output [0:6] display0, display1;

reg [3:0] num0, num1;

always @ (number) begin
	num0 <= number % 10;
	num1 <= number / 10;
end

decod(.number(num0), .display(display0));
decod dec(num1, display1);

endmodule
