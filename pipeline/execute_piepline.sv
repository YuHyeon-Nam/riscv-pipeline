module execute_pipeline (
    input         clk,
    input         rst,
    input         RegWrite,
    input         ALUSrc,
    input         branch,
    input         jarl_sel,
    input         jal_sel,
    input  [ 2:0] reg_w_src_sel,
    input  [ 3:0] ctl_alu,
    input  [31:0] instr_code,
    input  [31:0] w_data,
    output [31:0] mem_addr,         //RAM address
    output [31:0] mem_wdata         //RAM write data
);

    
endmodule