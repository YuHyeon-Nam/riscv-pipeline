<<<<<<< HEAD
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
=======
`timescale 1ns / 1ps
`include "define.vh"

module control_unit (
    input        [31:0] instr_code,
    output logic        reg_file_we,
    output logic        alu_src_sel,
    output logic [ 2:0] reg_w_src_sel,
    output logic [ 3:0] alu_control,
    output logic        d_wr,           // data memory
    output logic        branch,
    output logic        jal_sel,
    output logic        jarl_sel,
    output logic [ 3:0] st_size,
    output logic        load_u
);

    logic [ 6:0] funct7;
    logic [ 2:0] funct3;
    logic [ 6:0] opcode;
    logic [11:0] imm;

    assign funct7 = instr_code[31:25];
    assign funct3 = instr_code[14:12];
    assign opcode = instr_code[6:0];

    //for i-type
    assign imm = instr_code[31:20];

    //opcode 0x33
    always_comb begin
        reg_file_we   = 1'b0;
        d_wr          = 1'b0;
        branch        = 1'b0;
        alu_src_sel   = 1'b0;
        alu_control   = `ADD;  //default
        reg_w_src_sel = 3'b000;
        jal_sel       = 1'b0;
        jarl_sel      = 1'b0;
        st_size       = 4'b0000;
        load_u        = 1'b0;
        case (opcode)
            `OP_R: begin
                reg_file_we   = 1'b1;
                d_wr          = 1'b0;
                alu_src_sel   = 1'b0;
                // R type, funct7[5], funct3 
                reg_w_src_sel = 3'b000;
                alu_control   = {funct7[5], funct3};
            end

            `OP_I: begin
                reg_file_we = 1'b1;
                d_wr        = 1'b0;
                alu_src_sel = 1'b1;
                case (funct3)
                    `SRLI, `SRAI, `SLLI: alu_control = {imm[10], funct3};
                    default: alu_control = {1'b0, funct3};
                endcase
                reg_w_src_sel = 3'b000;
            end
            `OP_B: begin
                reg_file_we   = 1'b0;
                branch        = 1'b1;
                d_wr          = 1'b0;
                alu_src_sel   = 1'b0;  // rs1과 rs2 를 alu에서 비교하므로.
                alu_control   = {1'b0, funct3};  // 4bit 맞춰주기 위해 0을 넣었다.
                reg_w_src_sel = 3'b000;
            end
            `OP_S: begin
                reg_file_we   = 1'b0;
                d_wr          = 1'b1;
                alu_src_sel   = 1'b1;
                branch        = 1'b0;
                reg_w_src_sel = 3'b000;  //don't care
                alu_control   = `ADD;
                jal_sel       = 1'b0;
                jarl_sel      = 1'b0;
                case (funct3)
                    `SW: st_size = 4'b1111;
                    `SH: st_size = 4'b0011;
                    `SB: st_size = 4'b0001;
                    default: st_size = 4'b0000;
                endcase
            end
            `OP_I_LOAD: begin
                reg_file_we   = 1'b1;
                d_wr          = 1'b0;
                alu_src_sel   = 1'b1;
                alu_control   = `ADD;  //주소
                reg_w_src_sel = 3'b001;
                case (funct3)
                    `LW: st_size = 4'b1111;
                    `LH: begin
                        load_u  = 1'b0;
                        st_size = 4'b0011;
                    end
                    `LB: begin
                        load_u  = 1'b0;
                        st_size = 4'b0001;
                    end
                    `LHU: begin
                        load_u  = 1'b1;
                        st_size = 4'b0011;
                    end
                    `LBU: begin
                        load_u  = 1'b1;
                        st_size = 4'b0001;
                    end
                    default: st_size = 4'b0000;
                endcase
            end
            `OP_UL: begin  //imm to write to reg_file
                reg_file_we   = 1'b1;
                branch        = 1'b0;
                d_wr          = 1'b0;
                alu_src_sel   = 1'b0;
                alu_control   = {4'b0000};  //dont care
                reg_w_src_sel = 3'b010;
            end
            `OP_UA: begin  //imm to write to reg_file
                reg_file_we   = 1'b1;
                branch        = 1'b0;
                d_wr          = 1'b0;
                alu_src_sel   = 1'b0;
                alu_control   = {4'b0000};  //dont care
                reg_w_src_sel = 3'b011;
            end
            `OP_JAL: begin
                reg_file_we   = 1'b1;
                branch        = 1'b0;
                d_wr          = 1'b0;
                alu_src_sel   = 1'b0;
                alu_control   = {4'b0000};  //dont care
                reg_w_src_sel = 3'b100;
                jal_sel       = 1'b1;
                jarl_sel      = 1'b0;
            end
            `OP_JR: begin
                reg_file_we   = 1'b1;
                branch        = 1'b0;
                d_wr          = 1'b0;
                alu_src_sel   = 1'b0;
                alu_control   = {4'b0000};
                reg_w_src_sel = 3'b100;
                jal_sel       = 1'b1;
                jarl_sel      = 1'b1;
            end
        endcase
    end
endmodule
>>>>>>> 4c3220865adb570c56a031b532a319ec6d607256
