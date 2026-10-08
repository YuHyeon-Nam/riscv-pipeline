module decode_memory (
    input        clk,
    input [ 2:0] funct3,
    input [31:0] instr_code,
    input [31:0] data_in, //w_data
    input        MemWrite,
    //input        load_u, use funct3
    input [31:0] d_addr,
    output [31:0] data_o
);
`define SW 3'b010
`define SH 3'b001
`define SB 3'b000

//IL-type
`define LW 3'b010
`define LH 3'b001
`define LB 3'b000
`define LBU 3'b100
`define LHU 3'b101



    always_comb begin
        
        case (MemWrite,funct3)
            : 
            default: 
        endcase
        
    end
endmodule
