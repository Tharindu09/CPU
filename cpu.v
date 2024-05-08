/*
Group 11 Lab 5 part 3

*/



`include "addition_modules.v"
`include "control_unit.v"
`include "reg.v"
`include "alu.v"

module cpu(PC,INSTRUCTION,CLK,RESET);

    input [31:0] INSTRUCTION;  // Input instruction
    input CLK,RESET;  // Clock and reset signals
    output [31:0] PC;  // Program counter output

    // Instantiate PC unit
    pc_unit cpu_pc(CLK,RESET,PC);

    wire [7:0] opcode , immediate;  // Wires for opcode and immediate value
    wire [2:0] readreg1 , readreg2 , writereg , aluop;  // Wires for register and ALU operations
    wire write_enable , reg2_sign_sel , op2_sel;  // Control signals

    // Extract opcode, immediate value, and register operations from the instruction
    assign opcode   = INSTRUCTION[31:24];
    assign immediate = INSTRUCTION[7:0];
    assign readreg1 = INSTRUCTION[10:8];
    assign readreg2 = INSTRUCTION[2:0];
    assign writereg = INSTRUCTION [18:16]; 

    // Instantiate control unit
    control_unit cpu_control(opcode,write_enable,aluop,reg2_sign_sel,op2_sel);

    wire [7:0] regout2,regout1;  // Register output signals
    wire [7:0] aluresult;  // ALU result

    // Instantiate register file
    reg_file cpu_reg(aluresult, regout1, regout2, writereg, readreg1, readreg2, write_enable, CLK, RESET );
    
    wire [7:0] regout2_negative;  // Negative of regout2
    // Compute two's complement of regout2
    twos_compliment cpu_compliment(regout2,regout2_negative);

    wire [7:0] reg2_mux_out;  // Output of the second mux
    // Select between regout2 and its negative using reg2_sign_sel
    mux_2x1 cpu_mux1(regout2,regout2_negative,reg2_sign_sel,reg2_mux_out);

    wire [7:0] oprend2;  // Operand 2 for the ALU
    // Select between reg2_mux_out and immediate using op2_sel
    mux_2x1 cpu_mux2(reg2_mux_out,immediate,op2_sel,oprend2);

    // Perform ALU operation
    //alu(aluResult, select, data1, data2);
    alu cpu_alu(aluresult, aluop, regout1, oprend2);

endmodule
