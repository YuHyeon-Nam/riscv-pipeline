module decode (
    
);

control_unit u_control_unit(
    .instr_code,
    .funct7,
    .branch,
    .reg_w_src_sel,
    .aui,
    .lui,
    .MemRead,
    .MemtoReg,
    .alu_control,
    .MemWrite,
    .ALUSrc,
    .RegWrite,
    .jal_sel,
    .jarl_sel,
    .st_size,
    .load_u
);
    
endmodule