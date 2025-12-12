
module tx_sm (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       rx_ready,
    input  logic [1:0] addr,

    output logic       tx_valid,
    output logic       shift,
    output logic       load,
    output logic       read,
    output logic       inc,
    output logic       tx_finish
);

    // ---------------------------------------------------------
    // FSM State Declaration
    // ---------------------------------------------------------
    typedef enum logic [2:0] {
        IDLE,
        RX_READY,
        LD_REG,
        SHR,
        INC_ADDR,
        TX_FINISH
    } tx_state_e;

    tx_state_e state, next_state;

    // ---------------------------------------------------------
    // Internal Shift Counter (0 to 7)
    // ---------------------------------------------------------
    logic [2:0] counter;

    // ---------------------------------------------------------
    // State Register
    // ---------------------------------------------------------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // ---------------------------------------------------------
    // Counter Logic
    // ---------------------------------------------------------
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 3'd0;
        end
        else if (state == LD_REG) begin
            counter <= 3'd0;
        end
        else if (state == SHR) begin
            counter <= counter + 3'd1;
        end
    end

    // ---------------------------------------------------------
    // Next State Logic
    // ---------------------------------------------------------
    always_comb begin
        case (state)
            IDLE: begin
                if (rx_ready)
                    next_state = RX_READY;
                else
                    next_state = IDLE;
            end

            RX_READY: next_state = LD_REG;

            LD_REG: next_state = SHR;

            SHR: begin
                if (counter < 3'd7)
                    next_state = SHR;
                else
                    next_state = INC_ADDR;
            end

            INC_ADDR: begin
                if (addr == 2'b11)
                    next_state = TX_FINISH;
                else
                    next_state = IDLE;
            end

        endcase
    end

    // ---------------------------------------------------------
    // Output Logic (Moore FSM)
    // ---------------------------------------------------------
    always_comb begin
        // Default outputs
        tx_valid  = 1'b0;
        shift     = 1'b0;
        load      = 1'b0;
        read      = 1'b0;
        inc       = 1'b0;
        tx_finish = 1'b0;

        case (state)
            RX_READY:  read      = 1'b1;
            LD_REG:    load      = 1'b1;
            SHR: begin
                shift     = 1'b1;
                tx_valid  = 1'b1;
            end
            INC_ADDR: begin
                inc       = 1'b1;
                tx_valid  = 1'b1;
            end
            TX_FINISH: tx_finish = 1'b1;
        endcase
    end

endmodule




