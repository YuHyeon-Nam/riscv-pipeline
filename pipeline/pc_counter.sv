
module pc_counter (
    input         clk,
    input         rst,
    // input         branch,
    input         btaken,
    input         jal_sel,
    input         jarl_sel,
    // output [31:0] alu_rd,
    output [31:0] current_pc,
    output [31:0] pc_alu_out
);
    logic [31:0] alu_pc_next, alu_pc_result, mux_jarl_out;
    logic or_jal;
    assign or_jal = jal_sel | btaken;
    assign pc_alu_out = alu_pc_next;

    mux_2x1 u_mux_jarl (
        .mux_sel(jarl_sel),
        .in_0(current_pc),
        .in_1(rs1),
        .mux_out(mux_jarl_out)
    );

endmodule
