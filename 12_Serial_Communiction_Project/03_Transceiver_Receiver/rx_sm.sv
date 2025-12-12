
module rx_sm (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       tx_valid,
    input  logic [1:0] addr,

    output logic       rx_ready,
    output logic       shift,       
    output logic       inc,
    output logic       rx_finish,
    output logic       write
);

    // FSM state
    typedef enum logic [2:0] {
        IDLE,
        SHR,
        WRITE_MEM,
        INC_ADDR,
        RX_FINISH
    } rx_state_e;

    rx_state_e state, next_state;

    // Internal counter: 0 to 7
    logic [2:0] counter;

    // --------------------------------------
    // Combinational constraint for shift
    // --------------------------------------
    assign shift = tx_valid;

    // --------------------------------------
    // State Register
    // --------------------------------------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // --------------------------------------
    // Counter Logic
    // --------------------------------------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 3'd0;
        else if (state == SHR)
            counter <= counter + 3'd1;
        else if (state == WRITE_MEM)
            counter <= 3'd0; 
    end

    // --------------------------------------
    // Next State Logic
    // --------------------------------------
    always_comb begin
        case (state)
            IDLE: begin
                if (tx_valid)
                    next_state = SHR;
                else
                    next_state = IDLE;
            end

            SHR: begin
                if (tx_valid && counter < 3'd6)
                    next_state = SHR;
                else if (tx_valid && counter == 3'd6)
                    next_state = WRITE_MEM;
                else
                    next_state = IDLE; 
            end

            WRITE_MEM: next_state = INC_ADDR;

            INC_ADDR: begin
                if (addr == 2'b11)
                    next_state = RX_FINISH;
                else
                    next_state = IDLE;
            end

        endcase
    end

    // --------------------------------------
    // Output Logic (Moore-style)
    // --------------------------------------
    always_comb begin
        // Default all outputs to 0
        rx_ready  = 1'b0;
        inc       = 1'b0;
        rx_finish = 1'b0;
        write     = 1'b0;

        case (state)
            IDLE:       rx_ready  = 1'b1;
            WRITE_MEM:  write     = 1'b1;
            INC_ADDR:   inc       = 1'b1;
            RX_FINISH:  rx_finish = 1'b1;
        endcase
    end

endmodule

