`timescale 1ns / 1ps
module execute_pipeline (
    input logic        clk,
    input logic        rst,
    input logic        RegWrite_d,
    input logic        MemWrite_d,
    input logic        PCSrc_d,
    input logic [31:0] rdata2_d,
    input logic [31:0] o_alu_d,
    input logic [31:0] mem_wdata_d,
    input logic [31:0] op_pc_d,
    input logic [31:0] imm_d,
    input logic [ 3:0] mem_size_d,
    input logic [ 2:0] wb_sel_d,
    input logic        load_un_d,
    input logic [31:0] instr_code_d,

    output logic        RegWrite_e,
    output logic        MemWrite_e,
    output logic        PCSrc_e,
    output logic [31:0] rdata2_e,
    output logic [31:0] o_alu_e,
    output logic [31:0] mem_wdata_e,
    output logic [31:0] op_pc_e,
    output logic [31:0] imm_e,
    output logic [ 3:0] mem_size_e,
    output logic [ 2:0] wb_sel_e,
    output logic        load_un_e,
    output logic [31:0] instr_code_e
);

    always_ff @(posedge clk) begin
        if (rst) begin
            RegWrite_e <= '0;
            MemWrite_e <= '0;
            PCSrc_e <= '0;
            rdata2_e <= '0;
            o_alu_e <= '0;
            mem_wdata_e <= '0;
            op_pc_e <= '0;
            imm_e <= '0;
            mem_size_e <= '0;
            wb_sel_e <= '0;
            load_un_e <= '0;
            instr_code_e <= '0;
        end else begin
            RegWrite_e <= RegWrite_d;
            MemWrite_e <= MemWrite_d;
            PCSrc_e <= PCSrc_d;
            rdata2_e <= rdata2_d;
            o_alu_e <= o_alu_d;
            mem_wdata_e <= mem_wdata_d;
            op_pc_e <= op_pc_d;
            imm_e <= imm_d;
            mem_size_e <= mem_size_d;
            wb_sel_e <= wb_sel_d;
            load_un_e <= load_un_d;
            instr_code_e <= instr_code_d;
        end
    end


endmodule
