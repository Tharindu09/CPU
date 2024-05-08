/*
Group 11 Lab 5 part 3

*/



module control_unit(OPCODE,WRITE_ENABLE,ALUOP,REG2_SIGN_SEL,OP2_SEL);

    input [7:0] OPCODE;
    output reg WRITE_ENABLE,REG2_SIGN_SEL,OP2_SEL;    //Used in procedeual block. Hence reg use
    output reg [2:0] ALUOP;
    

/*  loadi = "00000000"
	  mov 	= "00000001"
	  add 	= "00000010"
	  sub 	= "00000011"
	  and 	= "00000100"
	  or  	= "00000101"    */

/*  SELECT = 000 : FORWARD
    SELECT = 001 : ADD
    SELECT = 010 : AND
    SELECT = 011 : OR             */
    

    always @ (OPCODE)begin
      
      case (OPCODE)
        //loadi
        8'b00000000: #1 {WRITE_ENABLE,ALUOP,REG2_SIGN_SEL,OP2_SEL} = 6'b1_000_x_1;   //OP2_SEL       = 0: Reg2 out  , 1: Immidiate value 
                                                                                     //Reg2_Sign_SEL = 0:Positive value 
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

               
      endcase



    end


endmodule