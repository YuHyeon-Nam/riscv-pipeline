module datapath_pipeline (
    input logic clk,
    input logic rst
);

    logic [31:0] instr_code;
    logic [31:0] next_rd;
    logic [31:0] instr_raddr;
    logic [31:0] op_pc;
    logic [ 2:0] wb_sel;
    logic        btaken;
    logic        jal_sel;
    logic        rdata1;
    logic        pc_alu_out;
    logic        PCSrc;
    logic        op_sel;
    logic        aui;

    fetch u_fetch (
        .clk(clk),
        .rst(rst),
        .PCSrc(PCSrc),
        .jal_sel(jal_sel),
        .jarl_sel(jarl_sel),
        .alu_pc(o_alu),
        .in_pc(op_pc),
        .instr_raddr(instr_raddr),
        .instr_code(instr_code),
        .pc_alu_out(pc_alu_out)
    );

    logic [31:0] instr_code_f;
    logic [31:0] c_pc_f;

    fetch_pipeline u_fetch_pipeline (
        .clk(clk),
        .rst(rst),
        .instr_code(instr_code),
        .c_pc(c_pc),
        .instr_code_f(instr_code_f),
        .c_pc_f(c_pc_f)
    );

    decode u_decode (
        .clk(clk),
        .rst(rst),
        .instr_code(instr_code_f),
        .w_data(next_rd),
        .rdata1(rdata1),
        .rdata2(rdata2),
        .wb_sel(wb_sel),
        .aui(aui),
        .imm(imm),
        .branch(branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .jal_sel(jal_sel),
        .jarl_sel(jarl_sel),
        .mem_size(mem_size),
        .load_un(load_un)
    );

    assign op_sel = jal_sel | aui;

    decode_pipeline u_decode_pipeline (
        .clk(clk),
        .rst(rst),
        .c_pc_f(c_pc_f),
        .instr_code_f(instr_code_f),
        .rdata1(rdata1),
        .rdata2(rdata2),
        .imm(imm),
        .wb_sel(wb_sel),
        .branch(branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .jal_sel(jal_sel),
        .jarl_sel(jarl_sel),
        .aui(aui),
        .mem_size(mem_size),
        .load_un(load_un),

        .c_pc_d(c_pc_d),
        .instr_code_d(instr_code_d),
        .rdata1_d(rdata1_d),
        .rdata2_d(rdata2_d),
        .imm_d(imm_d),
        .wb_sel_d(wb_sel_d),
        .branch_d(branch_d),
        .MemRead_d(MemRead_d),
        .MemtoReg_d(MemtoReg_d),
        .MemWrite_d(MemWrite_d),
        .ALUSrc_d(ALUSrc_d),
        .RegWrite_d(RegWrite_d),
        .jal_sel_d(jal_sel_d),
        .jarl_sel_d(jarl_sel_d),
        .aui_d(aui_d),
        .mem_size_d(mem_size_d),
        .load_un_d(load_un_d)
    );

    execute u_execute (
        .clk(clk),
        .rst(rst),
        .RegWrite(RegWrite_d),
        .ALUSrc(ALUSrc_d),
        .branch(branch_d),
        .op_sel(op_sel),
        .instr_code(instr_code_d),
        .rdata1(rdata1_d),
        .rdata2(rdata2_d),
        .imm(imm_d),
        
        .PCSrc(PCSrc),
        .o_alu(o_alu),
        .mem_wdata(mem_wdata),
        .op_pc(op_pc)
    );

    execute_pipeline u_execute_pipeline (
        .clk(clk),
        .rst(rst),
        .RegWrite(RegWrite_d),
        .ALUSrc(ALUSrc_d),
        .instr_code(instr_code_d),
        .PCSrc(PCSrc),
        .o_alu(o_alu),
        .mem_wdata(mem_wdata),
        .op_pc(op_pc),
        
        .MemWrite(MemWrite_d),
        .load_un(load_un_d)
    );

    mem u_mem (
        .clk(clk),
        .rst(rst),
        .MemWrite(MemWrite),
        .load_un(load_un),
        .w_data(w_data),
        .mem_addr(o_alu),
        .mem_wdata(mem_wdata),
        .o_rdata(o_rdata)
    );

    mem_pipeline u_mem_pipeline (
        .clk(clk),
        .rst(rst),
        .MemWrite(MemWrite),
        .load_un(load_un),
        .aligned(aligned),
        .w_data(w_data),
        .mem_addr(),
        .mem_wdata(mem_wdata),
        .o_rdata(o_rdata)
    );

    writeback u_writeback (
        .wb_sel(wb_sel),
        .o_alu(o_alu),
        .d_rdata(o_rdata),
        .next_pc(op_pc),
        .imm(imm),
        .next_rd(next_rd)
    );

endmodule
