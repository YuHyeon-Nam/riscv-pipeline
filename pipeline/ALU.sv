`include "define.vh"

module alu (
    input  logic [ 3:0] ctl_alu,
    input  logic [31:0] a,
    input  logic [31:0] b,
    output logic [31:0] alu_result
);
    logic [4:0] shamt;
    assign shamt = b[4:0];  //31까지 bit shifting

    always_comb begin
        alu_result = 0;
        case (ctl_alu)
            `ADD:  alu_result = a + b;
            `SUB:  alu_result = a - b;
            `SLL:  alu_result = a << shamt;
            `SLT:  alu_result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
            `SLTU: alu_result = ($unsigned(a) < $unsigned(b)) ? 32'd1 : 32'd0;
            `XOR:  alu_result = a ^ b;
            `SRL:  alu_result = a >> shamt;
            `SRA:  alu_result = $signed(a) >>> shamt;  //msb extends
            `OR:   alu_result = a | b;
            `AND:  alu_result = a & b;
        endcase
    end

endmodule
