`timescale 1ns / 1ps


module data_mem (
    input  logic         clk,
    input  logic         rst,
    input  logic  [31:0] i_wdata,
    input  logic         MemWrite,
    input  logic         aligned,
    input  logic  [ 6:0] word_index,
    output logic  [31:0] d_rdata
);
  logic [31:0] d_mem[0:127];

  always_ff @(posedge clk) begin
    if (rst) begin

    end else if (MemWrite && aligned) begin
      d_mem[word_index] <= i_wdata;
    end
  end

//for simulation
  integer i;

  initial begin
    for (i = 0; i < 128; i++) begin
      d_mem[i] <= i+1;
    end
  end

  assign d_rdata = d_mem[word_index];

endmodule

