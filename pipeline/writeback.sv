module writeback (
    input  logic        wb_sel,
    input  logic [31:0] o_alu,
    input  logic [31:0] d_rdata,
    input  logic [31:0] next_pc,
    input  logic [31:0] imm,
    output logic [31:0] next_rd
);
  mux_4x1 u_mux_mem_alu (
      .mux_sel(wb_sel),
      .in_0   (o_alu),          //from alu
      .in_1   (d_rdata),        //from data mem
      .in_2   (imm),
      .in_3   (next_pc), 
      .mux_out(next_rd)         //to reg file
  );


  // mux_4x1 u_mux_mem_alu (
  //     .mux_sel(wb_sel),
  //     .in_0   (o_alu),     //from alu
  //     .in_1   (d_rdata),        //from data mem
  //     .in_2   (imm),            //LUI
  //     .in_3   (pc_aui),         //AUIPC from pc
  //     .in_4   (next_pc),
  //     .mux_out(next_rd)  //to reg file
  // );

endmodule
