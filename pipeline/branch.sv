`include "define.vh"

module branch (
    input  logic [ 2:0] clt_b,   //funct3
    input  logic [31:0] a,
    input  logic [31:0] b,
    output logic        btaken
);

    always_comb begin
        btaken = 1'b0;
        case (clt_b)
            `BEQ:  btaken = (a == b) ? 1 : 0;
            `BNE:  btaken = (a != b) ? 1 : 0;
            `BLT:  btaken = ($signed(a) < $signed(b)) ? 1 : 0;
            `BGE:  btaken = ($signed(a) >= $signed(b)) ? 1 : 0;
            `BLTU: btaken = (a < b) ? 1 : 0;
            `BGEU: btaken = (a >= b) ? 1 : 0;
        endcase
    end

endmodule