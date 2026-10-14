module mem (
    input               clk,
    input               rst,
    input               MemWrite,
    input               load_un,
    input        [31:0] w_data,
    input        [ 8:0] mem_addr,  //32bit address
    input        [ 3:0] mem_size,
    output logic [31:0] o_rdata
);
    logic [31:0] mem_wdata;
    logic [31:0] d_rdata;
    logic [ 1:0] byte_offset;
    logic [ 6:0] word_index;
    logic aligned;

    wrappermem u_wrappermem (
        .w_data(w_data),
        .mem_addr(mem_addr),
        .mem_size(mem_size),
        .o_wdata(mem_wdata),
        .word_index(word_index),
        .byte_offset(byte_offset),
        .aligned(aligned)
    );

    data_mem u_data_mem (
        .clk(clk),
        .rst(rst),
        .i_wdata(mem_wdata),
        .MemWrite(MemWrite),
        .aligned(aligned),
        .word_index(word_index),
        .d_rdata(d_rdata)
    );

    load_mem u_load_mem (
        .byte_offset(byte_offset),
        .load_un(load_un),
        .d_rdata(d_rdata),
        .aligned(aligned),
        .mem_size(mem_size),
        .word_index(word_index),
        .o_rdata(o_rdata)
    );


endmodule