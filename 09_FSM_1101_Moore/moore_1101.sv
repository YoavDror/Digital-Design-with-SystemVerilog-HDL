
module moore_1101 (
  input  logic clk,
  input  logic rst_n,     
  input  logic x,         
  output logic z          
);

  typedef enum logic [2:0] { S0, S1, S2, S3, S4 } state_e;
  state_e state, next;

  // State register
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) state <= S0;
    else        state <= next;
  end

  // Moore output: depends only on state
  always_comb begin
    z = (state == S4);  
  end

 // Next-state logic
  always_comb begin
    next = state;
    case (state)
      S0:  next = (x) ? S1 : S0;

      S1:  next = (x) ? S2 : S0;      

      S2:  next = (x) ? S2 : S3;      

      S3:  next = (x) ? S4 : S0;      

      S4:  next = (x) ? S2 : S0;        
    endcase
  end
endmodule

