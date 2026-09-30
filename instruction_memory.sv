<<<<<<< HEAD
`timescale 1ns / 1ps

module instruction_memory (
    input  [31:0] instr_raddr,
    output [31:0] instr_code
);
    logic [31:0] rom_file[0:64];
    localparam logic [6:0] I_OPCODE = 7'b0010011;
    // logic[6:0] i_opcode;
    // assign i_opcode = 7'b0010011;

    initial begin
        $readmemh("rom_instr_ex0.mem",rom_file);
        // for (int i = 0; i < 16; i++) begin
        //     rom_file[i] = 32'd0 + i;
        // end
        
        // //R type
        // rom_file[0] = 32'h0041_82b3; //ADD x5 x3 x4
        // rom_file[1] = 32'h4074_0333; //SUB x6 x8 x7
        // rom_file[2] = 32'h00B514B3; // SLL  x9,  x10, x11
        // rom_file[3] = 32'h00E6A633; // SLT  x12, x13, x14
        // rom_file[4] = 32'h011837B3; // SLTU x15, x16, x17
        // rom_file[5] = 32'h0149C933; // XOR x18, x19, x20
        // rom_file[6] = 32'h017B5AB3; // SRL  x21, x22, x23
        // rom_file[7] = 32'h41ACDC33; // SRA  x24, x25, x26
        // rom_file[8] = 32'h01DE6DB3; // OR   x27, x28, x29
        // rom_file[9] = 32'h002FFF33; // AND  x30, x31, x2

        // // ADDI x2, x0, 0          ; base = 0
        // rom_file[0]  = 32'h0000_0113;
        // // LB  x3, 0(x2)           ; byte=0x01 -> 0x00000001
        // rom_file[1]  = 32'h0001_0183;
        // // LB  x4, 2(x2)           ; byte=0xFF -> 0xFFFFFFFF (sign-extend)
        // rom_file[2]  = 32'h0021_0203;
        // // LBU x5, 2(x2)           ; byte=0xFF -> 0x000000FF (zero-extend)
        // rom_file[3]  = 32'h0021_4283;
        // // LH  x6, 0(x2)           ; half=0x7F01 -> 0x00007F01
        // rom_file[4]  = 32'h0001_1303;
        // // LHU x7, 2(x2)           ; half=0x80FF -> 0x000080FF
        // rom_file[5]  = 32'h0021_5383;
        // // LW  x8, 0(x2)           ; word=0x80FF7F01
        // rom_file[6]  = 32'h0001_2403;
        // // LB  x9, 3(x2)           ; byte=0x80 -> 0xFFFFFF80 (sign-extend)
        // rom_file[7]  = 32'h0031_0483;
        // // LBU x10, 3(x2)          ; byte=0x80 -> 0x00000080
        // rom_file[8]  = 32'h0031_4503;
        // // LH  x11, 2(x2)          ; half=0x80FF -> 0xFFFF80FF (sign-extend)
        // rom_file[9]  = 32'h0021_1583;
        // stop: JAL x0, 0         ; 무한루프
        // rom_file[10] = 32'h0000_006F;
        //funct7 rs2 rs1 funct3 rd opcode
        // rom_file[0] = 32'b0000000_00100_00011_000_00101_0110011; //ADD
        // rom_file[0] = 32'b0000_0000_0100_0001_1000_0010_1011_0011; //ADD
        // rom_file[1] = 32'b0100000_00111_01000__000_00110_0110011;//x6= x8 - x7 rd, rs1 rs2에 6 8 7 넣음.
        
        // // I-type
        // //imm, rs1, funct3, rd, opcode
        // rom_file[0] = {12'h004, 5'd1, 3'b000, 5'd2,  I_OPCODE}; // ADDI  x2,  x1,  4
        // rom_file[2] = {12'h004, 5'd3, 3'b010, 5'd4,  I_OPCODE}; // SLTI  x4,  x3,  4
        // rom_file[3] = {12'h004, 5'd3, 3'b011, 5'd4,  I_OPCODE}; // SLTIU x4,  x3,  4
        // rom_file[4] = {12'h004, 5'd5, 3'b100, 5'd6,  I_OPCODE}; // XORI  x6,  x5,  4
        // rom_file[5] = {12'h004, 5'd7, 3'b110, 5'd8,  I_OPCODE}; // ORI   x8,  x7,  4
        // rom_file[6] = {12'h004, 5'd9, 3'b111, 5'd10, I_OPCODE}; // ANDI  x10, x9,  4

        // // shift-immediate: imm[11:5] shamt rs1 funct3 rd opcode
        // rom_file[7] = {7'b0000000, 5'd4, 5'd11, 3'b001, 5'd12, I_OPCODE}; // SLLI x12, x11, 4
        // rom_file[8] = {7'b0000000, 5'd4, 5'd13, 3'b101, 5'd14, I_OPCODE}; // SRLI x14, x13, 4
        // rom_file[9] = {7'b0100000, 5'd4, 5'd15, 3'b101, 5'd16, I_OPCODE}; // SRAI x16, x15, 4
        // rom_file[10] = 32'h0021_2383; //LW x7, 2 (x2)
        
        //S-type
        // rom_file[0] = 32'h0081_2323;  // SW x8,  6(x2)  -> EA=8   (word_addr=2, byte_off=0)  정렬OK
        // rom_file[1] = 32'h0081_1623;  // SH x8, 12(x2)  -> EA=14  (word_addr=3, byte_off=2)  상위 half에 씀
        // rom_file[2] = 32'h0081_01A3;  // SB x8,  3(x2)  -> EA=5   (word_addr=1, byte_off=1)  byte lane1에 씀
        
        // //J-type
        // rom_file[3] = 32'h0080_00EF;  // JAL x1, +8  (3->5로 점프, x1=PC+4)
        // rom_file[5] = 32'h0000_8067;  // JALR x0, 0(x1) (return: PC = (x1+0)&~1 = 4)
        // rom_file[6] = 32'h0080_00EF;  // JAL  x1, +8
        // rom_file[8] = 32'h0000_8067;  // JALR x0, 0(x1)
        
        // === 간접 점프(JALR) 데모 ===
        // rom_file[0] = 32'h0200_0293; // ADDI x5, x0, 32   ; x5 = 32 (PC=32 -> rom[8])
        // rom_file[1] = 32'h0002_8067; // JALR x0, 0(x5)    ; PC = x5 = 32 -> rom[8]
        // rom_file[2] = 32'h0010_0013; // (실행되면 안됨) dummy
        // rom_file[3] = 32'h0010_0013; // dummy
        // rom_file[4] = 32'h0010_0013; // dummy
        // rom_file[5] = 32'h0010_0013; // dummy
        // rom_file[6] = 32'h0010_0013; // dummy
        // rom_file[7] = 32'h0010_0013; // dummy
        // rom_file[8] = 32'h0000_0013; // NOP (도착 지점)
        // rom_file[9] = 32'h0000_006F; // JAL x0, 0 (무한루프)

        // === call/return 데모 ===
        // rom[0]에서 '함수' rom[4]로 call (JAL)
        // 함수 끝에서 JALR로 복귀 (ret)
        // rom_file[0] = 32'h0100_00EF;  // JAL x1, +16  ; PC=0 -> 16(rom[4]), x1=4(복귀주소)
        // rom_file[1] = 32'h0010_0013;  // dummy (call 성공하면 여기로 '복귀'해서 실행됨)
        // rom_file[2] = 32'h0000_006F;  // JAL x0, 0    ; 무한루프(복귀 후 여기서 멈춰도 됨)
        // rom_file[3] = 32'h0000_0013;  // dummy

        // // ---- "함수" 시작 지점 (PC=16, rom[4]) ----
        // rom_file[4] = 32'h0000_0013;  // NOP (함수 바디)
        // rom_file[5] = 32'h0000_8067;  // JALR x0, 0(x1) ; return to x1 (=4, 즉 rom[1])


        //B-type
        // rom_file[0] = 32'h0041_82b3; //ADD x5 x3 x4
        // rom_file[1] = 32'h4074_0333; //SUB x6 x8 x7
        // rom_file[2] = 32'h0021_0663; //beq x2,x2,12
        // rom_file[5] = 32'h0000_a297; //AUIPC x5, 10

        // // rom_file[5] = 32'h0041_82b3; //ADD x5 x3 x4
        // rom_file[6] = 32'h4074_0333; //SUB x6 x8 x7
        // rom_file[7] = 32'h1234_5537; //LUI x10 0x1234_5000
    end

    assign instr_code = rom_file[instr_raddr[31:2]];  //4씩증가

endmodule
// 워드 단위 제어
// for 32bit addressing
// logic[31:0] rom_file[0:15];
// initial begin
//     for (int i = 0;i<16;i++ ) begin
//         rom_file[i] = i;
//     end
// end
// assign instr_code = rom_file[instr_raddr[31:2]]; //4씩증가

// 바이트 단위 어드레스 제어
//     logic [7:0] rom_file[0:15*4];
//     initial begin
//         for (int i = 0;i<16*4;i++ ) begin
//             rom_file[i] = 8'd0 + i;
//         end
//     end

// assign instr_code = {rom_file[instr_raddr+3],rom_file[instr_raddr+2],rom_file[instr_raddr+1],rom_file[instr_raddr]}; 
=======
`timescale 1ns / 1ps

module instruction_memory (
    input  [31:0] instr_raddr,
    output [31:0] instr_code
);
    logic [31:0] rom_file[0:64];
    localparam logic [6:0] I_OPCODE = 7'b0010011;
    // logic[6:0] i_opcode;
    // assign i_opcode = 7'b0010011;

    initial begin
        $readmemh("rom_instr_ex0.mem",rom_file);
        // for (int i = 0; i < 16; i++) begin
        //     rom_file[i] = 32'd0 + i;
        // end
        
        // //R type
        // rom_file[0] = 32'h0041_82b3; //ADD x5 x3 x4
        // rom_file[1] = 32'h4074_0333; //SUB x6 x8 x7
        // rom_file[2] = 32'h00B514B3; // SLL  x9,  x10, x11
        // rom_file[3] = 32'h00E6A633; // SLT  x12, x13, x14
        // rom_file[4] = 32'h011837B3; // SLTU x15, x16, x17
        // rom_file[5] = 32'h0149C933; // XOR x18, x19, x20
        // rom_file[6] = 32'h017B5AB3; // SRL  x21, x22, x23
        // rom_file[7] = 32'h41ACDC33; // SRA  x24, x25, x26
        // rom_file[8] = 32'h01DE6DB3; // OR   x27, x28, x29
        // rom_file[9] = 32'h002FFF33; // AND  x30, x31, x2

        // // ADDI x2, x0, 0          ; base = 0
        // rom_file[0]  = 32'h0000_0113;
        // // LB  x3, 0(x2)           ; byte=0x01 -> 0x00000001
        // rom_file[1]  = 32'h0001_0183;
        // // LB  x4, 2(x2)           ; byte=0xFF -> 0xFFFFFFFF (sign-extend)
        // rom_file[2]  = 32'h0021_0203;
        // // LBU x5, 2(x2)           ; byte=0xFF -> 0x000000FF (zero-extend)
        // rom_file[3]  = 32'h0021_4283;
        // // LH  x6, 0(x2)           ; half=0x7F01 -> 0x00007F01
        // rom_file[4]  = 32'h0001_1303;
        // // LHU x7, 2(x2)           ; half=0x80FF -> 0x000080FF
        // rom_file[5]  = 32'h0021_5383;
        // // LW  x8, 0(x2)           ; word=0x80FF7F01
        // rom_file[6]  = 32'h0001_2403;
        // // LB  x9, 3(x2)           ; byte=0x80 -> 0xFFFFFF80 (sign-extend)
        // rom_file[7]  = 32'h0031_0483;
        // // LBU x10, 3(x2)          ; byte=0x80 -> 0x00000080
        // rom_file[8]  = 32'h0031_4503;
        // // LH  x11, 2(x2)          ; half=0x80FF -> 0xFFFF80FF (sign-extend)
        // rom_file[9]  = 32'h0021_1583;
        // stop: JAL x0, 0         ; 무한루프
        // rom_file[10] = 32'h0000_006F;
        //funct7 rs2 rs1 funct3 rd opcode
        // rom_file[0] = 32'b0000000_00100_00011_000_00101_0110011; //ADD
        // rom_file[0] = 32'b0000_0000_0100_0001_1000_0010_1011_0011; //ADD
        // rom_file[1] = 32'b0100000_00111_01000__000_00110_0110011;//x6= x8 - x7 rd, rs1 rs2에 6 8 7 넣음.
        
        // // I-type
        // //imm, rs1, funct3, rd, opcode
        // rom_file[0] = {12'h004, 5'd1, 3'b000, 5'd2,  I_OPCODE}; // ADDI  x2,  x1,  4
        // rom_file[2] = {12'h004, 5'd3, 3'b010, 5'd4,  I_OPCODE}; // SLTI  x4,  x3,  4
        // rom_file[3] = {12'h004, 5'd3, 3'b011, 5'd4,  I_OPCODE}; // SLTIU x4,  x3,  4
        // rom_file[4] = {12'h004, 5'd5, 3'b100, 5'd6,  I_OPCODE}; // XORI  x6,  x5,  4
        // rom_file[5] = {12'h004, 5'd7, 3'b110, 5'd8,  I_OPCODE}; // ORI   x8,  x7,  4
        // rom_file[6] = {12'h004, 5'd9, 3'b111, 5'd10, I_OPCODE}; // ANDI  x10, x9,  4

        // // shift-immediate: imm[11:5] shamt rs1 funct3 rd opcode
        // rom_file[7] = {7'b0000000, 5'd4, 5'd11, 3'b001, 5'd12, I_OPCODE}; // SLLI x12, x11, 4
        // rom_file[8] = {7'b0000000, 5'd4, 5'd13, 3'b101, 5'd14, I_OPCODE}; // SRLI x14, x13, 4
        // rom_file[9] = {7'b0100000, 5'd4, 5'd15, 3'b101, 5'd16, I_OPCODE}; // SRAI x16, x15, 4
        // rom_file[10] = 32'h0021_2383; //LW x7, 2 (x2)
        
        //S-type
        // rom_file[0] = 32'h0081_2323;  // SW x8,  6(x2)  -> EA=8   (word_addr=2, byte_off=0)  정렬OK
        // rom_file[1] = 32'h0081_1623;  // SH x8, 12(x2)  -> EA=14  (word_addr=3, byte_off=2)  상위 half에 씀
        // rom_file[2] = 32'h0081_01A3;  // SB x8,  3(x2)  -> EA=5   (word_addr=1, byte_off=1)  byte lane1에 씀
        
        // //J-type
        // rom_file[3] = 32'h0080_00EF;  // JAL x1, +8  (3->5로 점프, x1=PC+4)
        // rom_file[5] = 32'h0000_8067;  // JALR x0, 0(x1) (return: PC = (x1+0)&~1 = 4)
        // rom_file[6] = 32'h0080_00EF;  // JAL  x1, +8
        // rom_file[8] = 32'h0000_8067;  // JALR x0, 0(x1)
        
        // === 간접 점프(JALR) 데모 ===
        // rom_file[0] = 32'h0200_0293; // ADDI x5, x0, 32   ; x5 = 32 (PC=32 -> rom[8])
        // rom_file[1] = 32'h0002_8067; // JALR x0, 0(x5)    ; PC = x5 = 32 -> rom[8]
        // rom_file[2] = 32'h0010_0013; // (실행되면 안됨) dummy
        // rom_file[3] = 32'h0010_0013; // dummy
        // rom_file[4] = 32'h0010_0013; // dummy
        // rom_file[5] = 32'h0010_0013; // dummy
        // rom_file[6] = 32'h0010_0013; // dummy
        // rom_file[7] = 32'h0010_0013; // dummy
        // rom_file[8] = 32'h0000_0013; // NOP (도착 지점)
        // rom_file[9] = 32'h0000_006F; // JAL x0, 0 (무한루프)

        // === call/return 데모 ===
        // rom[0]에서 '함수' rom[4]로 call (JAL)
        // 함수 끝에서 JALR로 복귀 (ret)
        // rom_file[0] = 32'h0100_00EF;  // JAL x1, +16  ; PC=0 -> 16(rom[4]), x1=4(복귀주소)
        // rom_file[1] = 32'h0010_0013;  // dummy (call 성공하면 여기로 '복귀'해서 실행됨)
        // rom_file[2] = 32'h0000_006F;  // JAL x0, 0    ; 무한루프(복귀 후 여기서 멈춰도 됨)
        // rom_file[3] = 32'h0000_0013;  // dummy

        // // ---- "함수" 시작 지점 (PC=16, rom[4]) ----
        // rom_file[4] = 32'h0000_0013;  // NOP (함수 바디)
        // rom_file[5] = 32'h0000_8067;  // JALR x0, 0(x1) ; return to x1 (=4, 즉 rom[1])


        //B-type
        // rom_file[0] = 32'h0041_82b3; //ADD x5 x3 x4
        // rom_file[1] = 32'h4074_0333; //SUB x6 x8 x7
        // rom_file[2] = 32'h0021_0663; //beq x2,x2,12
        // rom_file[5] = 32'h0000_a297; //AUIPC x5, 10

        // // rom_file[5] = 32'h0041_82b3; //ADD x5 x3 x4
        // rom_file[6] = 32'h4074_0333; //SUB x6 x8 x7
        // rom_file[7] = 32'h1234_5537; //LUI x10 0x1234_5000
    end

    assign instr_code = rom_file[instr_raddr[31:2]];  //4씩증가

endmodule
// 워드 단위 제어
// for 32bit addressing
// logic[31:0] rom_file[0:15];
// initial begin
//     for (int i = 0;i<16;i++ ) begin
//         rom_file[i] = i;
//     end
// end
// assign instr_code = rom_file[instr_raddr[31:2]]; //4씩증가

// 바이트 단위 어드레스 제어
//     logic [7:0] rom_file[0:15*4];
//     initial begin
//         for (int i = 0;i<16*4;i++ ) begin
//             rom_file[i] = 8'd0 + i;
//         end
//     end

// assign instr_code = {rom_file[instr_raddr+3],rom_file[instr_raddr+2],rom_file[instr_raddr+1],rom_file[instr_raddr]}; 
>>>>>>> 4c3220865adb570c56a031b532a319ec6d607256
