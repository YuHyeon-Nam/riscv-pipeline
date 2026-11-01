`timescale 1ns / 1ps
`include "define.vh"

module extend_imm (
    input [31:0] instr_code,
    output logic [31:0] o_imm
);
    logic [4:0] shamt;
    logic [6:0] opcode;
    assign shamt  = instr_code[24:20];
    assign opcode = instr_code[6:0];
    always_comb begin
        case (opcode)
            `OP_S: begin
                // 20bit sign extends
                o_imm = {{20{instr_code[31]}}, instr_code[31:25], instr_code[11:7]};  //zero extends. data 12bits
            end
            `OP_I, `OP_I_LOAD: begin
                o_imm = {{20{instr_code[31]}}, instr_code[31:20]};
                //ALU 에서 어차피 5bit 슬라이싱하므로 구분 의미없음.
            end
            `OP_B: begin
                // 19bit sign extends by instr_code[31] + imm[12]+imm[11]+imm[10:5]+imm[4:1]+1'b0
                o_imm = {
                    {19{instr_code[31]}}, instr_code[31], instr_code[7], instr_code[30:25], instr_code[11:8], 1'b0
                };
            end
            `OP_UL, `OP_UA: begin
                o_imm = {{instr_code[31:12]}, {12{1'b0}}};
            end
            `OP_JAL: begin
                o_imm = {{12{instr_code[31]}}, instr_code[19:12], instr_code[20], instr_code[30:21], 1'b0};
            end
            `OP_JR: begin
                //    o_imm = {{12{instr_code[31]}}, {instr_code[31:20]}};
                o_imm = {{20{instr_code[31]}}, instr_code[31:20]};
            end
            `OP_S: begin
                o_imm = {{20{instr_code[31]}}, {instr_code[31:25]}, {instr_code[11:7]}};
            end
            default: begin
                o_imm = '0;
            end
        endcase
    end
endmodule
