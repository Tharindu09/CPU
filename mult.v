/*Multiplication Module 
Group 11 Lab5  part 5
*/

//Full Adder 
module FullAdder(A, B, Cin, SUM, Cout);

	//Input and output port declaration
	input A, B, Cin;
	output SUM, Cout;
	
	//Combinational logic for SUM and CARRY bit outputs
	assign SUM = (A ^ B ^ Cin);
	assign Cout = (A & B) + (Cin & (A ^ B));

endmodule


//Calculates the product of two 8-bit numbers
module MULT(OUT,MULTIPLICAND, MULTIPLIER);

	//Input and output port declaration
	input signed [7:0] MULTIPLICAND, MULTIPLIER;
	output signed[7:0] OUT;
	
	//Carry bits for intermediate sums
	wire C0 [5:0];
	wire C1 [4:0];
	wire C2 [3:0];
	wire C3 [2:0];
	wire C4 [1:0];
	wire C5;
	
	//Intermediate sums
	wire sum0 [5:0];
	wire sum1 [4:0];
	wire sum2 [3:0];
	wire sum3 [2:0];
	wire sum4 [1:0];
	wire sum5;
	
	//Bus to store result before output
	wire [7:0] RESULT;
	
	//First bit of RESULT can be directly set
	assign RESULT[0] = MULTIPLIER[0] & MULTIPLICAND[0];	
	
	
	//Full Adder array to calculate result by shifting and adding
	
	FullAdder FA00(MULTIPLIER[0] & MULTIPLICAND[1], MULTIPLIER[1] & MULTIPLICAND[0], 1'b0, RESULT[1], C0[0]);
	FullAdder FA01(MULTIPLIER[0] & MULTIPLICAND[2], MULTIPLIER[1] & MULTIPLICAND[1], C0[0], sum0[0], C0[1]);
	FullAdder FA02(MULTIPLIER[0] & MULTIPLICAND[3], MULTIPLIER[1] & MULTIPLICAND[2], C0[1], sum0[1], C0[2]);
	FullAdder FA03(MULTIPLIER[0] & MULTIPLICAND[4], MULTIPLIER[1] & MULTIPLICAND[3], C0[2], sum0[2], C0[3]);
	FullAdder FA04(MULTIPLIER[0] & MULTIPLICAND[5], MULTIPLIER[1] & MULTIPLICAND[4], C0[3], sum0[3], C0[4]);
	FullAdder FA05(MULTIPLIER[0] & MULTIPLICAND[6], MULTIPLIER[1] & MULTIPLICAND[5], C0[4], sum0[4], C0[5]);
	FullAdder FA06(MULTIPLIER[0] & MULTIPLICAND[7], MULTIPLIER[1] & MULTIPLICAND[6], C0[5], sum0[5], );
	
	
	FullAdder FA10(sum0[0], MULTIPLIER[2] & MULTIPLICAND[0], 1'b0, RESULT[2], C1[0]);
	FullAdder FA11(sum0[1], MULTIPLIER[2] & MULTIPLICAND[1], C1[0], sum1[0], C1[1]);
	FullAdder FA12(sum0[2], MULTIPLIER[2] & MULTIPLICAND[2], C1[1], sum1[1], C1[2]);
	FullAdder FA13(sum0[3], MULTIPLIER[2] & MULTIPLICAND[3], C1[2], sum1[2], C1[3]);
	FullAdder FA14(sum0[4], MULTIPLIER[2] & MULTIPLICAND[4], C1[3], sum1[3], C1[4]);
	FullAdder FA15(sum0[5], MULTIPLIER[2] & MULTIPLICAND[5], C1[4], sum1[4], );
	
	
	FullAdder FA20(sum1[0], MULTIPLIER[3] & MULTIPLICAND[0], 1'b0, RESULT[3], C2[0]);
	FullAdder FA21(sum1[1], MULTIPLIER[3] & MULTIPLICAND[1], C2[0], sum2[0], C2[1]);
	FullAdder FA22(sum1[2], MULTIPLIER[3] & MULTIPLICAND[2], C2[1], sum2[1], C2[2]);
	FullAdder FA23(sum1[3], MULTIPLIER[3] & MULTIPLICAND[3], C2[2], sum2[2], C2[3]);
	FullAdder FA24(sum1[4], MULTIPLIER[3] & MULTIPLICAND[4], C2[3], sum2[3], );
	
	
	FullAdder FA30(sum2[0], MULTIPLIER[4] & MULTIPLICAND[0], 1'b0, RESULT[4], C3[0]);
	FullAdder FA31(sum2[1], MULTIPLIER[4] & MULTIPLICAND[1], C3[0], sum3[0], C3[1]);
	FullAdder FA32(sum2[2], MULTIPLIER[4] & MULTIPLICAND[2], C3[1], sum3[1], C3[2]);
	FullAdder FA33(sum2[3], MULTIPLIER[4] & MULTIPLICAND[3], C3[2], sum3[2], );
	
	
	FullAdder FA40(sum3[0], MULTIPLIER[5] & MULTIPLICAND[0], 1'b0, RESULT[5], C4[0]);
	FullAdder FA41(sum3[1], MULTIPLIER[5] & MULTIPLICAND[1], C4[0], sum4[0], C4[1]);
	FullAdder FA42(sum3[2], MULTIPLIER[5] & MULTIPLICAND[2], C4[1], sum4[1], );
	
	
	FullAdder FA50(sum4[0], MULTIPLIER[6] & MULTIPLICAND[0], 1'b0, RESULT[6], C5);
	FullAdder FA51(sum4[1], MULTIPLIER[6] & MULTIPLICAND[1], C5, sum5, );
	
	
	FullAdder FA60(sum5, MULTIPLIER[7] & MULTIPLICAND[0], 1'b0, RESULT[7], );
	
	//Sending out result after #3 time unit delay
	assign #3 OUT = RESULT;

endmodule


