module datapath_pipeline (
    input logic clk,
    input logic rst
);

  logic [31:0] instr_code;
  logic [31:0] instr_raddr;
  
  fetch u_fetch (
      .clk,
      .rst,
      .btaken,
      .jal_sel,
      .rdata1,
      .instr_raddr,
      .instr_code,
      .pc_alu_out
  );

  decode u_decode ();
  decode_pipeline u_decode_pipeline ();


  execute u_execute (
      .clk,
      .rst,
      .RegWrite,
      .ALUSrc,
      .branch,
      .jarl_sel,
      .jal_sel,
      .reg_w_src_sel,
      .ctl_alu,
      .instr_code,
      .w_data,
      .mem_addr,  //RAM address
      .mem_wdata  //RAM write data
  );

  execute_pipeline u_execute_pipeline (
      .clk,
      .rst,
      .RegWrite,
      .ALUSrc,
      .branch,
      .jarl_sel,
      .jal_sel,
      .reg_w_src_sel,
      .ctl_alu,
      .instr_code,
      .w_data,
      .mem_addr,  //RAM address
      .mem_wdata  //RAM write data
  );

  mem u_mem ();
  writeback u_writeback ();

endmodule
