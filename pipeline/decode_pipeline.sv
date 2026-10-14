module decode_pipeline (
    input  logic        clk,
    input  logic        rst,
    input logic [31:0] instr_code_f,
    input logic [31:0] c_pc_f,
    input logic [31:0] rdata1,
    input logic [31:0] rdata2,
    input logic [31:0] imm,
    input logic [ 2:0] wb_sel,
    input logic        branch,
    input logic        MemRead,
    input logic        MemtoReg,
    input logic        MemWrite,    // data memory
    input logic        ALUSrc,
    input logic        RegWrite,
    input logic        jal_sel,
    input logic        jarl_sel,
    input logic        aui,
    input logic        mem_size,
    input logic        load_un,
    output logic [31:0] instr_code_d,
    output logic [31:0] c_pc_d,
    output logic [31:0] rdata1_d,
    output logic [31:0] rdata2_d,
    output logic [31:0] imm_d,
    output logic [ 2:0] wb_sel_d,
    output logic        branch_d,
    output logic        MemRead_d,
    output logic        MemtoReg_d,
    output logic        MemWrite_d,    // data memory
    output logic        ALUSrc_d,
    output logic        RegWrite_d,
    output logic        jal_sel_d,
    output logic        jarl_sel_d,
    output logic        aui_d,
    output logic        mem_size_d,
    output logic        load_un_d
);



endmodule
