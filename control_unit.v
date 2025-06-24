/*
Group 11 Lab 5 part 5

*/


module control_unit(OPCODE,WRITE_ENABLE,ALUOP,REG2_SIGN_SEL,OP2_SEL,JUMP,BRANCH);

    input [7:0] OPCODE;
    output reg WRITE_ENABLE,REG2_SIGN_SEL,OP2_SEL;    //Used in procedeual block. Hence reg use
    output reg [2:0] ALUOP;
    output reg JUMP,BRANCH;
    

/*  loadi = "00000000"
	  mov 	= "00000001"
	  add 	= "00000010"
	  sub 	= "00000011"
	  and 	= "00000100"
	  or  	= "00000101" 
    jump  = "00000110" 
    beq   = "00000111"  
    bne   = "00001000"
    mult  = "00001001"
    sll   = "00001010"
    srl   = "00001011"
    sra   = "00001100"
    ror   = "00001101"
*/

/*  SELECT = 000 : FORWARD
    SELECT = 001 : ADD
    SELECT = 010 : AND
    SELECT = 011 : OR             */
    

    always @ (OPCODE)begin
      
      JUMP = 0;
      BRANCH=0;

      case (OPCODE)
        //loadi
        8'b00000000: #1 {WRITE_ENABLE,ALUOP,REG2_SIGN_SEL,OP2_SEL} = 6'b1_000_x_1;   //OP2_SEL   => 0: Reg2 out  , 1: Immidiate value 
                                                                                     //Reg2_Sign_SEL => 0:Positive value 
        //mov
        8'b00000001: #1 {WRITE_ENABLE,ALUOP,REG2_SIGN_SEL,OP2_SEL} = 6'b1_000_0_0;

        //add
        8'b00000010: #1 {WRITE_ENABLE,ALUOP,REG2_SIGN_SEL,OP2_SEL} = 6'b1_001_0_0;

        //sub
        8'b00000011: #1 {WRITE_ENABLE,ALUOP,REG2_SIGN_SEL,OP2_SEL} = 6'b1_001_1_0;

        //and
        8'b00000100: #1 {WRITE_ENABLE,ALUOP,REG2_SIGN_SEL,OP2_SEL} = 6'b1_010_0_0;

        //or
        8'b00000101: #1 {WRITE_ENABLE,ALUOP,REG2_SIGN_SEL,OP2_SEL} = 6'b1_011_0_0;

        //jump
        8'b00000110: #1 {WRITE_ENABLE,ALUOP,REG2_SIGN_SEL,OP2_SEL,JUMP} = 7'b0_xxx_x_x_1;

        //beq
	      8'b00000111: #1 {WRITE_ENABLE,ALUOP,REG2_SIGN_SEL,OP2_SEL,BRANCH} = 7'b0_001_1_0_1;

        //bne instruction
			  8'b00001000: #1 {WRITE_ENABLE,ALUOP,REG2_SIGN_SEL,OP2_SEL,BRANCH,JUMP} = 8'b0_001_1_0_1_1;
                               
        //mult instruction
        8'b00001001:	#1 {WRITE_ENABLE,ALUOP,REG2_SIGN_SEL,OP2_SEL} = 6'b1_110_0_0;
      
        //sll instruction
        8'b00001010:	#1 {WRITE_ENABLE,ALUOP,REG2_SIGN_SEL,OP2_SEL} = 6'b1_100_0_1;
      
        //srl instruction
        8'b00001011:	#1 {WRITE_ENABLE,ALUOP,REG2_SIGN_SEL,OP2_SEL} = 6'b1_101_0_1;

         //ror instruction
        8'b00001101:	#1 {WRITE_ENABLE,ALUOP,REG2_SIGN_SEL,OP2_SEL} = 6'b1_101_0_1;
        
        //sra instruction
        8'b00001100:	#1 {WRITE_ENABLE,ALUOP,REG2_SIGN_SEL,OP2_SEL} = 6'b1_101_0_1;
        
       
        
      endcase



    end


endmodule