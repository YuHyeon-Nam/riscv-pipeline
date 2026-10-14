module decode_pipeline (
    input  logic        clk,
    input  logic        rst,
    input  logic [31:0] instr_code_f,
    input  logic [31:0] c_pc_f,
    input  logic [31:0] rdata1,
    input  logic [31:0] rdata2,
    input  logic [31:0] imm,
    input  logic [ 2:0] wb_sel,
    input  logic        branch,
    input  logic        MemRead,
    input  logic        MemtoReg,
    input  logic        MemWrite,
    input  logic        ALUSrc,
    input  logic        RegWrite,
    input  logic        jal_sel,
    input  logic        jarl_sel,
    input  logic        aui,
    input  logic        mem_size,
    input  logic        load_un,
    output logic [31:0] instr_code_d,
    output logic [31:0] c_pc_d,
    output logic [31:0] rdata1_d,
    output logic [31:0] rdata2_d,
    output logic [31:0] imm_d,
    output logic [ 2:0] wb_sel_d,
    output logic        branch_d,
    output logic        MemRead_d,
    output logic        MemtoReg_d,
    output logic        MemWrite_d,    // data memory
    output logic        ALUSrc_d,
    output logic        RegWrite_d,
    output logic        jal_sel_d,
    output logic        jarl_sel_d,
    output logic        aui_d,
    output logic        mem_size_d,
    output logic        load_un_d
);

    always_ff @(posedge clk) begin
        if (rst) begin
            instr_code_d <= '0;
            c_pc_d       <= '0;
            rdata1_d     <= '0;
            rdata2_d     <= '0;
            imm_d        <= '0;
            wb_sel_d     <= '0;
            branch_d     <= '0;
            MemRead_d    <= '0;
            MemtoReg_d   <= '0;
            MemWrite_d   <= '0;
            ALUSrc_d     <= '0;
            RegWrite_d   <= '0;
            jal_sel_d    <= '0;
            jarl_sel_d   <= '0;
            aui_d        <= '0;
            mem_size_d   <= '0;
            load_un_d    <= '0;
        end else begin
            instr_code_d <= instr_code_f;
            c_pc_d       <= c_pc_f;
            rdata1_d     <= rdata1;
            rdata2_d     <= rdata2;
            imm_d        <= imm;
            wb_sel_d     <= wb_sel;
            branch_d     <= branch;
            MemRead_d    <= MemRead;
            MemtoReg_d   <= MemtoReg;
            MemWrite_d   <= MemWrite;
            ALUSrc_d     <= ALUSrc;
            RegWrite_d   <= RegWrite;
            jal_sel_d    <= jal_sel;
            jarl_sel_d   <= jarl_sel;
            aui_d        <= aui;
            mem_size_d   <= mem_size;
            load_un_d    <= load_un;
        end
    end

endmodule
