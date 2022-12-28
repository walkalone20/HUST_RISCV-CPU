`timescale 1ns / 1ps

`include "include.vh"


module CPUBasic_tb();
    logic clk, rst;
    int ledData;
    CPUBasic #(.PATH(`PROG_PATH(test/n3test))) cpu (clk, rst, ledData);
    initial begin
        {rst, clk} = 'b11;
        #1.6 rst = 0;
    end
    always #0.5 clk = ~clk;
endmodule


module CPUBasic #(
    parameter PATH = "",
    parameter SIZE_ROM = 10,
    parameter SIZE_RAM = 10
) (
    input clk, input rst,
    output int ledData, output nHalt,
    int debug
);

    int imm;
    Signal sig;
    int aluRes;
    int nextPC;
    int R1, R2;
    
    int PC, IR;
    Register regPC (clk, rst, nHalt, nextPC, PC);
    ROM #(.PATH(PATH), .SIZE(SIZE_ROM)) rom (PC, IR);
    always @* begin
        if (sig.branch[0] && (sig.branch[1] ^ !aluRes)) nextPC <= PC + (imm << 1);
        else if (sig.irOp == IR_JAL) nextPC <= PC + (imm << 1);
        else if (sig.irOp == IR_JALR) nextPC <= R1 + (imm);
        else nextPC <= PC + 4;
    end

    
    RegAddr rs1, rs2, rd;
    Controller controller (IR, rs1, rs2, rd, imm, sig);
    
    
    int regDin;
    int mem;
    Regfile regfile (
        clk, rst, 1'b1, rd, rs1, rs2, regDin, R1, R2
    );
    always @* begin
        case (sig.srcRegDin)
            1: regDin <= aluRes;
            2: regDin <= mem;
            3: regDin <= PC + 4;
            4: regDin <= imm << 12;
            5: regDin <= PC + (imm << 12);
            default: regDin <= 0;
        endcase
    end
    
    
    ALU alu (
        R1, sig.srcAluB ? imm : R2, sig.aluOp, aluRes
    );
    
    RAM #(.SIZE(SIZE_RAM)) ram (
        clk, rst, sig.store, aluRes, sig.ramMode, R2, mem
    );
    
    Syscall syscall (
        clk, rst, sig.irOp == IR_ECALL, R1, R2, ledData, nHalt
    );
    
    assign debug = PC;
    
endmodule
