module decode (
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] instr_code,
    input  logic [31:0] w_data,
    input logic RegWrite_w,
    output logic [31:0] rdata1,
    output logic [31:0] rdata2,
    output logic [31:0] imm,
    output logic [ 2:0] wb_sel,
    output logic        branch,
    output logic        MemRead,
    output logic        MemtoReg,
    output logic        MemWrite,    // data memory
    output logic        ALUSrc,
    output logic        RegWrite,
    output logic        jal_sel,
    output logic        jarl_sel,
    output logic        aui,
    output logic        mem_size,
    output logic        load_un
);
  register_file u_register_file (
      // read port 2 write port 1
      .clk(clk),
      .rst(rst),
      .we(RegWrite_w),
      .r_reg1(instr_code[19:15]),
      .r_reg2(instr_code[24:20]),
      .w_reg(instr_code[11:7]),
      .wdata(w_data),
      .rdata1(rdata1),
      .rdata2(rdata2)
  );

  extend_imm u_extend_imm (
      .instr_code(instr_code),
      .o_imm(imm)
  );

  control_unit u_control_unit (
      .opcode  (instr_code[6:0]),
      .branch  (branch),
      .funct3  (instr_code[14:12]),
      .wb_sel  (wb_sel),
      .aui     (aui),
      .MemRead (MemRead),
      .MemtoReg(MemtoReg),
      .MemWrite(MemWrite),           // data memory
      .ALUSrc  (ALUSrc),
      .RegWrite(RegWrite),
      .jal_sel (jal_sel),
      .jarl_sel(jarl_sel),
      .mem_size(mem_size),
      .load_un  (load_un)
  );

endmodule
