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
      .MemtoReg(MemtoReg),  //rd지정.
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
      .instr_code_d(instr_code_d),
      .c_pc_d(c_pc_d),
      .rdata1_d(rdata1_d),
      .rdata2_d(rdata2_d),
      .imm_d(imm_d),
      .wb_sel_d(wb_sel_d),
      .MemRead_d(MemRead_d),
      .MemtoReg_d(MemtoReg_d),
      .MemWrite_d(MemWrite_d),
      .ALUSrc_d(ALUSrc_d),
      .RegWrite_d(RegWrite_d),
      .mem_size_d(mem_size_d),
      .load_un_d(load_un_d),
      .op_pc_d(op_pc_d),
      .mem_wdata_d(mem_wdata_d),
      .o_alu_d(o_alu_d),
      .instr_code_e(instr_code_e),
      .c_pc_e(c_pc_e),
      .rdata1_e(rdata1_e),
      .rdata2_e(rdata2_e),
      .imm_e(imm_e),
      .wb_sel_e(wb_sel_e),
      .MemRead_e(MemRead_e),
      .MemtoReg_e(MemtoReg_e),
      .MemWrite_e(MemWrite_e),
      .ALUSrc_e(ALUSrc_e),
      .RegWrite_e(RegWrite_e),
      .mem_size_e(mem_size_e),
      .load_un_e(load_un_e),
      .op_pc_e(op_pc_e),
      .mem_wdata_e(mem_wdata_e),
      .o_alu_e(o_alu_e)
  );

  mem u_mem (
      .clk(clk),
      .rst(rst),
      .MemWrite(MemWrite_e),
      .load_un(load_un_e),
      .w_data(rdata2_e),
      .mem_addr(o_alu_e),
      .mem_wdata(mem_wdata_e),
      .o_rdata(o_rdata)
  );

  mem_pipeline u_mem_pipeline (
      .clk(clk),
      .rst(rst),
      .wb_sel_e(wb_sel_e),
      .o_alu_e(o_alu_e),
      .op_pc_e(op_pc_e),
      .imm_e(imm_e),
      .o_rdata_e(o_rdata_e),
      .wb_sel_m(wb_sel_m),
      .o_alu_m(o_alu_m),
      .op_pc_m(op_pc_m),
      .imm_m(imm_m),
      .o_rdata_m(o_rdata_m)
  );

  writeback u_writeback (
      .wb_sel(wb_sel_m),
      .o_alu(o_alu_m),
      .d_rdata(o_rdata_m),
      .next_pc(op_pc_m),
      .imm(imm_m),
      .next_rd(next_rd)
  );

endmodule
