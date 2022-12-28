`timescale 1ns / 1ps


typedef bit [4:0] RegAddr;


module Register (
    input clk, input rst, input en,
    input int din,
    output int dout
);
    always @(posedge clk) begin
        if (rst) dout <= 0;
        else if (en) dout <= din;
    end
endmodule


module Regfile (
    input clk, input rst, input we,
    input RegAddr rW, input RegAddr rA, input RegAddr rB,
    input int W, output int A, output int B
);
    localparam REG_NUM = 32;
    int regs [REG_NUM];
    assign A = rA? regs[rA] : 0;
    assign B = rB? regs[rB] : 0;
    
    always @(negedge clk) begin
        if (rst) begin
            regs[1] <= 0;
            regs[2] <= (1 << (7 + 2)) - 4;
            for (int i = 3; i < REG_NUM; ++i) regs[i] <= 0;
        end else if (we) regs[rW] <= W;
    end
endmodule

