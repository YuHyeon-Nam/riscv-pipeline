module datapath_pipeline (
    input logic clk,
    input logic rst
);

    logic [31:0] instr_code;
    logic [31:0] instr_raddr;
    logic btaken;
    logic jal_sel;
    logic rdata1;
    logic pc_alu_out;
    logic PCSrc;

    fetch u_fetch (
        .clk  (clk),
        .rst  (rst),
        .PCSrc(PCSrc),
        .jal_sel,
        .rdata1,
        .instr_raddr,
        .instr_code,
        .pc_alu_out
    );

    decode u_decode (
        .clk,
        .rst,
        .instr_code,
        .w_data,
        .rdata1,
        .rdata2,
        .imm,
        .branch,
        .MemRead,
        .MemtoReg,
        .MemWrite,  // data memory
        .ALUSrc,
        .RegWrite,
        .jal_sel,
        .jarl_sel,
        .mem_size,
        .load_u
    );
    decode_pipeline u_decode_pipeline ();


    execute u_execute (
        .clk,
        .rst,
        .RegWrite,
        .ALUSrc,
        .branch,
        .jarl_sel,
        .jal_sel,
        .reg_w_src_sel,
        .ctl_alu,
        .instr_code,
        .w_data,
        .PCSrc(PCSrc),
        .mem_addr,  //RAM address
        .mem_wdata  //RAM write data
    );

    execute_pipeline u_execute_pipeline (
        .clk,
        .rst,
        .RegWrite,
        .ALUSrc,
        .branch,
        .jarl_sel,
        .jal_sel,
        .reg_w_src_sel,
        .ctl_alu,
        .instr_code,
        .w_data,
        .PCSrc(PCSrc),
        .mem_addr,  //RAM address
        .mem_wdata  //RAM write data
    );

    mem u_mem (
        .clk,
        .rst,
        .MemWrite,
        .load_u,
        .aligned,
        .d_wdata,
        .mem_addr,  //32bit address
        .mem_size,
        .o_rdata
    );

    writeback u_writeback ();

endmodule
