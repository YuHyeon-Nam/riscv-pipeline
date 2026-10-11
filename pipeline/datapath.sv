`timescale 1ns / 1ps
`include "define.vh"

module datapath (
    input         clk,
    input         rst,
    input         RegWrite,
    input         ALUSrc,
    input         branch,
    input         jarl_sel,
    input         jal_sel,
    input  [ 2:0] reg_w_src_sel,
    input  [ 3:0] ctl_alu,
    input  [31:0] instr_code,     // instruction code from ROM
    input  [31:0] d_rdata,
    output [31:0] instr_raddr,    // pc to rom
    output [31:0] d_addr,         //RAM address
    output [31:0] d_wdata         //RAM write data
);
    logic [31:0] alu_result, rdata1, rdata2;
    logic [31:0] imm;
    logic [31:0] alu_src_mux_out, mem_alu_result, o_auipc, pc_alu_out;
    logic btaken;

    assign d_addr  = alu_result[31:0];
    assign d_wdata = rdata2;

    register_file u_register_file (
        // read port 2 write port 1
        .clk(clk),
        .rst(rst),
        .we(RegWrite),
        .r_reg1(instr_code[19:15]),
        .r_reg2(instr_code[24:20]),
        .w_reg(instr_code[11:7]),
        .wdata(mem_alu_result),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );

    mux_2x1 u_alu_src_mux (
        .mux_sel(ALUSrc),
        .in_0(rdata2),
        .in_1(imm),
        .mux_out(alu_src_mux_out)
    );

    alu u_alu (
        .ctl_alu   (ctl_alu),
        .a         (rdata1),
        .b         (alu_src_mux_out),
        .alu_result(alu_result)
    );
    
    alu u_JAL (
        .alu_control(4'b0000),
        .a(imm),
        .b(current_pc),
        .alu_result(o_jalpc)
    );

    alu u_AUIPC (
        .alu_control(4'b0000),
        .a(imm),
        .b(current_pc),
        .alu_result(o_auipc)
    );
    
    branch u_branch (
        .clt_b(funct3),  //funct3
        .branch(branch),
        .a(rdata1),
        .b(alu_src_mux_out),
        .btaken(btaken)
    );

    mux_2x1 u_pc_mux (
        .mux_sel(branch & btaken),
        .in_0(rdata2),
        .in_1(imm),
        .mux_out(alu_src_mux_out)
    );

    extend_imm u_extend_imm (
        .instr_code(instr_code),
        .o_imm(imm)
    );

    mux_4x1 u_mux_mem_alu (
        .mux_sel(reg_w_src_sel),
        .in_0   (alu_result),     //from alu
        .in_1   (d_rdata),        //from data mem
        .in_2   (imm),            //LUI
        .in_3   (o_auipc),        //AUIPC from pc
        .in_4   (pc_alu_out),
        .mux_out(mem_alu_result)  //to reg file
    );


endmodule

