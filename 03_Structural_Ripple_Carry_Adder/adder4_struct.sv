module adder4_struct (
    input  logic a0, a1, a2, a3,
    input  logic b0, b1, b2, b3,
    output logic sum0, sum1, sum2, sum3,
    output logic Cout
);
  // Internal carries
  logic c1, c2, c3;

  // Bit 0 (LSB) with Cin = 0
  full_adder FA0 (.a(a0), .b(b0), .cin(1'b0), .sum(sum0), .cout(c1));

  // Bit 1
  full_adder FA1 (.a(a1), .b(b1), .cin(c1), .sum(sum1), .cout(c2));

  // Bit 2
  full_adder FA2 (.a(a2), .b(b2), .cin(c2), .sum(sum2), .cout(c3));

  // Bit 3 (MSB)
  full_adder FA3 (.a(a3), .b(b3), .cin(c3), .sum(sum3), .cout(Cout));

endmodule
