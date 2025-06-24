/*Shifting Module 
Group 11 Lab5  part 5
*/

//2x1 Mux
module mux2x1(out, in0,in1,sel);
	//Declaration of input and output ports
    input in0, in1,sel;
    output out ;
    wire orIn0 ,orIn1;

	//MUX implementation
    and (orIn0,in0,!sel);
    and (orIn1,in1,sel);
    or (out , orIn0,orIn1);
	
endmodule


//3x1 Mux
module mux3x1 (out , in2 , in1 , in0 , sel);
	//Declaration of input and output ports
    input in0,in1,in2;
    output out ; 
    input [1:0] sel ;
    wire orIn [2:0] ;
    wire andOut[2:0];

	//Mux implementation
    or (out , orIn[0], orIn[1] , orIn[2]);

    and(andOut[0] , !sel[0],!sel[1]);
    and (orIn[0] , in0 , andOut[0]);


    and(andOut[1] , sel[0],!sel[1]);
    and (orIn[1] , in1 , andOut[1]);

    and(andOut[2] , !sel[0],sel[1]);
    and (orIn[2] , in2 , andOut[2]);

endmodule


// Logical Left shift  unit
module LeftShift(out, data1, data2);

    // Declaration of input and output ports
    input [7:0] data1, data2; // data1 is the value to be shifted, data2 provides the shift amount
    output [7:0] out; // Output after the shift operation
    
    // Intermediate connections between MUX layers
    wire [7:0] lOut [2:0]; // 2D array to hold intermediate shift results between MUX layers

    // MUX Layer 1: Handles 1-bit shifts
    mux2x1 layer00(lOut[0][0], data1[0], 1'b0, data2[0]);
    mux2x1 layer01(lOut[0][1], data1[1], data1[0], data2[0]);
    mux2x1 layer02(lOut[0][2], data1[2], data1[1], data2[0]);
    mux2x1 layer03(lOut[0][3], data1[3], data1[2], data2[0]);
    mux2x1 layer04(lOut[0][4], data1[4], data1[3], data2[0]);
    mux2x1 layer05(lOut[0][5], data1[5], data1[4], data2[0]);
    mux2x1 layer06(lOut[0][6], data1[6], data1[5], data2[0]);
    mux2x1 layer07(lOut[0][7], data1[7], data1[6], data2[0]);

    // MUX Layer 2: Handles 2-bit shifts
    mux2x1 layer10(lOut[1][0], lOut[0][0], 1'b0, data2[1]);
    mux2x1 layer11(lOut[1][1], lOut[0][1], 1'b0, data2[1]);
    mux2x1 layer12(lOut[1][2], lOut[0][2], lOut[0][0], data2[1]);
    mux2x1 layer13(lOut[1][3], lOut[0][3], lOut[0][1], data2[1]);
    mux2x1 layer14(lOut[1][4], lOut[0][4], lOut[0][2], data2[1]);
    mux2x1 layer15(lOut[1][5], lOut[0][5], lOut[0][3], data2[1]);
    mux2x1 layer16(lOut[1][6], lOut[0][6], lOut[0][4], data2[1]);
    mux2x1 layer17(lOut[1][7], lOut[0][7], lOut[0][5], data2[1]);

    // MUX Layer 3: Handles 4-bit shifts
    mux2x1 layer20(lOut[2][0], lOut[1][0], 1'b0, data2[2]);
    mux2x1 layer21(lOut[2][1], lOut[1][1], 1'b0, data2[2]);
    mux2x1 layer22(lOut[2][2], lOut[1][2], 1'b0, data2[2]);
    mux2x1 layer23(lOut[2][3], lOut[1][3], 1'b0, data2[2]);
    mux2x1 layer24(lOut[2][4], lOut[1][4], lOut[1][0], data2[2]);
    mux2x1 layer25(lOut[2][5], lOut[1][5], lOut[1][1], data2[2]);
    mux2x1 layer26(lOut[2][6], lOut[1][6], lOut[1][2], data2[2]);
    mux2x1 layer27(lOut[2][7], lOut[1][7], lOut[1][3], data2[2]);

    // Assigning final output after 2 time unit delay
    // If shift amount is 0x08, output is all zeros
    assign #2 out = (data2 == 8'd8) ? 8'd0 : lOut[2];

endmodule

// Perform Right Shift operations

module RightShift(out, data1, data2);

/*data2[7:6] --> 00 for logical shift
             --> 01 for arithmetic shift
             --> 10 for rotate
*/

    // Declaration of input and output ports
    input [7:0] data1, data2; // data1 is the value to be shifted, data2 provides shift amount and type
    output reg [7:0] out; // Output after the shift operation

    // Intermediate connections between MUX layers
    wire [7:0] rOut [2:0]; // 2D array to hold intermediate shift results between MUX layers

    // Connections for selecting between logical shift, arithmetic shift, and rotate operations
    wire m07; // Intermediate wire for layer 1 MUX
    wire m17, m16; // Intermediate wires for layer 2 MUX
    wire m27, m26, m25, m24; // Intermediate wires for layer 3 MUX

    // MUX Layer 1: Handles 1-bit shifts
    mux2x1 layer00(rOut[0][0], data1[0], data1[1], data2[0]);
    mux2x1 layer01(rOut[0][1], data1[1], data1[2], data2[0]);
    mux2x1 layer02(rOut[0][2], data1[2], data1[3], data2[0]);
    mux2x1 layer03(rOut[0][3], data1[3], data1[4], data2[0]);
    mux2x1 layer04(rOut[0][4], data1[4], data1[5], data2[0]);
    mux2x1 layer05(rOut[0][5], data1[5], data1[6], data2[0]);
    mux2x1 layer06(rOut[0][6], data1[6], data1[7], data2[0]);
    mux2x1 layer07(rOut[0][7], data1[7], m07, data2[0]);
    mux3x1 M07(m07, data1[0], data1[7], 1'b0, data2[7:6]);

    // MUX Layer 2: Handles 2-bit shifts
    mux2x1 layer10(rOut[1][0], rOut[0][0], rOut[0][2], data2[1]);
    mux2x1 layer11(rOut[1][1], rOut[0][1], rOut[0][3], data2[1]);
    mux2x1 layer12(rOut[1][2], rOut[0][2], rOut[0][4], data2[1]);
    mux2x1 layer13(rOut[1][3], rOut[0][3], rOut[0][5], data2[1]);
    mux2x1 layer14(rOut[1][4], rOut[0][4], rOut[0][6], data2[1]);
    mux2x1 layer15(rOut[1][5], rOut[0][5], rOut[0][7], data2[1]);
    mux2x1 layer16(rOut[1][6], rOut[0][6], m16, data2[1]);
    mux3x1 M16(m16, rOut[0][0], rOut[0][7], 1'b0, data2[7:6]);
    mux2x1 layer17(rOut[1][7], rOut[0][7], m17, data2[1]);
    mux3x1 M17(m17, rOut[0][1], rOut[0][7], 1'b0, data2[7:6]);

    // MUX Layer 3: Handles 4-bit shifts
    mux2x1 layer20(rOut[2][0], rOut[1][0], rOut[1][4], data2[2]);
    mux2x1 layer21(rOut[2][1], rOut[1][1], rOut[1][5], data2[2]);
    mux2x1 layer22(rOut[2][2], rOut[1][2], rOut[1][6], data2[2]);
    mux2x1 layer23(rOut[2][3], rOut[1][3], rOut[1][7], data2[2]);
    mux2x1 layer24(rOut[2][4], rOut[1][4], m24, data2[2]);
    mux3x1 M24(m24, rOut[1][0], rOut[1][7], 1'b0, data2[7:6]);
    mux2x1 layer25(rOut[2][5], rOut[1][5], m25, data2[2]);
    mux3x1 M25(m25, rOut[1][1], rOut[1][7], 1'b0, data2[7:6]);
    mux2x1 layer26(rOut[2][6], rOut[1][6], m26, data2[2]);
    mux3x1 M26(m26, rOut[1][2], rOut[1][7], 1'b0, data2[7:6]);
    mux2x1 layer27(rOut[2][7], rOut[1][7], m27, data2[2]);
    mux3x1 M27(m27, rOut[1][3], rOut[1][7], 1'b0, data2[7:6]);

    //Final output with 2 time unit delay
	always @ (data1, data2, rOut[2])
	begin
		if (data2[7:6] == 2'b10) #2 out = rOut[2];	//Rotate right
		
		else if (data2[7:6] == 2'b01)   //Arithmatic right shift
		begin
			if (data2[3:0] == 4'd8) #2 out = {8{data1[7]}};	//If shift amount is 08, set all bits of out to sign bit
			else #2 out = rOut[2];		//Shifted out
		end
		
		else if (data2[7:6] == 2'b00)   //Logical right shift
		begin
			if (data2[3:0] == 4'd8) #2 out = 8'b0;	//If shift amount is 08, set all bits of out to zero
			else #2 out = rOut[2];		//Shifted out
		end
    end

endmodule

