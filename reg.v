module reg_file(IN, OUT1, OUT2, INADDRESS, OUT1ADDRESS, OUT2ADDRESS, WRITE, CLK, RESET );

    input [7:0] IN;  // Input data
    input [2:0] INADDRESS, OUT1ADDRESS, OUT2ADDRESS;  // Input/output address
    input WRITE, CLK, RESET;  // Control signals

    output  [7:0] OUT1, OUT2;  // Output data

    reg [7:0] register [7:0];  // 8 registers, each 8 bits
    integer i;  // Integer for loop iteration

    // Asynchronously reading with 2 time delay
    assign #2 OUT1 = register[OUT1ADDRESS];  // Assign output 1 based on OUT1ADDRESS
    assign #2 OUT2 = register[OUT2ADDRESS];  // Assign output 2 based on OUT2ADDRESS

    // Synchronously reading and writing with 1 time delay
    always @(posedge CLK) begin  // Triggered on positive clock edge
        if (RESET == 1'b1) begin  // Reset condition
            for (i = 0; i < 8; i = i + 1) begin  // Loop through each register
                register[i] <= 8'b00000000;  // Reset each register to all zeros
            end
        end
        else if (WRITE == 1'b1)  // Write condition
            #1 register[INADDRESS] <= IN;  // Write IN data to the specified address in register array
    end

endmodule
