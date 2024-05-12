/*
Group 11 Lab 5 part 4

*/

//Compute 2's complimet of input
module twos_compliment(IN,OUT);
    
    input [7:0] IN;  // Input signal
    output [7:0] OUT;  // Two's complement output

    // Calculate two's complement
    assign #1 OUT = ~IN + 8'd1;

endmodule

//8 bit input 2x1 mux
module mux_2x1(IN0,IN1,SELECT,OUT);
    
    input [7:0] IN0,IN1;  // Input signals
    input SELECT;  // Selection signal
    output reg [7:0] OUT;  // Selected output

    always @(IN0,IN1,SELECT) begin
        // Select the input based on SELECT
        if (SELECT == 1'b0)
            OUT = IN0;
        else
            OUT = IN1;
    end
endmodule

//32 bit input 2x1 mux
module mux_32(IN0,IN1,SELECT,OUT);
    
    input [31:0] IN0,IN1;  // Input signals
    input SELECT;  // Selection signal
    output reg [31:0] OUT;  // Selected output

    always @(IN0,IN1,SELECT) begin
        // Select the input based on SELECT
        if (SELECT == 1'b0)
            OUT = IN0;
        else
            OUT = IN1;
    end
endmodule


//Extend address to 32 bit and leftshift by two for word alling 
module extend(address,byteAddress);
    
    input [7:0] address;
    output [31:0] byteAddress;

    assign byteAddress = { {32{address[7]}}, address,2'b00 };

endmodule

//Combinational AND for Branch Select signal. zero from ALU and branch from CU
module branchSel(branch,zero,branch_sel);
    input  branch,zero;
    output branch_sel;

    assign branch_sel=branch & zero;  //If zero=1 and branch =1, branch_sel=1 

endmodule

//Get Jump Address by concatenating most significant 4 bits of PC+4 with joffset
module concatenate(pc_4,joffset,jumpAddress);
    input [31:0] pc_4;  //PC+4
    input [7:0] joffset; //joffset from INSTRUCTION
    output [31:0] jumpAddress;  //32 bit jump adddress

    wire [27:0] extend_jump;

    assign extend_jump = {{26{joffset[7]}},joffset,2'b00};  //Extend 7 bit joffset and leftshift by 2
    assign jumpAddress = {pc_4[31:28],extend_jump};     //Concatenate [31:28] bits of PC+4 with [27:0] bits of extend_jump
endmodule

//Adder for PC+4
module pc_adder1(CURRENT_PC,PC_4);
   
    input [31:0] CURRENT_PC;  // Current program counter
    output [31:0] PC_4;  // Program counter + 4 output

    // Add 4 to the current program counter
    assign #1 PC_4 = CURRENT_PC + 32'd4;

endmodule

//Adder for ADD offset for PC
module pc_adder2(pc_4,offset,offset_pc);
   
    input [31:0] offset,pc_4;  // Current program counter
    output [31:0] offset_pc;  // Program counter + offset

    // Add offset to the current program counter
    assign #1 offset_pc = pc_4 + offset;

endmodule


//Program Counter
module pc_unit(CLK,RESET,NEXT_PC,PC);
    
    input CLK,RESET;  // Clock and reset signals
    input  [31:0] NEXT_PC;
    output reg [31:0] PC;  // Program counter output

    always @(posedge CLK) begin
        // Reset PC to 0 on reset signal
        if (RESET == 1'b1)
            #1 PC = 32'b0;
        else
            #1 PC = NEXT_PC;  // Update PC
    end
endmodule

