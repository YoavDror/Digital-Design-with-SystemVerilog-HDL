
module single_port_ram #(
  parameter ADDR_WIDTH = 4,
  parameter DATA_WIDTH = 8
)(
  input  logic                   clk,
  input  logic                   we,       
  input  logic [ADDR_WIDTH-1:0]  addr,
  input  logic [DATA_WIDTH-1:0]  din,
  output logic [DATA_WIDTH-1:0]  dout
);

  logic [DATA_WIDTH-1:0] mem [0:(2**ADDR_WIDTH)-1];

  always_ff @(posedge clk) begin
    if (we)
      mem[addr] <= din;
    else 
	  dout <= mem[addr];
  end
endmodule

