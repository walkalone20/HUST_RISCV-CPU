`timescale 1ns / 1ps


`include "controller_struct.vh"
`include "controller_def.vh"


module ControllerTB ();
    int ir;
    RegAddr rs1, rs2, rd;
    int imm;
    Signal sig;

    Controller dut(ir, rs1, rs2, rd, imm, sig);
    initial begin
        ir = 0;
        #1 ir = 'h00c10693;
        #1 ir = 0;
        #1 ir = 'h00000013;
        #1 ir = 'h00000001;
    end
endmodule


module Controller (
    input int ir,
    output RegAddr rs1, output RegAddr rs2, output RegAddr rd,
    output int imm,
    output Signal sig
);
    assign sig =
        (ir & `IR_MASK_ADD) == `IR_FRMT_ADD ?       `IR_CTRL_ADD :
        (ir & `IR_MASK_ADD) == `IR_FRMT_ADD ?       `IR_CTRL_ADD :
        (ir & `IR_MASK_SUB) == `IR_FRMT_SUB ?       `IR_CTRL_SUB :
        (ir & `IR_MASK_SLL) == `IR_FRMT_SLL ?       `IR_CTRL_SLL :
        (ir & `IR_MASK_SLT) == `IR_FRMT_SLT ?       `IR_CTRL_SLT :
        (ir & `IR_MASK_SLTU) == `IR_FRMT_SLTU ?     `IR_CTRL_SLTU :
        (ir & `IR_MASK_XOR) == `IR_FRMT_XOR ?       `IR_CTRL_XOR :
        (ir & `IR_MASK_SRL) == `IR_FRMT_SRL ?       `IR_CTRL_SRL :
        (ir & `IR_MASK_SRA) == `IR_FRMT_SRA ?       `IR_CTRL_SRA :
        (ir & `IR_MASK_OR) == `IR_FRMT_OR ?         `IR_CTRL_OR :
        (ir & `IR_MASK_AND) == `IR_FRMT_AND ?       `IR_CTRL_AND :
        (ir & `IR_MASK_ADDI) == `IR_FRMT_ADDI ?     `IR_CTRL_ADDI :
        (ir & `IR_MASK_SLLI) == `IR_FRMT_SLLI ?     `IR_CTRL_SLLI :
        (ir & `IR_MASK_SLTI) == `IR_FRMT_SLTI ?     `IR_CTRL_SLTI :
        (ir & `IR_MASK_SLTIU) == `IR_FRMT_SLTIU ?   `IR_CTRL_SLTIU :
        (ir & `IR_MASK_XORI) == `IR_FRMT_XORI ?     `IR_CTRL_XORI :
        (ir & `IR_MASK_SRLI) == `IR_FRMT_SRLI ?     `IR_CTRL_SRLI :
        (ir & `IR_MASK_SRAI) == `IR_FRMT_SRAI ?     `IR_CTRL_SRAI :
        (ir & `IR_MASK_ORI) == `IR_FRMT_ORI ?       `IR_CTRL_ORI :
        (ir & `IR_MASK_ANDI) == `IR_FRMT_ANDI ?     `IR_CTRL_ANDI :
        (ir & `IR_MASK_SB) == `IR_FRMT_SB ?         `IR_CTRL_SB :
        (ir & `IR_MASK_SH) == `IR_FRMT_SH ?         `IR_CTRL_SH :
        (ir & `IR_MASK_SW) == `IR_FRMT_SW ?         `IR_CTRL_SW :
        (ir & `IR_MASK_LB) == `IR_FRMT_LB ?         `IR_CTRL_LB :
        (ir & `IR_MASK_LH) == `IR_FRMT_LH ?         `IR_CTRL_LH :
        (ir & `IR_MASK_LW) == `IR_FRMT_LW ?         `IR_CTRL_LW :
        (ir & `IR_MASK_LBU) == `IR_FRMT_LBU ?       `IR_CTRL_LBU :
        (ir & `IR_MASK_LHU) == `IR_FRMT_LHU ?       `IR_CTRL_LHU :
        (ir & `IR_MASK_BEQ) == `IR_FRMT_BEQ ?       `IR_CTRL_BEQ :
        (ir & `IR_MASK_BNE) == `IR_FRMT_BNE ?       `IR_CTRL_BNE :
        (ir & `IR_MASK_BLT) == `IR_FRMT_BLT ?       `IR_CTRL_BLT :
        (ir & `IR_MASK_BGE) == `IR_FRMT_BGE ?       `IR_CTRL_BGE :
        (ir & `IR_MASK_BLTU) == `IR_FRMT_BLTU ?     `IR_CTRL_BLTU :
        (ir & `IR_MASK_BGEU) == `IR_FRMT_BGEU ?     `IR_CTRL_BGEU :
        (ir & `IR_MASK_JAL) == `IR_FRMT_JAL ?       `IR_CTRL_JAL :
        (ir & `IR_MASK_JALR) == `IR_FRMT_JALR ?     `IR_CTRL_JALR :
        (ir & `IR_MASK_LUI) == `IR_FRMT_LUI ?       `IR_CTRL_LUI :
        (ir & `IR_MASK_AUIPC) == `IR_FRMT_AUIPC ?   `IR_CTRL_AUIPC :
        (ir & `IR_MASK_ECALL) == `IR_FRMT_ECALL ?   `IR_CTRL_ECALL :
        (ir & `IR_MASK_URET) == `IR_FRMT_URET ?     `IR_CTRL_URET :
        (ir & `IR_MASK_CSRRSI) == `IR_FRMT_CSRRSI ? `IR_CTRL_CSRRSI :
        (ir & `IR_MASK_CSRRCI) == `IR_FRMT_CSRRCI ? `IR_CTRL_CSRRCI :
        `IR_CTRL_NOP;
        
    assign rs1 = sig.rs1? (sig.irOp == IR_ECALL ? 'h11 : ir[19:15]) : 0;
    assign rs2 = sig.rs2? (sig.irOp == IR_ECALL ? 'h0a : ir[24:20]) : 0;
    assign rd = sig.srcRegDin? (sig.irOp == IR_ECALL ? 'h0b : ir[11:7]) : 0;
    
    assign imm =
        sig.irType == IR_TYPE_I ? signed'(ir[31:20]) :
        sig.irType == IR_TYPE_S ? signed'({ir[31:25], ir[11:7]}) :
        sig.irType == IR_TYPE_B ? signed'({ir[31], ir[7], ir[30:25], ir[11:8]}) :
        sig.irType == IR_TYPE_U ? signed'(ir[31:12]) :
        sig.irType == IR_TYPE_J ? signed'({ir[31], ir[19:12], ir[20], ir[30:21]}) : 0;
endmodule


