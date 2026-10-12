module decode (
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] instr_code,
    input  logic [31:0] wdata,
    output logic        branch,
    output logic        MemRead,
    output logic        MemtoReg,
    output logic        MemWrite,
    output logic        ALUSrc,
    output logic        jal_sel,
    output logic        jarl_sel,
    output logic [ 3:0] st_size,
    output logic        load_u,
    output logic [31:0] rdata1,
    output logic [31:0] rdata2
);

  logic RegWrite;
  logic funct3;
  logic btaken;

  control_unit u_control_unit (
      .opcode(instr_code[6:0]),
      .branch(branch),
      .reg_w_src_sel,
      .aui,
      .lui,
      .MemRead(MemRead),
      .MemtoReg(MemtoReg),
      .MemWrite(MemWrite),
      .ALUSrc(ALUSrc),
      .RegWrite(RegWrite),
      .jal_sel(jal_sel),
      .jarl_sel(jarl_sel),
      .st_size(st_size),
      .load_u(load_u)
  );


  register_file u_register_file (
      // read port 2 write port 1
      .clk(clk),
      .rst(rst),
      .we(RegWrite),
      .r_reg1(instr_code[19:15]),
      .r_reg2(instr_code[24:20]),
      .w_reg(instr_code[11:7]),
      .wdata(wdata),
      .rdata1(rdata1),
      .rdata2(rdata2)
  );

  extend_imm u_extend_imm (
      .instr_code(instr_code),
      .o_imm(imm)
  );
endmodule
