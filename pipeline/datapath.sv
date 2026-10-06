`timescale 1ns / 1ps
`include "define.vh"

module datapath (
    input         clk,
    input         rst,
    input         reg_file_we,
    input         alu_src_sel,
    input         branch,
    input         jarl_sel,
    input         jal_sel,
    input  [ 2:0] reg_w_src_sel,
    input  [ 3:0] alu_control,
    input  [31:0] instr_code,     // instruction code from ROM
    input  [31:0] d_rdata,
    output [31:0] instr_raddr,    // pc to rom
    output [31:0] d_addr,
    output [31:0] d_wdata
);
    logic [31:0] alu_result, rdata1, rdata2;
    logic [31:0] imm;
    logic [31:0] alu_src_mux_out, mem_alu_result, o_auipc, pc_alu_out;
    logic btaken;

    assign d_addr  = alu_result[31:0];
    assign d_wdata = rdata2;

    register_file u_register_file (
        // read port 2 write port 1
        .clk(clk),
        .rst(rst),
        .we(reg_file_we),
        .raddr1(instr_code[19:15]),
        .raddr2(instr_code[24:20]),
        .waddr(instr_code[11:7]),
        .wdata(mem_alu_result),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );

    mux_2x1 u_alu_src_mux (
        .mux_sel(alu_src_sel),
        .in_0(rdata2),
        .in_1(imm),
        .mux_out(alu_src_mux_out)
    );

    alu u_alu (
        .alu_control(alu_control),
        .a          (rdata1),
        .b          (alu_src_mux_out),
        .alu_result (alu_result),
        .btaken     (btaken)            //branch op
    );

    extend_imm u_extend_imm (
        .instr_code(instr_code),
        .alu_control(alu_control),
        .o_imm(imm)
    );

    mux_4x1 u_mux_mem_alu (
        .mux_sel(reg_w_src_sel),
        .in_0   (alu_result),     //from alu
        .in_1   (d_rdata),        //from data mem
        .in_2   (imm),            //LUI
        .in_3   (o_auipc),        //AUIPC from pc
        .in_4   (pc_alu_out),
        .mux_out(mem_alu_result)  //to reg file
    );

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




module pc_counter (
    input         clk,
    input         rst,
    input         branch,
    input         btaken,
    input         jal_sel,
    input         jarl_sel,
    input  [31:0] imm,
    input  [31:0] rs1,
    // output [31:0] alu_rd,
    output [31:0] o_auipc,
    output [31:0] current_pc,
    output [31:0] pc_alu_out
);
    logic [31:0] alu_pc_next, alu_pc_result, mux_jarl_out;
    logic or_jal;
    assign or_jal = jal_sel | (btaken & branch);
    assign pc_alu_out = alu_pc_next;

    mux_2x1 u_mux_jarl (
        .mux_sel(jarl_sel),
        .in_0(current_pc),
        .in_1(rs1),
        .mux_out(mux_jarl_out)
    );

    alu u_AUIPC (
        .alu_control(4'b0000),
        .a(imm),
        .b(mux_jarl_out),
        .alu_result(o_auipc)
    );

    // //rd를 위한 alu. pc 영향x. pc 계산 로직은 b u j 타입 모두 동일
    // alu u_rd_alu(
    //     .alu_control(4'b0000),
    //     .a(32'd4),
    //     .b(o_auipc),
    //     .alu_result(alu_rd)
    // );

    alu u_pc_alu (
        .alu_control(4'b0000),
        .a(32'd4),
        .b(current_pc),
        .alu_result(alu_pc_next)
    );

    mux_2x1 u_mux_pc (
        .mux_sel(or_jal),
        .in_0(alu_pc_next),
        .in_1(o_auipc),
        .mux_out(alu_pc_result)
    );


    reigster_pc u_register (
        .clk(clk),
        .rst(rst),
        .data_in(alu_pc_result),
        .data_out(current_pc)
    );
endmodule


module reigster_pc (
    input clk,
    input rst,
    input [31:0] data_in,
    output logic [31:0] data_out
);

    logic [31:0] register;

    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            //pc count init for 32'h0000_0000 address
            register <= 32'd0;  //pc counter의 시작주소를 0으로 설정하였기 때문
        end else begin
            register <= data_in;
        end
    end

    assign data_out = register;

endmodule

module mux_2x1 (
    input         mux_sel,
    input  [31:0] in_0,
    input  [31:0] in_1,
    output [31:0] mux_out
);

    assign mux_out = mux_sel ? in_1 : in_0;

endmodule

module mux_4x1 (
    input        [ 2:0] mux_sel,
    input        [31:0] in_0,
    input        [31:0] in_1,
    input        [31:0] in_2,
    input        [31:0] in_3,
    input        [31:0] in_4,
    output logic [31:0] mux_out
);
    always @(*) begin
        mux_out = in_0;  // default
        case (mux_sel)
            3'd0: mux_out = in_0;
            3'd1: mux_out = in_1;
            3'd2: mux_out = in_2;
            3'd3: mux_out = in_3;
            3'd4: mux_out = in_4;
        endcase
    end

endmodule


// module pc_counter (
//     input clk,
//     input rst,
//     output [31:0] instr_raddr
// );
//     logic [31:0] pc_rom;
//     always_ff @( posedge clk, posedge rst ) begin
//         pc_rom <= pc_rom + 32'd4;
//     end
//     alu u_alu(

//     );
//     assign instr_raddr = pc_rom;
// endmodule
