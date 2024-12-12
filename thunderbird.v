module thunderbird_Left (
    input clk, rst, enable, isLeft,
    output reg [2:0] output_state
);

    // Parameters for state encoding
    parameter Left1 = 3'b000;
    parameter Left2 = 3'b001;
    parameter Left3 = 3'b011;
    parameter Left4 = 3'b111;

    parameter Right1 = 3'b000;
    parameter Right2 = 3'b100;
    parameter Right3 = 3'b110;
    parameter Right4 = 3'b111;

    // State variables
    reg [2:0] state, next_state;

    // State Register
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= (isLeft) ? Left1 : Right1; // Reset based on direction
        else
            state <= next_state;
    end

    // Next State Logic
    always @(*) begin
        case (state)
            (isLeft ? Left1 : Right1): 
                if (enable) next_state = (isLeft ? Left2 : Right2);
                else next_state = (isLeft ? Left1 : Right1);

            (isLeft ? Left2 : Right2): 
                if (enable) next_state = (isLeft ? Left3 : Right3);
                else next_state = (isLeft ? Left1 : Right1);

            (isLeft ? Left3 : Right3): 
                if (enable) next_state = (isLeft ? Left4 : Right4);
                else next_state = (isLeft ? Left1 : Right1);

            (isLeft ? Left4 : Right4): 
                if (enable) next_state = (isLeft ? Left1 : Right1);
                else next_state = (isLeft ? Left1 : Right1);

            default: next_state = (isLeft ? Left1 : Right1);
        endcase
    end

    // Output Logic
    always @(*) begin
        output_state = state;
    end

endmodule
