module execute (
    input         clk,
    input         rst,
    input         ALUSrc,
    input         branch,
    input         jarl_sel,
    input         jal_sel,
    input  [ 2:0] reg_w_src_sel,
    input  [ 3:0] ctl_alu,
    input  [31:0] instr_code,
    output [31:0] mem_addr,       //RAM address
    output [31:0] mem_wdata       //RAM write data
);
    logic [31:0] imm;
    logic [31:0] o_alu;
    logic [31:0] op_b, mem_alu_result;
    logic [31:0] pc_aui;
    logic [31:0] imm_u;
    logic [31:0] pc_branch;
    logic [31:0] o_imm;
    logic btaken;

    assign mem_addr = o_alu;
    assign mem_wdata = rdata2;
    assign imm_u = imm << 12;

    alu_control u_alu_control(
        .opcode,
        .alu_control,
        .ctl_alu
    );

    alu u_alu (
        .ctl_alu   (ctl_alu),
        .a         (op_a),
        .b         (op_b),
        .alu_result(o_alu)
    );

    mux_2x1 u_operand_a (
        .mux_sel(jal_sel | jarl_sel),  //pre decided
        .in_0(rdata1),
        .in_1(current_pc),
        .mux_out(op_a)
    );

    mux_2x1 u_imm_imm12 (
        .mux_sel(),  //not decided
        .in_0(imm),
        .in_1(imm_u),
        .mux_out(o_imm)
    );

    branch u_branch (
        .clt_b(funct3),  //funct3
        .branch(branch),
        .a(rdata1),
        .b(op_b),
        .btaken(btaken)
    );

    //u_operand_b쪽에 통합할 수 있을 것 같음.
    mux_2x1 u_pc_mux (
        .mux_sel(branch & btaken),
        .in_0(rdata2),
        .in_1(imm),
        .mux_out(op_b)
    );

    mux_2x1 u_operand_b (
        .mux_sel(ALUSrc),
        .in_0(rdata2),
        .in_1(o_imm),
        .mux_out(op_b)
    );

    // extend_imm u_extend_imm (
    //     .instr_code(instr_code),
    //     .o_imm(imm)
    // );

    // mux_2x1 u_ex (
    //     .mux_sel(reg_w_src_sel),
    //     .in_0   (o_alu),
    //     .in_1   (imm),
    //     .in_2   (pc_aui),
    //     .in_3   (pc_branch),
    //     .mux_out(mem_alu_result)
    // );

    // mux_4x1 u_mux_mem_alu (
    //     .mux_sel(reg_w_src_sel),
    //     .in_0   (o_alu),     //from alu
    //     .in_1   (d_rdata),        //from data mem
    //     .in_2   (imm),            //LUI
    //     .in_3   (pc_aui),         //AUIPC from pc
    //     .in_4   (pc_branch),
    //     .mux_out(mem_alu_result)  //to reg file
    // );


endmodule
