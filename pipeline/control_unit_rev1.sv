`timescale 1ns / 1ps
`include "define.vh"

module control_unit (
    input logic [6:0] opcode,
    input logic [2:0] funct3,

    output logic       branch,
    output logic [2:0] wb_sel,    //MemtoReg, MemRead
    output logic       aui,
    output logic       MemWrite,  // data memory
    output logic       ALUSrc,
    output logic       RegWrite,

    output logic       jal_sel,
    output logic       jarl_sel,
    //delete
    output logic [3:0] mem_size,
    output logic       load_un
);

  assign RegWrite = (opcode == `OP_R || `OP_I || `OP_I_LOAD || `OP_UL || `OP_UA || `OP_JR || `OP_JAL) ? 1'b1 : 1'b0;
  assign MemWrite = (opcode == `OP_S) ? 1'b1 : 1'b0;
  assign aui = (opcode == `OP_UA) ? 1'b1 : 1'b0;
  assign branch = (opcode == `OP_B) ? 1'b1 : 1'b0;
  assign ALUSrc = (opcode == `OP_I || `OP_I_LOAD || `OP_S || `OP_UL || `OP_UA || `OP_JAL || `OP_JR) ? 1'b1 : 1'b0;
  assign jal_sel = `OP_JAL;
  assign jarl_sel = `OP_JR;
  assign wb_sel = (opcode == (`OP_JAL || `OP_JR)) ? 3'b011 :
                  (opcode == `OP_UL) ? 3'b010 :
                  (opcode == `OP_I_LOAD) ? 3'b001 : 3'b000;

  always_comb begin
    mem_size = 4'b0000;
    load_un  = 1'b0;
    case (opcode)
      `OP_S: begin
        case (funct3)
          `SW:     mem_size = 4'b1111;
          `SH:     mem_size = 4'b0011;
          `SB:     mem_size = 4'b0001;
          default: mem_size = 4'b0000;
        endcase
      end
      `OP_I_LOAD: begin
        load_un = funct3[2];
        case (funct3)
          `LW:       mem_size = 4'b1111;
          `LH, `LHU: mem_size = 4'b0011;
          `LB, `LBU: mem_size = 4'b0001;
          default:   mem_size = 4'b0000;
        endcase
      end
    endcase
  end
endmodule
