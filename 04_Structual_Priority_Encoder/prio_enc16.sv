module prio_enc16 (
  input  logic A0,  A1,  A2,  A3,
  input  logic A4,  A5,  A6,  A7,
  input  logic A8,  A9,  A10, A11,
  input  logic A12, A13, A14, A15,
  output logic V, 
  output logic Q3, Q2, Q1, Q0
);

  // Outputs of the four 4-bit encoders (encoder0..encoder3)
  logic v0, v1, v2, v3;
  logic q0_1, q0_0; // group0 (A0..A3)
  logic q1_1, q1_0; // group1 (A4..A7)
  logic q2_1, q2_0; // group2 (A8..A11)
  logic q3_1, q3_0; // group3 (A12..A15)

  // Group select (which 4-bit group wins)
  logic s1, s0;

  // -------------------------------
  // 4× 4-bit priority encoders
  // -------------------------------
  prio_enc4 encoder0 (
    .A0(A0),  .A1(A1),  .A2(A2),  .A3(A3),
    .V(v0),   .Q1(q0_1), .Q0(q0_0)
  );

  prio_enc4 encoder1 (
    .A0(A4),  .A1(A5),  .A2(A6),  .A3(A7),
    .V(v1),   .Q1(q1_1), .Q0(q1_0)
  );

  prio_enc4 encoder2 (
    .A0(A8),  .A1(A9),  .A2(A10), .A3(A11),
    .V(v2),   .Q1(q2_1), .Q0(q2_0)
  );

  prio_enc4 encoder3 (
    .A0(A12), .A1(A13), .A2(A14), .A3(A15),
    .V(v3),   .Q1(q3_1), .Q0(q3_0)
  );

  // -------------------------------
  // Encode which group is valid
  // (v3 highest priority … v0 lowest)
  // -------------------------------
  prio_enc4 encoder4 (
    .A0(v0), .A1(v1), .A2(v2), .A3(v3),
    .V(V),   .Q1(s1), .Q0(s0)
  );

  // Upper bits are the group select
  assign Q3 = s1;
  assign Q2 = s0;

  // -------------------------------
  // Select the in-group 2-bit index
  // -------------------------------
  mux4 mux_Q1 (
    .X0(q0_1), .X1(q1_1), .X2(q2_1), .X3(q3_1),
    .S1(s1), .S0(s0), .Q(Q1)
  );

  mux4 mux_Q0 (
    .X0(q0_0), .X1(q1_0), .X2(q2_0), .X3(q3_0),
    .S1(s1), .S0(s0), .Q(Q0)
  );

endmodule


