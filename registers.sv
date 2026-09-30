`timescale 1ns / 1ps
module register_file (
    // read port 2 write port 1
    input         clk,
    input         rst,
    input         we,      // from control unit
    input  [ 4:0] raddr1,  // instruction code rs 1
    input  [ 4:0] raddr2,  // instruction code rs 2
    input  [ 4:0] waddr,   // instruction code rd
    input  [31:0] wdata,   // alu output
    output [31:0] rdata1,  // to alu a
    output [31:0] rdata2   // to alu b
);
    logic [31:0] reg_file[0:31];

// `ifdef SIMULATION
// initial begin
//     for(int i=0; i<32; i++)begin
//         reg_file[i] = i;
//     end
// end
// `endif

    always_ff @(posedge clk, posedge rst) begin
        // x0 : never write
        if(rst)begin
            reg_file[0] <= 32'd0;
        end else if (we &(waddr!=0)) begin
            reg_file[waddr] <= wdata;
        end
    end

    assign rdata1 = reg_file[raddr1];
    assign rdata2 = reg_file[raddr2];
endmodule
