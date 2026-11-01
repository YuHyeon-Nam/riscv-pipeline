`timescale 1ns / 1ps
module fetch (
    input  logic        clk,
    input  logic        rst,
    input  logic        PCSrc,
    input  logic [31:0] pc_target,
    input  logic        en,
    output logic [31:0] c_pc
);
    logic [31:0] alu_pc_next;
    logic [31:0] alu_pc_result;
    logic [31:0] next_pc;

    assign next_pc = PCSrc ? pc_target : c_pc + 32'd4;

    reigster_pc u_register (
        .clk(clk),
        .rst(rst),
        .en(en),
        .data_in(next_pc),  //in_pc
        .data_out(c_pc)
    );

    //   mux_2x1 u_mux_pc (
    //       .mux_sel(sel_j_b),
    //       .in_0(alu_pc),
    //       .in_1(),  //mux_jarl_out <- jal or jalr 일단 생략. 
    //       .mux_out(alu_pc_result)
    //   );

endmodule
