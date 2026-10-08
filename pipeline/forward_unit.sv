module forward_unit (
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] rs1,
    input  logic [31:0] rs2,
    input  logic [31:0] ex_rd,
    input  logic [31:0] mem_rd,
    output logic        forward,
    output logic        stall
);

    assign forward = (ex_rd == rs1|rs2) | (mem_rd == rs1|rs2) ? 1:0;

endmodule
