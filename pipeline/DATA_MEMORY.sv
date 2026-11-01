`timescale 1ns / 1ps


module data_memory (
    input         clk,
    input         rst,
    input  [31:0] i_wdata,
    input         MemWrite,
    input         aligned,
    input  [ 6:0] word_index,
    output [31:0] d_rdata
);
  logic [31:0] d_mem[0:127];
  logic [31:0] out_mem_data;
  logic [3:0] wstrb;
  integer i;

  initial begin
    for (i = 0; i < 128; i++) begin
      d_mem[i] <= i;
    end
  end

  always_ff @(posedge clk) begin
    if (rst) begin

    end else if (MemWrite && aligned) begin
      d_mem[word_index] <= i_wdata;
    end
  end

  assign d_rdata = aligned ? out_mem_data : 32'd0;

endmodule

