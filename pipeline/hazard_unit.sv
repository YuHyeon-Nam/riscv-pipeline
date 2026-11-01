`timescale 1ns / 1ps
module hazard_unit (
    input  logic       MemRead_d,
    input  logic [4:0] rd_d,
    input  logic [4:0] rs1,
    input  logic [4:0] rs2,
    output logic       stall
);
    assign stall = MemRead_d && rd_d != 0 && (rd_d == rs1 || rd_d == rs2) ? 1'b1 : 1'b0;

endmodule
