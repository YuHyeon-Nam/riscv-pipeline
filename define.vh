<<<<<<< HEAD
//OP_CODE
`define OP_R 7'b0110011
`define OP_S 7'b0100011
`define OP_I 7'b0010011
`define OP_I_LOAD 7'b0000011
`define OP_B 7'b110_0011
`define OP_UL 7'b0110111
`define OP_UA 7'b0010111
`define OP_JAL 7'b1101111
`define OP_JR 7'b1100111

//R-type, funct7[5], funct3
//I-type
`define ADD 4'b0000
`define SUB 4'b1000
`define SLL 4'b0001
`define SLT 4'b0010
`define SLTU 4'b0011
`define XOR 4'b0100
`define SRL 4'b0101
`define SRA 4'b1101
`define OR 4'b0110
`define AND 4'b0111

//S-type
`define SW 3'b010 //opcode가 다름
`define SH 3'b001
`define SB 3'b000

//I-type
`define SLLI 3'b001
`define SRLI 3'b101
`define SRAI 3'b101

//IL-type
`define LB 3'b000
`define LH 3'b001
`define LW 3'b010
`define LBU 3'b100
`define LHU 3'b101

//B-type
`define BEQ 3'b000
`define BNE 3'b001
`define BLT 3'b100
`define BGE 3'b101
`define BLTU 3'b110
=======
//OP_CODE
`define OP_R 7'b0110011
`define OP_S 7'b0100011
`define OP_I 7'b0010011
`define OP_I_LOAD 7'b0000011
`define OP_B 7'b110_0011
`define OP_UL 7'b0110111
`define OP_UA 7'b0010111
`define OP_JAL 7'b1101111
`define OP_JR 7'b1100111

//R-type, funct7[5], funct3
//I-type
`define ADD 4'b0000
`define SUB 4'b1000
`define SLL 4'b0001
`define SLT 4'b0010
`define SLTU 4'b0011
`define XOR 4'b0100
`define SRL 4'b0101
`define SRA 4'b1101
`define OR 4'b0110
`define AND 4'b0111

//S-type
`define SW 3'b010 //opcode가 다름
`define SH 3'b001
`define SB 3'b000

//I-type
`define SLLI 3'b001
`define SRLI 3'b101
`define SRAI 3'b101

//IL-type
`define LB 3'b000
`define LH 3'b001
`define LW 3'b010
`define LBU 3'b100
`define LHU 3'b101

//B-type
`define BEQ 3'b000
`define BNE 3'b001
`define BLT 3'b100
`define BGE 3'b101
`define BLTU 3'b110
>>>>>>> 4c3220865adb570c56a031b532a319ec6d607256
`define BGEU 3'b111