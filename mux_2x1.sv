module mux_2x1 (
    input         mux_sel,
    input  [31:0] in_0,
    input  [31:0] in_1,
    output [31:0] mux_out
);

    assign mux_out = mux_sel ? in_1 : in_0;

endmodule
