`include "define.vh"

module branch (
    input  logic [ 2:0] clt_b,   //funct3
    input  logic        branch,
    input  logic [31:0] a,
    input  logic [31:0] b,
    output logic        btaken
);

    logic result;
    assign btaken = branch && result; // btaken && branch 쓰던 형태 대신에 btaken 이것 하나만 써도 될듯.

    always_comb begin
        result = 1'b0;
        case (clt_b)
            `BEQ:  result = (a == b) ? 1 : 0;
            `BNE:  result = (a != b) ? 1 : 0;
            `BLT:  result = ($signed(a) < $signed(b)) ? 1 : 0;
            `BGE:  result = ($signed(a) >= $signed(b)) ? 1 : 0;
            `BLTU: result = (a < b) ? 1 : 0;
            `BGEU: result = (a >= b) ? 1 : 0;
        endcase
    end

endmodule
