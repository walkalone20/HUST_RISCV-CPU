`timescale 1ns / 1ps


module Syscall (
    input clk, input rst, input ecall,
    input int A, input int B,
    output int eret,
    // IN
    input int mouseInfo,
    // OUT
    output int ledData, output bit nHalt
);
    initial nHalt <= 1;
    always @(posedge clk) begin
        if (rst) {ledData, nHalt} <= 1;
        else if (ecall) case (A)
            'h0a: nHalt <= 0;
            'h22: ledData <= B;
        endcase
    end
    always @* begin
        case (A)
            'h80: eret <= mouseInfo;
            default: eret <= 0;
        endcase
    end
endmodule

