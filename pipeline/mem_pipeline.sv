module mem_pipeline (
    input               clk,
    input               rst,
    input  logic [ 2:0] wb_sel_e,
    input  logic [31:0] o_alu_e,
    input  logic [31:0] op_pc_e,
    input  logic [31:0] imm_e,
    input  logic [31:0] o_rdata_e,
    output logic [ 2:0] wb_sel_m,
    output logic [31:0] o_alu_m,
    output logic [31:0] op_pc_m,
    output logic [31:0] imm_m,
    output logic [31:0] o_rdata_m
);
  always_ff @(posedge clk) begin
    if (rst) begin
      wb_sel_m <= '0;
      o_alu_m <= '0;
      op_pc_m <= '0;
      imm_m <= '0;
      o_rdata_m <= '0;
    end else begin
      wb_sel_m <= wb_sel_e;
      o_alu_m <= o_alu_e;
      op_pc_m <= op_pc_e;
      imm_m <= imm_e;
      o_rdata_m <= o_rdata_e;
    end
  end
endmodule
