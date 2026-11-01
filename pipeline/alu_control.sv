`timescale 1ns / 1ps
`include "define.vh"

module alu_control (
    input  logic [6:0] opcode,
    input  logic [3:0] alu_control,
    output logic [3:0] ctl_alu
);

  always_comb begin
    case (opcode)
      `OP_R:
        ctl_alu = alu_control;
      `OP_I: ctl_alu = (alu_control[2:0]==3'b101) ? alu_control : {1'b0,alu_control[2:0]};
  default : ctl_alu = `ADD;
    endcase
  end

endmodule
