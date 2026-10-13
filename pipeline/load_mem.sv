
module load_mem (
    input  logic [ 1:0] byte_offset,
    input  logic        load_u,
    input  logic [31:0] d_rdata,
    input  logic        aligned,
    input  logic [ 3:0] mem_size,
    input  logic [ 6:0] word_index,
    output logic [31:0] o_rdata,
    output logic [31:0] o_wdata
);

  logic [31:0] al_d_rdata;

  assign o_rdata = aligned ? al_d_rdata : 32'd0;

 //align for register data type
  load_align u_load_align (
      .mem_size(mem_size),
      .load_u(load_u),
      .byte_offset(byte_offset),
      .in_data(d_rdata),
      .out_data(al_d_rdata)
  );


endmodule

module load_align (
    input        [ 3:0] mem_size,
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
      load_u, mem_size
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
