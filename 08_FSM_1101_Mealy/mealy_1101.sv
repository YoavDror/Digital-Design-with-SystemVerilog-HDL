module mealy_1101 (
  input  logic clk,
  input  logic rst_n,     
  input  logic x,         
  output logic z          
);

  typedef enum logic [1:0] { S0, S1, S2, S3 } state_e;
  state_e state, next;

  // State register
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      state <= S0;
    else
      state <= next;
  end

  // Next-state and output logic
  always_comb begin
    next = state;
    z    = 1'b0;

    case (state)
      S0:  next = x ? S1 : S0;

      S1:  next = x ? S2 : S0;

      S2:  next = x ? S2 : S3;

      S3: begin
        z    = x ? 1'b1 : 1'b0;  // detect "1101" if x=1
        next = x ? S1 : S0;      // allow overlap or reset
      end
    endcase
  end
endmodule