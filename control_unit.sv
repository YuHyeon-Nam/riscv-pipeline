`timescale 1ns / 1ps
`include "define.vh"

module control_unit (
    input        [31:0] instr_code,
    output logic        reg_file_we,
    output logic        alu_src_sel,
    output logic [ 2:0] reg_w_src_sel,
    output logic [ 3:0] alu_control,
    output logic [1:0] alu_op,
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
