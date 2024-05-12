/*
Group 11 Lab 5 part 4

*/

`include "addition_modules.v"
`include "control_unit.v"
`include "reg.v"
`include "alu.v"

module cpu(PC,INSTRUCTION,CLK,RESET);

    input [31:0] INSTRUCTION;  // Input instruction
    input CLK,RESET;  // Clock and reset signals
    output [31:0] PC;  // Program counter output

    wire [7:0] opcode , immediate,offset;  // Wires for opcode and immediate value
    wire [2:0] readreg1 , readreg2 , writereg , aluop;  // Wires for register and ALU operations
    wire write_enable , reg2_sign_sel , op2_sel;  // Control signals

    // Extract opcode, immediate value, and register operations from the instruction
    assign opcode   = INSTRUCTION[31:24];
    assign immediate = INSTRUCTION[7:0];
    assign readreg1 = INSTRUCTION[10:8];
    assign readreg2 = INSTRUCTION[2:0];
    assign writereg = INSTRUCTION [18:16]; 
    assign offset = INSTRUCTION [23:16];

    wire jump,branch,zero;
    wire [7:0] regout2,regout1;  // Register output signals
    wire [7:0] aluresult;  // ALU result
    wire [7:0] regout2_negative;  // Negative of regout2
    wire [7:0] reg2_mux_out;  // Output of the second mux
    wire [7:0] oprend2;  // Operand 2 for the ALU

    // Instantiate Modules
    control_unit cpu_control(opcode,write_enable,aluop,reg2_sign_sel,op2_sel,jump,branch);    // Instantiate control unit
    
    reg_file cpu_reg(aluresult, regout1, regout2, writereg, readreg1, readreg2, write_enable, CLK, RESET ); // Instantiate register file
    
    twos_compliment cpu_compliment(regout2,regout2_negative);   // Compute two's complement of regout2
    
    mux_2x1 cpu_mux1(regout2,regout2_negative,reg2_sign_sel,reg2_mux_out);  // Select between regout2 and its negative using reg2_sign_sel
    
    mux_2x1 cpu_mux2(reg2_mux_out,immediate,op2_sel,oprend2);   // Select between reg2_mux_out and immediate using op2_sel

    alu cpu_alu(aluresult, aluop, regout1, oprend2,zero);   // Perform ALU operation


    wire [31:0] byteAddress;            //Extend and shifted 32bit address
    wire [31:0] pc_4,next_pc,beq_pc;    //PC+4 , Next PC , Output of (PC+4+byteAddress)
    wire branch_sel;                    //Branch Sel = (zero & branch) 
    wire [31:0] branch_mux_out;         //Output Of Branch Select Mux
    wire [31:0] jumpaddress;            //Jump Address

    //Instantiate Other Modules
    extend cpu_extend(offset,byteAddress);  // Extend offset and leftshift by two for address alling

    pc_adder1 cpu_pcadder1(PC,pc_4);    //PC + 4

    pc_adder2 cpu_pcadder2(pc_4,byteAddress,beq_pc);    //PC+4+byteAddress

    branchSel cpu_branch(branch,zero,branch_sel);   //Combinational AND for Branch Select signal. 

    mux_32 cpu_branch_mux(pc_4,beq_pc,branch_sel,branch_mux_out);   //Mux for slect PC+4 or Branch Address
 
    concatenate cpu_concatenate(pc_4,offset,jumpaddress);   //Get Jump Address by concatenating most significant 4 bits of PC+4 with joffset
    
    mux_32 cpu_jump_mux(branch_mux_out,jumpaddress,jump,next_pc);   //Mux for select Branch_mux_out or JumpAddress 

    pc_unit cpu_pc(CLK,RESET,next_pc,PC);   // Instantiate PC unit

    

endmodule
