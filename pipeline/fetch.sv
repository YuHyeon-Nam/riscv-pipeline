module fetch (
    input  logic        clk,
    input  logic        rst,
    input  logic        jal_sel,
    input  logic        jarl_sel,
    input  logic        PCSrc,
    input  logic [31:0] alu_pc,
    input  logic [31:0] in_pc,
    input  logic [31:0] instr_raddr,
    output logic [31:0] instr_code,
    output logic [31:0] c_pc
);
  logic [31:0] alu_pc_next;
  logic [31:0] alu_pc_result;
  logic pc_sel;
  assign pc_sel  = jal_sel | PCSrc | jarl_sel;
  assign next_pc = pc_sel ? alu_pc : in_pc;


  instruction_memory u_instruction_memory (
      .instr_raddr(instr_raddr),
      .instr_code (instr_code)
  );

  reigster_pc u_register (
      .clk(clk),
      .rst(rst),
      .data_in(next_pc),  //in_pc
      .data_out(c_pc)
  );

  //   mux_2x1 u_mux_pc (
  //       .mux_sel(sel_j_b),
  //       .in_0(alu_pc),
  //       .in_1(),  //mux_jarl_out <- jal or jalr 일단 생략. 
  //       .mux_out(alu_pc_result)
  //   );

endmodule
