`timescale 1ns / 1ps


module wrappermem (
    input  logic [ 3:0] mem_size,
    input  logic [ 8:0] mem_addr,
    input  logic [31:0] w_data,
    output logic        aligned,
    output logic [ 1:0] byte_offset,
    output logic [ 6:0] word_index,
    output logic [31:0] o_wdata
);
  logic [31:0] wdata_shifted, mask;
  logic [3:0] wstrb;

  assign word_index    = mem_addr[8:2];
  assign byte_offset   = mem_addr[1:0];
  assign wdata_shifted = w_data << 8 * byte_offset;
  assign mask          = {{8{wstrb[3]}}, {8{wstrb[2]}}, {8{wstrb[1]}}, {8{wstrb[0]}}};
  assign o_wdata       = wdata_shifted & mask;


  always_comb begin
    aligned = 1'b0;
    case (mem_size)
      4'b0001: aligned = 1'b1;  //true for any byte_offset.
      4'b0011: aligned = (byte_offset[0] == 1'b0);  //half : 0 or 2(10)
      4'b1111: aligned = (byte_offset == 2'b00);
    endcase
  end

  assign wstrb = ((mem_size == 4'b0001)||(mem_size == 4'b0011)) ? mem_size << byte_offset : mem_size;

endmodule
