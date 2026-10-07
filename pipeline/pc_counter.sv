
module pc_counter (
    input         clk,
    input         rst,
    input         branch,
    input         btaken,
    input         jal_sel,
    input         jarl_sel,
    input  [31:0] imm,
    input  [31:0] rs1,
    // output [31:0] alu_rd,
    output [31:0] o_auipc,
    output [31:0] current_pc,
    output [31:0] pc_alu_out
);
    logic [31:0] alu_pc_next, alu_pc_result, mux_jarl_out;
    logic or_jal;
    assign or_jal = jal_sel | (btaken & branch);
    assign pc_alu_out = alu_pc_next;

    mux_2x1 u_mux_jarl (
        .mux_sel(jarl_sel),
        .in_0(current_pc),
        .in_1(rs1),
        .mux_out(mux_jarl_out)
    );

    alu u_AUIPC (
        .alu_control(4'b0000),
        .a(imm),
        .b(mux_jarl_out),
        .alu_result(o_auipc)
    );

    // //rd를 위한 alu. pc 영향x. pc 계산 로직은 b u j 타입 모두 동일
    // alu u_rd_alu(
    //     .alu_control(4'b0000),
    //     .a(32'd4),
    //     .b(o_auipc),
    //     .alu_result(alu_rd)
    // );

    alu u_pc_alu (
        .alu_control(4'b0000),
        .a(32'd4),
        .b(current_pc),
        .alu_result(alu_pc_next)
    );

    mux_2x1 u_mux_pc (
        .mux_sel(or_jal),
        .in_0(alu_pc_next),
        .in_1(o_auipc),
        .mux_out(alu_pc_result)
    );

    reigster_pc u_register (
        .clk(clk),
        .rst(rst),
        .data_in(alu_pc_result),
        .data_out(current_pc)
    );
endmodule
