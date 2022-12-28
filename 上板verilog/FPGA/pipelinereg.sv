`timescale 1ns / 1ps


module PipelineReg #(
    parameter WDATA
) (
    input clk, input rst, input clr, input en,
    input [WDATA-1:0] din,
    output bit [WDATA-1:0] dout
);
    always @(posedge clk) begin
        if (clr || rst) dout <= 0;
        else if (en) dout <= din;
    end
endmodule


typedef struct packed {
    int PC, IR;
    logic predJump;
} PiplineRegID;

typedef struct packed {
    int PC, IR;
    Signal sig;
    RegAddr rd;
    int R1, R2, imm;
    logic [1:0] fwdR1, fwdR2;
    logic predJump;
} PiplineRegEX;

typedef struct packed {
    int PC, IR;
    Signal sig;
    RegAddr rd;
    int R1, R2, imm;
    int aluRes;
} PiplineRegMEM;

typedef struct packed {
    int PC, IR;
    Signal sig;
    RegAddr rd;
    int R1, R2, imm;
    int aluRes;
    int mem;
} PiplineRegWB;