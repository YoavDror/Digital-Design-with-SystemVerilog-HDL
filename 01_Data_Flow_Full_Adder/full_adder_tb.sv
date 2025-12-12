module full_adder_tb;

  logic a, b, cin;
  logic sum, cout;

  // DUT instantiation
  full_adder_dataflow dut (
    .a   (a),
    .b   (b),
    .cin (cin),
    .sum (sum),
    .cout(cout)
  );

  initial begin
    $display(" a b cin | sum cout ");
    $display("---------+----------");

    // Apply all input combinations
    for (int i = 0; i < 8; i++) begin
      {a, b, cin} = i[2:0];
      #1;
      $display(" %b %b  %b  |  %b    %b", a, b, cin, sum, cout);
    end

    $finish;
  end

endmodule
