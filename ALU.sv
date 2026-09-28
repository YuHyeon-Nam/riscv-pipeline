
module alu (
    input        [ 3:0] alu_control,
    input        [31:0] a,
    input        [31:0] b,
    output logic [31:0] alu_result,
    output logic        btaken
);
    logic [4:0] shamt;
    assign shamt = b[4:0];  //31까지 bit shifting

    always_comb begin
        alu_result = 0;
        case (alu_control)
            //R-type
            `ADD: begin
                alu_result = a + b;
            end
            `SUB: begin
                alu_result = a - b;
            end
            `SLL: begin
                alu_result = a << shamt;  //산술 : 2의 n승으로 곱하는 효과
            end
            `SLT: begin  //SIGNED
                alu_result = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;  //기본적으로 unsigned로 
            end
            `SLTU: begin  //UNSIGNED
                alu_result = ($unsigned(a) < $unsigned(b)) ? 32'd1 : 32'd0;
                ;  //zero-extends
            end
            `XOR: begin
                alu_result = a ^ b;
            end
            `SRL: begin
                alu_result = a >> shamt;
            end
            `SRA: begin
                // >> 는 논리 쉬프트 (0채움)
                // 산술 쉬프트 (부호 확장) 
                // >>>를 써도, 왼쪽 피연산자가 signed여야 msb가 확장
                alu_result = $signed(a) >>> shamt;  //msb extends
            end
            `OR: begin
                alu_result = a | b;
            end
            `AND: begin
                alu_result = a & b;
            end
        endcase
    end

    compare u_compare_pc (
        .alu_control(alu_control),
        .rs1(a),
        .rs2(b),
        .btaken(btaken)
    );

endmodule

module compare (
    input [3:0] alu_control,
    input [31:0] rs1,
    input [31:0] rs2,
    output logic btaken
);
    always_comb begin
        btaken = 1'b0;
        case (alu_control)
            `BEQ: begin
                btaken = (rs1 == rs2);
            end
            `BNE: begin
                btaken = (rs1 != rs2);
            end
            `BLT: begin
                btaken = ($signed(rs1) < $signed(rs2));
            end
            `BGE: begin
                btaken = ($signed(rs1) >= $signed(rs2));
            end
            `BLTU: begin
                btaken = (rs1 < rs2);
            end
            `BGEU: begin
                btaken = (rs1 >= rs2);
            end
        endcase
    end

endmodule