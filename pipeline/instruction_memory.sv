`timescale 1ns / 1ps

module instruction_memory (
    input  [31:0] instr_raddr,
    output [31:0] instr_code
);
    logic [31:0] rom_file[0:255];

    initial begin
        // 빈 칸은 nop (X 명령이 파이프라인에 들어가지 않도록)
        for (int i = 0; i < 256; i++) rom_file[i] = 32'h0000_0013;

        // ==============================================================
        // nop 삽입 1차 검증 프로그램 (해저드 처리 없이 동작 확인용)
        //  - RAW: 값을 쓰는 명령과 읽는 명령 사이 nop 3개
        //  - 분기/점프 뒤 nop 2개 (flush가 없어서 항상 실행됨)
        //  - x30: not-taken 분기가 정상이면 비트가 켜짐 (기대 0x3F)
        //  - x31: 실행되면 안 되는 명령이 실행된 횟수 (기대 0)
        //  - 기대값: tb_RV32_CORE.sv
        // ==============================================================
        rom_file[  0] = 32'h00500093;  //   0: addi  x1, x0, 5         ; x1 = 5
        rom_file[  1] = 32'hffd00113;  //   4: addi  x2, x0, -3        ; x2 = -3  (음수 imm: alu_control 수정 확인)
        rom_file[  2] = 32'h123451b7;  //   8: lui   x3, 0x12345       ; x3 = 0x12345000
        rom_file[  3] = 32'h00001217;  //  12: auipc x4, 0x1           ; x4 = pc + 0x1000
        rom_file[  4] = 32'h04000b93;  //  16: addi  x23, x0, 64       ; x23 = 0x40 (메모리 base)
        rom_file[  5] = 32'h00000f13;  //  20: addi  x30, x0, 0        ; x30 = 0 (not-taken 표시 비트)
        rom_file[  6] = 32'h00000f93;  //  24: addi  x31, x0, 0        ; x31 = 0 (에러 카운터)
        rom_file[  7] = 32'h00000013;  //  28: nop                     ; --- RAW: 위 값이 레지스터에 써질 때까지 대기 ---
        rom_file[  8] = 32'h00000013;  //  32: nop
        rom_file[  9] = 32'h00000013;  //  36: nop
        rom_file[ 10] = 32'h002082b3;  //  40: add   x5, x1, x2        ; R-type add
        rom_file[ 11] = 32'h40208333;  //  44: sub   x6, x1, x2        ; R-type sub
        rom_file[ 12] = 32'h001093b3;  //  48: sll   x7, x1, x1        ; R-type sll
        rom_file[ 13] = 32'h00112433;  //  52: slt   x8, x2, x1        ; R-type slt
        rom_file[ 14] = 32'h001134b3;  //  56: sltu  x9, x2, x1        ; R-type sltu
        rom_file[ 15] = 32'h0020c533;  //  60: xor   x10, x1, x2       ; R-type xor
        rom_file[ 16] = 32'h001155b3;  //  64: srl   x11, x2, x1       ; R-type srl
        rom_file[ 17] = 32'h40115633;  //  68: sra   x12, x2, x1       ; R-type sra
        rom_file[ 18] = 32'h0020e6b3;  //  72: or    x13, x1, x2       ; R-type or
        rom_file[ 19] = 32'h0020f733;  //  76: and   x14, x1, x2       ; R-type and
        rom_file[ 20] = 32'h00012793;  //  80: slti  x15, x2, 0        ; I-type slti
        rom_file[ 21] = 32'h00a0b813;  //  84: sltiu x16, x1, 10       ; I-type sltiu
        rom_file[ 22] = 32'hfff0c893;  //  88: xori  x17, x1, -1       ; I-type xori (음수 imm)
        rom_file[ 23] = 32'h0100e913;  //  92: ori   x18, x1, 16       ; I-type ori
        rom_file[ 24] = 32'h00f17993;  //  96: andi  x19, x2, 15       ; I-type andi
        rom_file[ 25] = 32'h00309a13;  // 100: slli  x20, x1, 3        ; I-type slli
        rom_file[ 26] = 32'h01c15a93;  // 104: srli  x21, x2, 28       ; I-type srli
        rom_file[ 27] = 32'h40115b13;  // 108: srai  x22, x2, 1        ; I-type srai (instr[30]=1)
        rom_file[ 28] = 32'h003ba023;  // 112: sw    x3, 0(x23)        ; S sw  0x12345000 -> [0x40]
        rom_file[ 29] = 32'h002b9323;  // 116: sh    x2, 6(x23)        ; S sh  0xFFFD     -> [0x46] 상위 half (하위 0x0012 보존 확인)
        rom_file[ 30] = 32'h001b84a3;  // 120: sb    x1, 9(x23)        ; S sb  0x05       -> [0x49] (byte1)
        rom_file[ 31] = 32'h000bac03;  // 124: lw    x24, 0(x23)       ; L lw
        rom_file[ 32] = 32'h006b9c83;  // 128: lh    x25, 6(x23)       ; L lh  (sign)
        rom_file[ 33] = 32'h006bdd03;  // 132: lhu   x26, 6(x23)       ; L lhu (zero)
        rom_file[ 34] = 32'h009b8d83;  // 136: lb    x27, 9(x23)       ; L lb
        rom_file[ 35] = 32'h006bce03;  // 140: lbu   x28, 6(x23)       ; L lbu 0xFD -> 253
        rom_file[ 36] = 32'h00108863;  // 144: beq   x1, x1, +16       ; B beq taken
        rom_file[ 37] = 32'h00000013;  // 148: nop                     ;   (flush 없음: 항상 실행됨)
        rom_file[ 38] = 32'h00000013;  // 152: nop
        rom_file[ 39] = 32'h001f8f93;  // 156: addi  x31, x31, 1       ;   실행되면 에러 (x31++)
        rom_file[ 40] = 32'h00110863;  // 160: beq   x2, x1, +16       ; B beq not-taken
        rom_file[ 41] = 32'h00000013;  // 164: nop
        rom_file[ 42] = 32'h00000013;  // 168: nop
        rom_file[ 43] = 32'h001f6f13;  // 172: ori   x30, x30, 1       ;   실행돼야 정상 (x30 |= 1)
        rom_file[ 44] = 32'h00209863;  // 176: bne   x1, x2, +16       ; B bne taken
        rom_file[ 45] = 32'h00000013;  // 180: nop                     ;   (flush 없음: 항상 실행됨)
        rom_file[ 46] = 32'h00000013;  // 184: nop
        rom_file[ 47] = 32'h001f8f93;  // 188: addi  x31, x31, 1       ;   실행되면 에러 (x31++)
        rom_file[ 48] = 32'h00109863;  // 192: bne   x1, x1, +16       ; B bne not-taken
        rom_file[ 49] = 32'h00000013;  // 196: nop
        rom_file[ 50] = 32'h00000013;  // 200: nop
        rom_file[ 51] = 32'h002f6f13;  // 204: ori   x30, x30, 2       ;   실행돼야 정상 (x30 |= 2)
        rom_file[ 52] = 32'h00114863;  // 208: blt   x2, x1, +16       ; B blt taken
        rom_file[ 53] = 32'h00000013;  // 212: nop                     ;   (flush 없음: 항상 실행됨)
        rom_file[ 54] = 32'h00000013;  // 216: nop
        rom_file[ 55] = 32'h001f8f93;  // 220: addi  x31, x31, 1       ;   실행되면 에러 (x31++)
        rom_file[ 56] = 32'h0020c863;  // 224: blt   x1, x2, +16       ; B blt not-taken
        rom_file[ 57] = 32'h00000013;  // 228: nop
        rom_file[ 58] = 32'h00000013;  // 232: nop
        rom_file[ 59] = 32'h004f6f13;  // 236: ori   x30, x30, 4       ;   실행돼야 정상 (x30 |= 4)
        rom_file[ 60] = 32'h0020d863;  // 240: bge   x1, x2, +16       ; B bge taken
        rom_file[ 61] = 32'h00000013;  // 244: nop                     ;   (flush 없음: 항상 실행됨)
        rom_file[ 62] = 32'h00000013;  // 248: nop
        rom_file[ 63] = 32'h001f8f93;  // 252: addi  x31, x31, 1       ;   실행되면 에러 (x31++)
        rom_file[ 64] = 32'h00115863;  // 256: bge   x2, x1, +16       ; B bge not-taken
        rom_file[ 65] = 32'h00000013;  // 260: nop
        rom_file[ 66] = 32'h00000013;  // 264: nop
        rom_file[ 67] = 32'h008f6f13;  // 268: ori   x30, x30, 8       ;   실행돼야 정상 (x30 |= 8)
        rom_file[ 68] = 32'h0020e863;  // 272: bltu  x1, x2, +16       ; B bltu taken
        rom_file[ 69] = 32'h00000013;  // 276: nop                     ;   (flush 없음: 항상 실행됨)
        rom_file[ 70] = 32'h00000013;  // 280: nop
        rom_file[ 71] = 32'h001f8f93;  // 284: addi  x31, x31, 1       ;   실행되면 에러 (x31++)
        rom_file[ 72] = 32'h00116863;  // 288: bltu  x2, x1, +16       ; B bltu not-taken
        rom_file[ 73] = 32'h00000013;  // 292: nop
        rom_file[ 74] = 32'h00000013;  // 296: nop
        rom_file[ 75] = 32'h010f6f13;  // 300: ori   x30, x30, 16      ;   실행돼야 정상 (x30 |= 16)
        rom_file[ 76] = 32'h00117863;  // 304: bgeu  x2, x1, +16       ; B bgeu taken
        rom_file[ 77] = 32'h00000013;  // 308: nop                     ;   (flush 없음: 항상 실행됨)
        rom_file[ 78] = 32'h00000013;  // 312: nop
        rom_file[ 79] = 32'h001f8f93;  // 316: addi  x31, x31, 1       ;   실행되면 에러 (x31++)
        rom_file[ 80] = 32'h0020f863;  // 320: bgeu  x1, x2, +16       ; B bgeu not-taken
        rom_file[ 81] = 32'h00000013;  // 324: nop
        rom_file[ 82] = 32'h00000013;  // 328: nop
        rom_file[ 83] = 32'h020f6f13;  // 332: ori   x30, x30, 32      ;   실행돼야 정상 (x30 |= 32)
        rom_file[ 84] = 32'h01000eef;  // 336: jal   x29, +16          ; J jal x29, +16   (x29 = pc+4)
        rom_file[ 85] = 32'h00000013;  // 340: nop                     ;   (flush 없음)
        rom_file[ 86] = 32'h00000013;  // 344: nop
        rom_file[ 87] = 32'h001f8f93;  // 348: addi  x31, x31, 1       ;   실행되면 에러
        rom_file[ 88] = 32'h00000b97;  // 352: auipc x23, 0x0          ; x23 = pc
        rom_file[ 89] = 32'h00000013;  // 356: nop                     ; --- RAW 대기 ---
        rom_file[ 90] = 32'h00000013;  // 360: nop
        rom_file[ 91] = 32'h00000013;  // 364: nop
        rom_file[ 92] = 32'h021b8be7;  // 368: jalr  x23, 33(x23)      ; JR jalr x23, 33(x23) -> (pc_auipc+33)&~1
        rom_file[ 93] = 32'h00000013;  // 372: nop                     ;   (flush 없음)
        rom_file[ 94] = 32'h00000013;  // 376: nop
        rom_file[ 95] = 32'h001f8f93;  // 380: addi  x31, x31, 1       ;   실행되면 에러
        rom_file[ 96] = 32'h0000006f;  // 384: jal   x0, +0            ; done: jal x0, 0 (무한 루프)
    end

    assign instr_code = rom_file[instr_raddr[31:2]];  // 4씩 증가

endmodule
