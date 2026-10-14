module pc (
    input         clk,
    input         rst,
    input         jal_sel,
    input         PCSrc,
    input  [31:0] in_pc,
    output [31:0] c_pc

);
  logic [31:0] alu_pc_next;
  logic [31:0] alu_pc_result;

  assign sel_j_b = jal_sel | PCSrc;

//   alu u_pc_alu (
//       .alu_control(4'b0000),
//       .a(32'd4),
//       .b(c_pc),
//       .alu_result(alu_pc_next)
//   );

  mux_2x1 u_mux_pc (
      .mux_sel(sel_j_b),
      .in_0(alu_pc_next),
      .in_1(),  //mux_jarl_out <- jal or jalr 일단 생략. 
      .mux_out(alu_pc_result)
  );

  reigster_pc u_register (
      .clk(clk),
      .rst(rst),
      .data_in(alu_pc_result), //in_pc
      .data_out(c_pc)
  );


  //jal : imm + pc, jalr : imm + rs1 <- 이 선택은 execute에서.
  // mux_2x1 u_mux_jarl (
  //     .mux_sel(jarl_sel),
  //     .in_0(c_pc),
  //     .in_1(rs1),
  //     .mux_out(mux_jarl_out)
  // );
endmodule
