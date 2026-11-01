`timescale 1ns / 1ps
module RV32_CORE (
    input  logic       clk,
    input  logic       rst
    // output logic [7:0] led
);
    logic [31:0] instr_code;
    logic [31:0] instr_raddr;

    instruction_memory u_instruction_memory (
        .instr_raddr(instr_raddr),
        .instr_code (instr_code)
    );

    datapath_pipeline u_datapath_pipeline (
        .clk(clk),
        .rst(rst),
        .instr_code(instr_code),
        .instr_raddr(instr_raddr)
    );

endmodule
