`timescale 1ns / 1ps

module RV32I_TOP (
    input clk,
    input rst,
    output [7:0] led
);
    logic [31:0] instr_code, instr_raddr, d_wdata, d_rdata;
    logic [31:0] d_addr;
    logic [3:0] st_size;
    logic d_wr,load_u;

    instruction_memory u_instruction_memory(.*);
    RV32I_CORE u_RV32I_CORE(.*);
    DATA_MEMORY u_data_mem(.*);
    assign led = d_rdata[7:0];
endmodule

module RV32I_CORE(
    input clk,
    input rst,
    input [31:0] instr_code,
    input [31:0] d_rdata,
    output [31:0] instr_raddr,
    output d_wr,
    output [31:0] d_addr,
    output [31:0] d_wdata,
    output [3:0] st_size,
    output load_u
    );

    logic we;
    logic alu_src_sel,jal_sel,jarl_sel;
    logic [2:0] reg_w_src_sel;
    logic [3:0] alu_control;
    logic branch;

    datapath u_datapath (
        .clk(clk),
        .rst(rst),
        .branch(branch),
        .reg_file_we(we),
        .alu_control(alu_control),
        .instr_code(instr_code),  
        .instr_raddr(instr_raddr),
        .d_rdata(d_rdata),
        .alu_src_sel(alu_src_sel),
        .jal_sel(jal_sel),
        .jarl_sel(jarl_sel),
        .reg_w_src_sel(reg_w_src_sel),
        .d_addr(d_addr),
        .d_wdata(d_wdata)
    );

    control_unit u_control_unit(
        .instr_code(instr_code),
        .reg_file_we(we),
        .alu_src_sel(alu_src_sel),
        .reg_w_src_sel(reg_w_src_sel),
        .alu_control(alu_control),
        .d_wr(d_wr),
        .branch(branch),
        .jarl_sel(jarl_sel),
        .jal_sel(jal_sel),
        .st_size(st_size),
        .load_u(load_u)
    );
endmodule
