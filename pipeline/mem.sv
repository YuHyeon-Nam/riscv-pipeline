module mem (
    input clk,
    input rst
);

  wrappermem u_wrappermem (
      .d_wdata,
      .MemWrite,
      .load_u,
      .mem_addr,
      .mem_size,
      .o_wdata,
      .word_index,
      .aligned
  );

  data_mem u_data_mem (
      .clk,
      .rst,
      .i_wdata,
      .MemWrite,
      .aligned,
      .word_index,
      .d_rdata
  );

  load_mem u_load_mem (
      .byte_offset,
      .load_u,
      .d_rdata,
      .aligned,
      .mem_size,
      .word_index,
      .o_rdata,
      .o_wdata
  );


endmodule
