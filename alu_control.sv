`timescale 1ns / 1ps
`include "define.vh"

module alu_control (
    input logic  [3:0] ALUOp, //opcode [6:0]
    input logic  [2:0] funct3, //inst[14:12]
    input logic  [6:0] funct7, //inst[30]
    output logic 
);

    always_comb begin
        case (alu_control)
            //R-type
            `ADD: begin
                alu_result = a + b;
            end
            `SUB: begin
                alu_result = a - b;
            end
            `SLL: begin
                alu_result = a << shamt;  //산술 : 2의 n승으로 곱하는 효과
            end
            `SLT: begin  //SIGNED
                alu_result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;  //기본적으로 unsigned로 
            end
            `SLTU: begin  //UNSIGNED
                alu_result = ($unsigned(a) < $unsigned(b)) ? 32'd1 : 32'd0;
                  //zero-extends
            end
            `XOR: begin
                alu_result = a ^ b;
            end
            `SRL: begin
                alu_result = a >> shamt;
            end
            `SRA: begin
                // >> 는 논리 쉬프트 (0채움)
                // 산술 쉬프트 (부호 확장) 
                // >>>를 써도, 왼쪽 피연산자가 signed여야 msb가 확장
                alu_result = $signed(a) >>> shamt;  //msb extends
            end
            `OR: begin
                alu_result = a | b;
            end
            `AND: begin
                alu_result = a & b;
            end
        endcase
    end

endmodule
