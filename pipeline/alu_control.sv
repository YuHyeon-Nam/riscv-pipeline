`timescale 1ns / 1ps
`include "define.vh"

module alu_control (
    input  logic [6:0] opcode,
    input  logic [3:0] alu_control,
    output logic [3:0] ctl_alu
);

  always_comb begin
    case (opcode)
      `OP_R: begin
        if (alu_control == `ADD) ctl_alu = 4'b0000;
        else if (alu_control == `SUB) ctl_alu = 4'b0001;
        else if (alu_control == `SLL) ctl_alu = 4'b0010;
        else if (alu_control == `SRL) ctl_alu = 4'b0011;
        else if (alu_control == `SRA) ctl_alu = 4'b0100;
        else if (alu_control == `SLT) ctl_alu = 4'b0101;
        else if (alu_control == `SLTU) ctl_alu = 4'b0110;
        else if (alu_control == `XOR) ctl_alu = 4'b0111;
        else if (alu_control == `OR) ctl_alu = 4'b1000;
        else if (alu_control == `AND) ctl_alu = 4'b1001;
      end
      `OP_I: begin
        if (alu_control == `ADDI) ctl_alu = 4'b0000;
        else if (alu_control == `SLLI) ctl_alu = 4'b0010;
        else if (alu_control == `SRLI) ctl_alu = 4'b0011;
        else if (alu_control == `SRAI) ctl_alu = 4'b0100;
        else if (alu_control == `SLTI) ctl_alu = 4'b0101;
        else if (alu_control == `SLTUI) ctl_alu = 4'b0110;
        else if (alu_control == `XORI) ctl_alu = 4'b0111;
        else if (alu_control == `ORI) ctl_alu = 4'b1000;
        else if (alu_control == `ANDI) ctl_alu = 4'b1001;
      end
      `OP_B: ctl_alu = 4'b0000;
      `OP_S, `OP_I_LOAD: ctl_alu = 4'b0000;
      `OP_JAL: ctl_alu = 4'b0000;
      `OP_JR: ctl_alu = 4'b0000;
      `OP_UA: ctl_alu = 4'b0000;
      `OP_UL: ctl_alu = 4'b1111;
    endcase
  end

endmodule
