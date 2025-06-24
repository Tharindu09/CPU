`include "cpu.v"

/* 
Assembly instruction set  which used in Teestbench
loadi 1 0x02
loadi 2 0x08
mult 3 1 2
sll 4 2 0x02
srl 5 2 0x01
sra 6 3 0x02
bne 0x01 1 2

*/

module cpu_tb;

    reg CLK,RESET;
    wire [31:0] PC,INSTRUCTION;
    integer i;

    reg [7:0] instruction_mem[1023:0];  //Array for store Instruction

    initial begin
        $readmemb("instr_mem.mem",instruction_mem);  //Read file wich include binary instruction(32 bit)
    end

    cpu mycpu(PC,INSTRUCTION,CLK,RESET);    //Instantiate Cpu module

    initial begin

        $dumpfile("cpu-wavedata.vcd");      //Wavedata file
        $dumpvars(0,cpu_tb);
        for(i=0;i<8;i++)
			$dumpvars(0,mycpu.cpu_reg.register[i]);     //To observe each registers value

        CLK= 1'b0;      //Initiate CLK=0 and RESET=1
        RESET=1'b1;

        #5
        RESET=1'b0;     //After 5 delay RESET=1

        #100 $finish;
    end

    always #4 CLK=~CLK; //Keep Clock pulse ( T = 8  time unit)

    assign #2 INSTRUCTION = {instruction_mem[PC+3],instruction_mem[PC+2],instruction_mem[PC+1],instruction_mem[PC]};  //Make 32 bit instruction from instuction_mem array


endmodule