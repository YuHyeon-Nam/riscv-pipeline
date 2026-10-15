module execute (
    input  logic        clk,
    input  logic        rst,
    input  logic        RegWrite,
    input  logic        ALUSrc,
    input  logic        branch,
    input  logic        op_sel,
    input  logic [31:0] instr_code,
    input  logic [31:0] rdata1,
    input  logic [31:0] rdata2,
    input  logic [31:0] imm,
    output logic        PCSrc,
    output logic [31:0] o_alu,
    output logic [31:0] mem_wdata,
    output logic [31:0] op_pc
);
    logic [31:0] op_b, mem_alu_result;
    logic [31:0] pc_aui;
    logic [31:0] pc_branch;
    logic [3:0] ctl_alu;
    logic btaken;

    assign mem_wdata = rdata2;
    assign PCSrc = btaken & branch;

    alu_control u_alucontrol (
        .opcode(instr_code[6:0]),
        .alu_control({instr_code[30], instr_code[14:12]}),
        .ctl_alu(ctl_alu)
    );
    alu u_alu (
        .ctl_alu   (ctl_alu),
        .a         (op_a),
        .b         (op_b),
        .alu_result(o_alu)
    );

    mux_2x1 u_operand_a (
        .mux_sel(op_sel),  //jal, aui
        .in_0(rdata1),
        .in_1(current_pc),
        .mux_out(op_a)
    );

    mux_2x1 u_operand_b (
        .mux_sel(ALUSrc),
        .in_0(rdata2),
        .in_1(imm),
        .mux_out(op_b)
    );

    branch u_branch (
        .clt_b(funct3),  //funct3
        .a(rdata1),
        .b(rdata2),
        .btaken(btaken)
    );

    adder u_adder (
        .a(current_pc),
        .b(32'd4),
        .c(op_pc)
    );
endmodule