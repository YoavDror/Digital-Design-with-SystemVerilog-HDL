
module rx_ram #(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=2)(
    // Module ports
    input [(DATA_WIDTH-1):0] data,    // Data input for write operation
    input [(ADDR_WIDTH-1):0] addr,    // Address input for read and write operations
    input we,                        // Write enable input
    input clk,                       // Clock input for synchronous operation
    output reg [(DATA_WIDTH-1):0] q  // Data output for read operation
);

    // Declare the RAM variable
    reg [DATA_WIDTH-1:0] ram [0:2**ADDR_WIDTH-1];

    // Variable to hold the registered read address
    reg [ADDR_WIDTH-1:0] addr_reg;

    // Synchronous process for write and address registration
    always @ (posedge clk) begin
        if (we) // Write operation
            ram[addr] <= data;  // Write data into RAM at specified address

        addr_reg <= addr;  // Register the address on positive edge of clk
    end

    // Assign output q to data read from RAM based on addr_reg
    assign q = ram[addr_reg];

endmodule


