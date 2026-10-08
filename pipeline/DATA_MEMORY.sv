`timescale 1ns / 1ps


module DATA_MEMORY (
    input         clk,
    input         rst,
    input  [31:0] d_wdata,
    input         MemWrite,
    input         load_u,
    input  [31:0] d_addr,
    input  [ 3:0] st_size,
    output [31:0] d_rdata
);
  //64 bytes. 16words align
  //word addressing
  logic [31:0] d_mem[0:127];
  logic [6:0] word_index;  // what 32bit word in d_mem
  logic [1:0] byte_offset;  // what kind of byte or half in word
  logic [31:0] d_c_mem, wdata_shifted, mask, out_mem_data;
  logic [3:0] wstrb;
  logic aligned;
  integer  i;

  assign word_index = d_addr[8:2];
  assign byte_offset = d_addr[1:0];
  assign wdata_shifted = d_wdata << 8 * byte_offset;
  assign mask = {{8{wstrb[3]}}, {8{wstrb[2]}}, {8{wstrb[1]}}, {8{wstrb[0]}}};
  assign d_c_mem = d_mem[word_index];

  // initial begin
  //     for (int i = 0; i < 10; i++) begin
  //         d_mem[i] = i;
  //     end
  // end

  align u_align (
      .st_size(st_size),
      .byte_offset(byte_offset),
      .aligned(aligned)
  );

  store_size u_store_size (
      .st_size(st_size),
      .byte_offset(byte_offset),
      .wstrb(wstrb)
  );

  load_align u_load_align (
      .st_size(st_size),
      .load_u(load_u),
      .byte_offset(byte_offset),
      .in_data(d_c_mem),
      .out_data(out_mem_data)
  );

  //store / load 출력
  always_ff @(posedge clk) begin
    if (rst) begin
        for(i=0; i<128; i++)begin
            d_mem[i]<=i;
        end
    end else if (MemWrite && aligned) begin
      d_mem[word_index] <= (d_c_mem & ~mask) | (wdata_shifted & mask);
    end
  end

  assign d_rdata = aligned ? out_mem_data : 32'd0;

endmodule


module store_size (
    input [3:0] st_size,
    input [1:0] byte_offset,
    output logic [3:0] wstrb
);
  always_comb begin
    case (st_size)
      4'b1111: wstrb = st_size;
      4'b0011, 4'b0001: wstrb = st_size << byte_offset;  // lsb zero extends
      default: wstrb = st_size;
    endcase
  end
endmodule

module load_align (
    input        [ 3:0] st_size,
    input        [ 1:0] byte_offset,
    input               load_u,       //load_unsigned
    input        [31:0] in_data,
    output logic [31:0] out_data
);
  logic [31:0] rdata_shifted;
  logic [15:0] data_half;
  logic [ 7:0] data_byte;


  assign rdata_shifted = in_data >> (8 * byte_offset);
  assign data_half = rdata_shifted[15:0];
  assign data_byte = rdata_shifted[7:0];

  always_comb begin
    out_data = in_data;
    case ({
      load_u, st_size
    })
      5'b0_1111: begin  //LW
        out_data = in_data;
      end
      5'b0_0011: begin  //LH
        out_data = {{16{data_half[15]}}, data_half};
      end
      5'b0_0001: begin  //LB
        out_data = {{24{data_byte[7]}}, data_byte};
      end
      5'b1_0011: begin  //LHU
        out_data = {{16{1'b0}}, data_half};
      end
      5'b1_0001: begin  //LBU
        out_data = {{24{1'b0}}, data_byte};
      end
    endcase
  end

endmodule

module align (
    input [3:0] st_size,
    input [1:0] byte_offset,
    output logic aligned
);
  always_comb begin
    aligned = 1'b0;
    case (st_size)
      4'b0001: aligned = 1'b1;  //true for any byte_offset.
      4'b0011: aligned = (byte_offset[0] == 1'b0);  //half : 0 or 2(10)
      4'b1111: aligned = (byte_offset == 2'b00);
    endcase
  end
endmodule
