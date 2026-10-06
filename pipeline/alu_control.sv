`timescale 1ns / 1ps
`include "define.vh"

module alu_control (
    input logic [1:0] ALUOp,  //opcode [6:0]
    input logic [2:0] funct3,  //inst[14:12]
    input logic funct7,  //inst[30]
    output logic [3:0] ctl_alu
);
    localparam R = 2'b10;
    localparam LS = 2'b00;
    localparam BEQ = 2'b01;
    localparam I = 2'b11;

    logic [3:0] instr_type;
    assign instr_type = {funct7, funct3};

    always_comb begin
        case (ALUOp)
            R,I: ctl_alu = {1'b0, funct3};
            LS: ctl_alu = `ADD;
            BEQ: ctl_alu = {1'b1,funct3};
            //I type 4th bit : don't care
            // I : ctl_alu = {funct3==3'b101} ? {funct7,funct3} : {1'b0, funct3};
        endcase
    end

endmodule
