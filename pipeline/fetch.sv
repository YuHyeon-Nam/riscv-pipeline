module fetch(input clk, 
input rst,
// input branch, //btaken = branch & result
input btaken,
input [31:0] imm,
input jal_sel,
input jarl_sel,
input [31:0] rdata1,
input [31:0] instr_raddr,
output pc_alu_out); 

    pc_counter u_pc_counter (
        .clk(clk),
        .branch(branch),
        .btaken(btaken),
        .rst(rst),
        .imm(imm),
        .jal_sel(jal_sel),
        .jarl_sel(jarl_sel),
        .rs1(rdata1),
        .current_pc(instr_raddr),
        .o_auipc(o_auipc),
        .pc_alu_out(pc_alu_out)
    );
    
endmodule