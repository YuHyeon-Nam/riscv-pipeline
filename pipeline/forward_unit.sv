`timescale 1ns / 1ps
module forward_unit (
    input  logic [4:0] rs1_d,
    input  logic [4:0] rs2_d,
    input  logic [4:0] rd_e,
    input  logic       RegWrite_e,
    input  logic [4:0] rd_m,
    input  logic       RegWrite_m,
    output logic [1:0] forward_a,
    output logic [1:0] forward_b
);

    always_comb begin
        forward_a = 2'b00;
        //ex 1cycle forwarding
        if (RegWrite_e && (rd_e != 0) && (rd_e == rs1_d)) forward_a = 2'b10;
        //mem 2cycle forwarding
        else if (RegWrite_m && (rd_m != 0) && (rd_m == rs1_d)) forward_a = 2'b01;
    end
    always_comb begin
        forward_b = 2'b00;
        if (RegWrite_e && (rd_e != 0) && (rd_e == rs2_d)) forward_b = 2'b10;
        else if (RegWrite_m && (rd_m != 0) && (rd_m == rs2_d)) forward_b = 2'b01;
    end

endmodule
