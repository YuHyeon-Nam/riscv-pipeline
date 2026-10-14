`timescale 1ns / 1ps
`include "define.vh"

module control_unit (
    input logic [6:0] opcode,
    input logic [2:0] funct3,

    output logic       branch,
    output logic [2:0] wb_sel,
    output logic       aui,
    output logic       MemRead,
    output logic       MemtoReg,
    output logic       MemWrite,  // data memory
    output logic       ALUSrc,
    output logic       RegWrite,

    output logic       jal_sel,
    output logic       jarl_sel,
    //delete
    output logic [3:0] mem_size,
    output logic       load_un
);
  //opcode 0x33
  always_comb begin
    RegWrite = 1'b0;
    MemWrite = 1'b0;
    branch   = 1'b0;
    ALUSrc   = 1'b0;
    wb_sel   = 3'b000;
    jal_sel  = 1'b0;
    jarl_sel = 1'b0;
    mem_size = 4'b0000;
    load_un  = 1'b0;
    aui      = 1'b0;
    case (opcode)
      `OP_R: begin
        RegWrite = 1'b1;
        // R type, funct7[5], funct3 
        wb_sel   = 3'b000;
      end

      `OP_I: begin
        RegWrite = 1'b1;
        MemWrite = 1'b0;
        ALUSrc   = 1'b1;
        wb_sel   = 3'b000;
      end

      `OP_B: begin
        RegWrite = 1'b0;
        branch   = 1'b1;
        MemWrite = 1'b0;
        ALUSrc   = 1'b0;  // rs1과 rs2 를 alu에서 비교하므로.
        wb_sel   = 3'b000;
      end
      `OP_S: begin
        RegWrite = 1'b0;
        MemWrite = 1'b1;
        ALUSrc   = 1'b1;
        branch   = 1'b0;
        wb_sel   = 3'b000;  //don't care
        jal_sel  = 1'b0;
        jarl_sel = 1'b0;
        case (funct3)
          `SW:     mem_size = 4'b1111;
          `SH:     mem_size = 4'b0011;
          `SB:     mem_size = 4'b0001;
          default: mem_size = 4'b0000;
        endcase
      end
      `OP_I_LOAD: begin
        RegWrite = 1'b1;
        MemWrite = 1'b0;
        ALUSrc   = 1'b1;
        wb_sel   = 3'b001;
      end

      //LUI
      `OP_UL: begin  //imm to write to reg_file
        RegWrite = 1'b1;
        branch   = 1'b0;
        MemWrite = 1'b0;
        ALUSrc   = 1'b1;
        wb_sel   = 3'b010;
        load_un  = funct3[3];
        case (funct3)
          `LW:       mem_size = 4'b1111;
          `LH, `LHU: mem_size = 4'b0011;
          `LB, `LBU: mem_size = 4'b0001;
          default:   mem_size = 4'b0000;
        endcase
      end

      //AUI
      `OP_UA: begin  //imm to write to reg_file
        RegWrite = 1'b1;
        branch   = 1'b0;
        MemWrite = 1'b0;
        ALUSrc   = 1'b1;
        wb_sel   = 3'b000;
        aui      = 1'b1;

      end
      `OP_JAL: begin
        RegWrite = 1'b1;
        branch   = 1'b0;
        MemWrite = 1'b0;
        ALUSrc   = 1'b1;
        wb_sel   = 3'b011;
        jal_sel  = 1'b1;
        jarl_sel = 1'b0;
      end

      `OP_JR: begin
        RegWrite = 1'b1;
        branch   = 1'b0;
        MemWrite = 1'b0;
        ALUSrc   = 1'b1;
        wb_sel   = 3'b011;
        jal_sel  = 1'b0;
        jarl_sel = 1'b1;
      end
    endcase
  end
endmodule
