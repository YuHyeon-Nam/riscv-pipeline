module fetch_pipeline (
    input clk,
    input rst
);

    fetch u_fetch (
        .clk,
        .rst,
        .btaken,
        .imm,
        .jal_sel,
        .jarl_sel,
        .rdata1,
        .instr_raddr,
        .pc_alu_out
    );

endmodule
