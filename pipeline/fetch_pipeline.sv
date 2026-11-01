`timescale 1ns / 1ps
module fetch_pipeline (
    input  logic        clk,
    input  logic        rst,
    input  logic        en,            //~stall
    input  logic        flush,         //PCSrc
    input  logic [31:0] instr_code,
    input  logic [31:0] c_pc,
    output logic [31:0] instr_code_f,
    output logic [31:0] c_pc_f
);

    always_ff @(posedge clk) begin
        if (rst || flush) begin
            instr_code_f <= '0;
            c_pc_f       <= '0;
        end else if (en) begin
            instr_code_f <= instr_code;
            c_pc_f       <= c_pc;
        end
    end


endmodule
