`timescale 1ns / 1ps
module datapath_pipeline (
    input logic clk,
    input logic rst,
    input logic [31:0] instr_code,
    output logic [31:0] instr_raddr
);
    logic [31:0] c_pc;
    assign instr_raddr = c_pc;

    //==================================================================
    // Feedback signals
    //==================================================================
    logic [31:0] next_rd;  // WB  -> ID (w_data)
    logic [31:0] pc_target_d;
    logic        PCSrc_d;
    logic        stall;

    //==================================================================
    // IF stage
    //==================================================================
    fetch u_fetch (
        .clk      (clk),
        .rst      (rst),
        .en       (~stall),
        .PCSrc    (PCSrc_d),
        .c_pc     (c_pc),
        .pc_target(pc_target_d)
    );

    //==================================================================
    // IF/ID pipeline register
    //==================================================================
    logic [31:0] instr_code_f;
    logic [31:0] c_pc_f;

    fetch_pipeline u_fetch_pipeline (
        .clk         (clk),
        .rst         (rst),
        .en          (~stall),
        .flush       (PCSrc_d),
        .instr_code  (instr_code),
        .c_pc        (c_pc),
        .instr_code_f(instr_code_f),
        .c_pc_f      (c_pc_f)
    );

    //==================================================================
    // ID stage
    //==================================================================
    logic [31:0] rdata1;
    logic [31:0] rdata2;
    logic [31:0] imm;
    logic [ 2:0] wb_sel;
    logic        aui;
    logic        branch;
    logic        MemRead;
    logic        MemtoReg;
    logic        MemWrite;
    logic        ALUSrc;
    logic        RegWrite;
    logic [ 3:0] mem_size;
    logic        load_un;
    logic        RegWrite_m;
    logic [31:0] instr_code_m;
    logic        jal_sel;
    logic        jarl_sel;

    decode u_decode (
        .clk       (clk),
        .rst       (rst),
        .instr_code(instr_code_f),
        .rd_m      (instr_code_m[11:7]),
        .RegWrite_m(RegWrite_m),
        .w_data    (next_rd),
        .rdata1    (rdata1),
        .rdata2    (rdata2),
        .wb_sel    (wb_sel),
        .aui       (aui),
        .imm       (imm),
        .branch    (branch),
        .MemRead   (MemRead),
        .MemtoReg  (MemtoReg),
        .MemWrite  (MemWrite),
        .ALUSrc    (ALUSrc),
        .RegWrite  (RegWrite),
        .jal_sel   (jal_sel),
        .jarl_sel  (jarl_sel),
        .mem_size  (mem_size),
        .load_un   (load_un)
    );

    //==================================================================
    // ID/EX pipeline register
    //==================================================================
    logic [31:0] c_pc_d;
    logic [31:0] instr_code_d;
    logic [31:0] rdata1_d;
    logic [31:0] rdata2_d;
    logic [31:0] imm_d;
    logic [ 2:0] wb_sel_d;
    logic        branch_d;
    logic        MemRead_d;
    logic        MemtoReg_d;
    logic        MemWrite_d;
    logic        ALUSrc_d;
    logic        RegWrite_d;
    logic        jal_sel_d;
    logic        jarl_sel_d;
    logic        aui_d;
    logic [ 3:0] mem_size_d;
    logic        load_un_d;

    decode_pipeline u_decode_pipeline (
        .clk         (clk),
        .rst         (rst),
        .bubble      (stall||PCSrc_d),
        .c_pc_f      (c_pc_f),
        .instr_code_f(instr_code_f),
        .rdata1      (rdata1),
        .rdata2      (rdata2),
        .imm         (imm),
        .wb_sel      (wb_sel),
        .branch      (branch),
        .MemRead     (MemRead),
        .MemtoReg    (MemtoReg),
        .MemWrite    (MemWrite),
        .ALUSrc      (ALUSrc),
        .RegWrite    (RegWrite),
        .jal_sel     (jal_sel),
        .jarl_sel    (jarl_sel),
        .aui         (aui),
        .mem_size    (mem_size),
        .load_un     (load_un),

        .c_pc_d      (c_pc_d),
        .instr_code_d(instr_code_d),
        .rdata1_d    (rdata1_d),
        .rdata2_d    (rdata2_d),
        .imm_d       (imm_d),
        .wb_sel_d    (wb_sel_d),
        .branch_d    (branch_d),
        .MemRead_d   (MemRead_d),
        .MemtoReg_d  (MemtoReg_d),
        .MemWrite_d  (MemWrite_d),
        .ALUSrc_d    (ALUSrc_d),
        .RegWrite_d  (RegWrite_d),
        .jal_sel_d   (jal_sel_d),
        .jarl_sel_d  (jarl_sel_d),
        .aui_d       (aui_d),
        .mem_size_d  (mem_size_d),
        .load_un_d   (load_un_d)
    );

    hazard_unit u_hazard_unit (
        .MemRead_d(MemRead_d),
        .rd_d(instr_code_d[11:7]),
        .rs1(instr_code_f[19:15]),
        .rs2(instr_code_f[24:20]),
        .stall(stall)
    );

    //==================================================================
    // EX stage
    //==================================================================
    logic        op_sel;
    logic [ 1:0] forward_a;
    logic [ 1:0] forward_b;
    logic [31:0] mem_wdata;
    logic [31:0] o_alu_d;
    logic [31:0] mem_wdata_d;
    logic [31:0] op_pc_d;
    logic [31:0] fwd_e;
    logic [31:0] fwd_rs1_d, fwd_rs2_d;

    assign op_sel = jal_sel_d || aui_d || branch_d;

    always_comb begin
        case (forward_a)
            2'b10:   fwd_rs1_d = fwd_e;
            2'b01:   fwd_rs1_d = next_rd;
            default: fwd_rs1_d = rdata1_d;
        endcase
    end

    always_comb begin
        case (forward_b)
            2'b10:   fwd_rs2_d = fwd_e;
            2'b01:   fwd_rs2_d = next_rd;
            default: fwd_rs2_d = rdata2_d;
        endcase
    end

    execute u_execute (
        .clk       (clk),
        .rst       (rst),
        .RegWrite  (RegWrite_d),
        .ALUSrc    (ALUSrc_d),
        .branch    (branch_d),
        .op_sel    (op_sel),
        .instr_code(instr_code_d),
        .rdata1    (fwd_rs1_d),
        .rdata2    (fwd_rs2_d),
        .imm       (imm_d),
        .c_pc      (c_pc_d),
        .jal_sel   (jal_sel_d),
        .jarl_sel  (jarl_sel_d),
        .PCSrc     (PCSrc_d),
        .o_alu     (o_alu_d),
        .mem_wdata (mem_wdata_d),
        .op_pc     (op_pc_d),
        .pc_target (pc_target_d)
    );

    //==================================================================
    // EX/MEM pipeline register
    //==================================================================

    logic        RegWrite_e;
    logic        MemWrite_e;
    logic        PCSrc_e;
    logic [31:0] rdata2_e;
    logic [31:0] o_alu_e;
    logic [31:0] mem_wdata_e;
    logic [31:0] op_pc_e;
    logic [31:0] imm_e;
    logic [ 3:0] mem_size_e;
    logic [ 2:0] wb_sel_e;
    logic        load_un_e;
    logic [31:0] instr_code_e;

    execute_pipeline u_execute_pipeline (
        .clk         (clk),
        .rst         (rst),
        .RegWrite_d  (RegWrite_d),
        .MemWrite_d  (MemWrite_d),
        .PCSrc_d     (PCSrc_d),
        .rdata2_d    (rdata2_d),
        .o_alu_d     (o_alu_d),
        .mem_wdata_d (mem_wdata_d),
        .op_pc_d     (op_pc_d),
        .imm_d       (imm_d),
        .mem_size_d  (mem_size_d),
        .wb_sel_d    (wb_sel_d),
        .load_un_d   (load_un_d),
        .instr_code_d(instr_code_d),

        .RegWrite_e  (RegWrite_e),
        .MemWrite_e  (MemWrite_e),
        .PCSrc_e     (PCSrc_e),
        .rdata2_e    (rdata2_e),
        .o_alu_e     (o_alu_e),
        .mem_wdata_e (mem_wdata_e),
        .op_pc_e     (op_pc_e),
        .imm_e       (imm_e),
        .mem_size_e  (mem_size_e),
        .wb_sel_e    (wb_sel_e),
        .load_un_e   (load_un_e),
        .instr_code_e(instr_code_e)
    );

    //==================================================================
    // Forwarding unit
    //==================================================================

    // logic for forwarding
    always @(*) begin
        case (wb_sel_e)
            3'b010:  fwd_e = imm_e;
            3'b011:  fwd_e = op_pc_e;
            default: fwd_e = o_alu_e;
        endcase
    end

    forward_unit u_forward_unit (
        .rs1_d     (instr_code_d[19:15]),
        .rs2_d     (instr_code_d[24:20]),
        .rd_e      (instr_code_e[11:7]),
        .RegWrite_e(RegWrite_e),
        .rd_m      (instr_code_m[11:7]),
        .RegWrite_m(RegWrite_m),
        .forward_a (forward_a),
        .forward_b (forward_b)
    );

    //==================================================================
    // MEM stage
    //==================================================================
    logic [31:0] o_rdata;

    mem u_mem (
        .clk     (clk),
        .rst     (rst),
        .MemWrite(MemWrite_e),
        .load_un (load_un_e),
        .w_data  (mem_wdata_e),
        .mem_addr(o_alu_e),
        .mem_size(mem_size_e),
        .o_rdata (o_rdata)
    );

    //==================================================================
    // MEM/WB pipeline register
    //==================================================================
    logic [ 2:0] wb_sel_m;
    logic [31:0] o_alu_m;
    logic [31:0] o_rdata_m;
    logic [31:0] op_pc_m;
    logic [31:0] imm_m;

    mem_pipeline u_mem_pipeline (
        .clk         (clk),
        .rst         (rst),
        .wb_sel_e    (wb_sel_e),
        .o_alu_e     (o_alu_e),
        .op_pc_e     (op_pc_e),
        .imm_e       (imm_e),
        .o_rdata_e   (o_rdata),
        .instr_code_e(instr_code_e),
        .RegWrite_e  (RegWrite_e),

        .wb_sel_m    (wb_sel_m),
        .o_alu_m     (o_alu_m),
        .op_pc_m     (op_pc_m),
        .imm_m       (imm_m),
        .o_rdata_m   (o_rdata_m),
        .instr_code_m(instr_code_m),
        .RegWrite_m  (RegWrite_m)
    );

    //==================================================================
    // WB stage
    //==================================================================
    writeback u_writeback (
        .wb_sel (wb_sel_m),
        .o_alu  (o_alu_m),
        .d_rdata(o_rdata_m),
        .next_pc(op_pc_m),
        .imm    (imm_m),
        .next_rd(next_rd)
    );

endmodule

`default_nettype wire
