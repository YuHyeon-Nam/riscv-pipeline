module execute_pipeline (
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

    
endmodule