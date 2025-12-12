
module tx_rom #(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=2)
(
    input [(ADDR_WIDTH-1):0] addr,  // Address input
    input clk,                      // Clock input
    input read,                     // Read control input
    output reg [(DATA_WIDTH-1):0] q // Data output
);

    // Declare the ROM variable
    reg [DATA_WIDTH-1:0] rom [0:2**ADDR_WIDTH-1];

    initial begin
        $readmemh("memory.list", rom); // Initialize ROM with data from memory.list file
    end

    always @(posedge clk) begin
        if (read)  // Read operation when read signal is high
            q <= rom[addr];  // Output data from ROM based on address
    end

endmodule


