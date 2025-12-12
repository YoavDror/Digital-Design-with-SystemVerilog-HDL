module tx (
    output logic       tx_data,
    output logic       tx_valid,
    output logic       tx_finish,

    input  logic       clk,
    input  logic       rst_n,
    input  logic       rx_ready
);

    // ---------------------------------------------------------
    // Internal Signals
    // ---------------------------------------------------------
    logic       read;
    logic       inc;
    logic       load;
    logic       shift;

    logic [1:0] addr;
    logic [7:0] data;

    // ---------------------------------------------------------
    // Shift Register (8-bit)
    // ---------------------------------------------------------
    logic [7:0] shr_reg;

    assign tx_data = shr_reg[0];  // Transmit LSB first

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            shr_reg <= 8'd0;
        else if (load)
            shr_reg <= data;
        else if (shift)
            shr_reg <= {1'b0, shr_reg[7:1]};  
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
    // Instantiate TX State Machine
    // ---------------------------------------------------------
    tx_sm tx_sm_inst (
        .clk(clk),
        .rst_n(rst_n),
        .rx_ready(rx_ready),
        .addr(addr),
        .tx_valid(tx_valid),
        .shift(shift),
        .load(load),
        .read(read),
        .inc(inc),
        .tx_finish(tx_finish)
    );

    // ---------------------------------------------------------
    // Instantiate TX ROM
    // ---------------------------------------------------------
    tx_rom #(.DATA_WIDTH(8),.ADDR_WIDTH(2)) rom_inst (
        .clk(clk),
        .read(read),
        .addr(addr),
        .q(data)
    );

endmodule

