module fetch (
    input clk,
    input rst,
    input btaken,
    input jal_sel,
    input [31:0] rdata1,
    input [31:0] instr_raddr,
    output[31:0] instr_code,
    output pc_alu_out
);

  instruction_memory u_instruction_memory (
      .instr_raddr(instr_raddr),
      .instr_code(instr_code)
  );
  
  pc u_pc (
      .clk(clk),
      .rst(rst),
      .jal_sel(jal_sel),
      .btaken(btaken),
      .current_pc
  );

endmodule
