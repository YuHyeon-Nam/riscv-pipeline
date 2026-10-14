
module mux_4x1 (
    input        [ 2:0] mux_sel,
    input        [31:0] in_0,
    input        [31:0] in_1,
    input        [31:0] in_2,
    input        [31:0] in_3,
    input        [31:0] in_4,
    output logic [31:0] mux_out
);
    always @(*) begin
        mux_out = in_0;  // default
        case (mux_sel)
            3'b000: mux_out = in_0;
            3'b001: mux_out = in_1;
            3'b010: mux_out = in_2;
            3'b011: mux_out = in_3;
            3'b100: mux_out = in_4;
        endcase
    end

endmodule