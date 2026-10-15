module execute_pipeline (
    input logic        clk,
    input logic        rst,
    input logic [31:0] instr_code_d,
    input logic [31:0] c_pc_d,
    input logic [31:0] rdata1_d,
    input logic [31:0] rdata2_d,
    input logic [31:0] imm_d,
    input logic [ 2:0] wb_sel_d,
    input logic        MemRead_d,
    input logic        MemtoReg_d,
    input logic        MemWrite_d,
    input logic        ALUSrc_d,
    input logic        RegWrite_d,
    input logic        mem_size_d,
    input logic        load_un_d,
    input logic [31:0] op_pc_d,
    input logic [31:0] mem_wdata_d,
    input logic [31:0] o_alu_d,

    output logic [31:0] instr_code_e,
    output logic [31:0] c_pc_e,
    output logic [31:0] rdata1_e,
    output logic [31:0] rdata2_e,
    output logic [31:0] imm_e,
    output logic [ 2:0] wb_sel_e,
    output logic        MemRead_e,
    output logic        MemtoReg_e,
    output logic        MemWrite_e,
    output logic        ALUSrc_e,
    output logic        RegWrite_e,
    output logic        mem_size_e,
    output logic        load_un_e,
    output logic [31:0] op_pc_e,
    output logic [31:0] mem_wdata_e,
    output logic [31:0] o_alu_e
);

  always_ff @(posedge clk) begin
    if (rst) begin
      instr_code_e <= '0;
      c_pc_e       <= '0;
      rdata1_e     <= '0;
      rdata2_e     <= '0;
      imm_e        <= '0;
      wb_sel_e     <= '0;
      MemRead_e    <= '0;
      MemtoReg_e   <= '0;
      MemWrite_e   <= '0;
      ALUSrc_e     <= '0;
      RegWrite_e   <= '0;
      mem_size_e   <= '0;
      load_un_e    <= '0;
      op_pc_e      <= '0;
      mem_wdata_e  <= '0;
      o_alu_e      <= '0;
    end else begin
      instr_code_e <= instr_code_d;
      c_pc_e       <= c_pc_d;
      rdata1_e     <= rdata1_d;
      rdata2_e     <= rdata2_d;
      imm_e        <= imm_d;
      wb_sel_e     <= wb_sel_d;
      MemRead_e    <= MemRead_d;
      MemtoReg_e   <= MemtoReg_d;
      MemWrite_e   <= MemWrite_d;
      ALUSrc_e     <= ALUSrc_d;
      RegWrite_e   <= RegWrite_d;
      mem_size_e   <= mem_size_d;
      load_un_e    <= load_un_d;
      op_pc_e      <= op_pc_d;
      mem_wdata_e  <= mem_wdata_d;
      o_alu_e      <= o_alu_d;
    end
  end

endmodule
