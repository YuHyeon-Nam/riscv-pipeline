`timescale 1ns / 1ps

module data_mem (
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] i_wdata,
    input  logic        MemWrite,
    input  logic        aligned,
    input  logic [31:0] mask,
    input  logic [ 6:0] word_index,
    output logic [31:0] d_rdata
);
    logic [31:0] d_mem[0:127];

    always_ff @(posedge clk) begin
        if (MemWrite && aligned) begin
            d_mem[word_index] <= i_wdata | (d_mem[word_index] & ~mask);
        end
    end

    // // data_mem : mask 대신 wstrb[3:0] 입력
    // always_ff @(posedge clk) begin
    //     if (MemWrite && aligned) begin
    //         for (int b = 0; b < 4; b++)
    //             if (wstrb[b]) d_mem[word_index][8*b +: 8] <= i_wdata[8*b +: 8];
    //     end
    // end

    //for simulation
    integer i;

    initial begin
        for (i = 0; i < 128; i++) begin
            d_mem[i] <= i;
        end
    end

    assign d_rdata = d_mem[word_index];

endmodule
