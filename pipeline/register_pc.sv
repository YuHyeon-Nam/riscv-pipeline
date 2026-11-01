`timescale 1ns / 1ps

module reigster_pc (
    input  logic        clk,
    input  logic        rst,
    input  logic        en, //~stall
    input  logic [31:0] data_in,
    output logic [31:0] data_out
);

    logic [31:0] register;

    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            //pc count init for 32'h0000_0000 address
            register <= 32'd0;  //pc counter의 시작주소를 0으로 설정하였기 때문
        end else if (en) begin
            register <= data_in;
        end
    end

    assign data_out = register;

endmodule
