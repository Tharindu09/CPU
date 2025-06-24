/*
Group 11 
Lab5 part5
*/

`include "mult.v"
`include "shift.v"

// Define the ALU module with inputs aluResult, select, data1, and data2
module alu(aluResult, select, data1, data2,zero);
    input [2:0] select;  // Input for selecting the ALU operation
    input [7:0] data1, data2;  // Input data for the ALU operations
    
    output reg [7:0] aluResult;  // Output result from the ALU
    output  zero;

    // Define internal wires for outputs from each unit
    wire [7:0] forwardOut, andOut, addOut, orOut,LShiftOut,multOut,rightOut;
    
    // Instantiate modules for ADD, AND, OR, and FORWARD units
    ADD add1(addOut, data1, data2,zero);
    AND and1(andOut, data1, data2);
    OR or1(orOut, data1, data2);
    FORWARD f(forwardOut, data2);
    LeftShift lshiftUnit(LShiftOut,data1, data2 );
	MULT multUnit(multOut,data1, data2);
    RightShift rshiftUnit(rightOut,data1,data2);

    // Always block to perform ALU operation based on select input and outputs from units
    always @ (forwardOut, addOut, andOut, orOut,LShiftOut,multOut,rightOut,select) begin
        case (select)
            3'b000 : aluResult = forwardOut;  // SELECT = 0 : FORWARD
            3'b001 : aluResult = addOut;      // SELECT = 1 : ADD
            3'b010 : aluResult = andOut;      // SELECT = 2 : AND
            3'b011 : aluResult = orOut;       // SELECT = 3 : OR
            3'b100 : aluResult = LShiftOut;	  //SELECT = 4 : LSHIFT (Logical left)
			3'b101 : aluResult = rightOut;	  //SELECT = 5 : Right shift,rotate
            3'b110 : aluResult = multOut;	  //SELECT = 6 : MULT
            
        endcase
    end
endmodule

// Define the ADD module for addition operation
module ADD(out, data1, data2,zero);
    input [7:0] data1, data2;  // Input data for addition
    output [7:0] out;  // Output result
    output zero;

    assign #2 out = data1 + data2;  // Perform addition with delay of 2 time units
    assign zero = (out == 8'b00000000); 
    
endmodule

// Define the AND module for bitwise AND operation
module AND(out, data1, data2);
    input [7:0] data1, data2;  // Input data for AND operation
    output [7:0] out;  // Output result
    
    assign #1 out = data1 & data2;  // Perform AND operation with delay of 1 time unit
endmodule

// Define the FORWARD module to pass data1 directly to output
module FORWARD(out, data2);
    input [7:0] data2;  // Input data
    output [7:0] out;  // Output result
    
    assign #1 out = data2;  // Output is the same as input with delay of 1 time unit
endmodule

// Define the OR module for bitwise OR operation
module OR(out, data1, data2);
    input [7:0] data1, data2;  // Input data for OR operation
    output [7:0] out;  // Output result
    
    assign #1 out = data1 | data2;  // Perform OR operation with delay of 1 time unit
endmodule




