
module tx_rx (
    output logic rx_finish,    
    output logic tx_finish,    
    input  logic clk,          
    input  logic rst_n         
);

    // Internal signals
    logic tx_data;
    logic tx_valid;
    logic rx_ready;

    // ---------------------------------------------------------
    // TX Block Instantiation
    // ---------------------------------------------------------
    tx u_tx (
        .clk(clk),
        .rst_n(rst_n),
        .rx_ready(rx_ready),
        .tx_data(tx_data),
        .tx_valid(tx_valid),
        .tx_finish(tx_finish)
    );

    // ---------------------------------------------------------
    // RX Block Instantiation
    // ---------------------------------------------------------
    rx u_rx (
        .clk(clk),
        .rst_n(rst_n),
        .tx_data(tx_data),
        .tx_valid(tx_valid),
        .rx_ready(rx_ready),
        .rx_finish(rx_finish)
    );

endmodule

