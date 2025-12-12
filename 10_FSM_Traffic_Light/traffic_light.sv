
module traffic_light (
    input  logic clk,
    input  logic rst_n,
    output logic red,
    output logic green,
    output logic yellow
);

  // States
  typedef enum { S1_RED, S2_GREEN, S3_YELLOW } state_t;
  state_t state, next;

  logic [4:0] timer; // counts cycles

  // State register and timer
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= S1_RED;
      timer <= 0;
    end else begin
      // Transition when timer reaches limit
      if ((state == S1_RED   && timer == 19) ||
          (state == S2_GREEN && timer == 14) ||
          (state == S3_YELLOW&& timer == 4)) begin
        state <= next;
        timer <= 0;
      end else begin
        timer <= timer + 1;
      end
    end
  end

  // Next-state logic
  always_comb begin
    case (state)
      S1_RED:    next = S2_GREEN;
      S2_GREEN:  next = S3_YELLOW;
      S3_YELLOW: next = S1_RED;
    endcase
  end

  // Moore outputs
  always_comb begin
    red    = (state == S1_RED);
    green  = (state == S2_GREEN);
    yellow = (state == S3_YELLOW);
  end

endmodule




