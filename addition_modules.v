module twos_compliment(IN,OUT);
    /*
    Two's Complement Module:
    Computes the two's complement of the input.

    Inputs:
    IN: Input signal (8 bits)
    
    Outputs:
    OUT: Two's complement output signal (8 bits)
    */
    input [7:0] IN;  // Input signal
    output [7:0] OUT;  // Two's complement output

    // Calculate two's complement
    assign #1 OUT = ~IN + 8'd1;

endmodule

module mux_2x1(IN0,IN1,SELECT,OUT);
    /*
    2x1 Mux Module:
    Selects between two input signals based on the select signal.

    Inputs:
    IN0: Input 0 (8 bits)
    IN1: Input 1 (8 bits)
    SELECT: Selection signal (1 bit)

    Output:
    OUT: Selected output signal (8 bits)
    */
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

module pc_adder(CURRENT_PC,PC_4);
    /*
    Program Counter Adder:
    Adds a constant value (4) to the current program counter.

    Inputs:
    CURRENT_PC: Current program counter (32 bits)

    Output:
    PC_4: Program counter + 4 output (32 bits)
    */
    input [31:0] CURRENT_PC;  // Current program counter
    output [31:0] PC_4;  // Program counter + 4 output

    // Add 4 to the current program counter
    assign #1 PC_4 = CURRENT_PC + 32'd4;

endmodule

module pc_unit(CLK,RESET,PC);
    /*
    Program Counter Unit:
    Controls the program counter based on clock and reset signals.

    Inputs:
    CLK: Clock signal
    RESET: Reset signal

    Output:
    PC: Program counter (32 bits)
    */
    input CLK,RESET;  // Clock and reset signals
    output reg [31:0] PC;  // Program counter output
    wire [31:0] PC_4;  // Program counter + 4

    // Instantiate PC adder
    pc_adder adder(PC,PC_4);

    always @(posedge CLK) begin
        // Reset PC to 0 on reset signal
        if (RESET == 1'b1)
            #1 PC = 32'b0;
        else
            #1 PC = PC_4;  // Increment PC by 4
    end
endmodule
