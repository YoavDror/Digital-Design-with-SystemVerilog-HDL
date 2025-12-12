
module rx (
    output logic       rx_ready,
    output logic       rx_finish,

    input  logic       clk,
    input  logic       rst_n,
    input  logic       tx_valid,
    input  logic       tx_data
);

    // ---------------------------------------------------------
    // Internal wires
    // ---------------------------------------------------------
    logic        write, inc;
    logic [1:0]  addr;
    logic [7:0]  data_out;
    logic        shift;

    // ---------------------------------------------------------
    // Shift Register
    // ---------------------------------------------------------
    logic [7:0] shr_reg;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            shr_reg <= 8'd0;
        else if (shift)
            shr_reg <= {tx_data, shr_reg[7:1]};
    end

    // ---------------------------------------------------------
    // Address Register (2-bit)
    // ---------------------------------------------------------
    logic [1:0] addr_reg;
    assign addr = addr_reg;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            addr_reg <= 2'd0;
        else if (inc)
            addr_reg <= addr_reg + 2'd1;
    end

    // ---------------------------------------------------------
    // Instantiate RX FSM
    // ---------------------------------------------------------
    rx_sm rx_sm_inst (
        .clk(clk),
        .rst_n(rst_n),
        .tx_valid(tx_valid),
        .addr(addr),
        .rx_ready(rx_ready),
        .shift(shift),
        .inc(inc),
        .rx_finish(rx_finish),
        .write(write)
    );

    // ---------------------------------------------------------
    // Instantiate RAM
    // ---------------------------------------------------------
    rx_ram #(
        .DATA_WIDTH(8), .ADDR_WIDTH(2)) ram_inst (
        .clk(clk),
        .we(write),
        .addr(addr),
        .data(shr_reg), 
        .q(data_out)
    );

endmodule


