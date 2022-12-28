`timescale 1ns / 1ps

`include "include.vh"


module CPUPipeline_tb();
    logic clk, rst, nHalt;
    int intr;
    int ledData, mouse;
    CPUPipeline #(.PATH(`PROG_PATH(test/main))) cpu (
        clk, rst, intr,
        // IN
        mouse,
        // OUT
        ledData, nHalt
    );
    initial begin
        {rst, clk} = 'b00011;
        #1 rst = 0;
        #58 intr = 'h800; mouse = 'h12345678;
        #2 intr = 0;
    end
    always #0.5 clk = ~clk;
endmodule


`define CONNECT(STAGE, CLR, EN, IN) \
    PiplineReg``STAGE STAGE; \
    PipelineReg #($bits(PiplineReg``STAGE)) pipReg``STAGE \
        (clk, rst, CLR, EN, IN, STAGE);

module LUController (
    input RegAddr rs1, input RegAddr rs2,
    input RegAddr EXrd, input RegAddr MEMrd,
    input EXload,
    output [1:0] fwdR1, output [1:0] fwdR2,
    output loadUse
);
    logic EXconf1, EXconf2, MEMconf1, MEMconf2;
    assign EXconf1 = rs1 && rs1 == EXrd;
    assign EXconf2 = rs2 && rs2 == EXrd;
    assign MEMconf1 = rs1 && rs1 == MEMrd;
    assign MEMconf2 = rs2 && rs2 == MEMrd;
    assign loadUse = (EXconf1 || EXconf2) && EXload;
    assign fwdR1 = EXconf1? 2: MEMconf1? 1: 0;
    assign fwdR2 = EXconf2? 2: MEMconf2? 1: 0;
endmodule


module BTB #(
    parameter SIZE = 8
) (
    input clk, input rst,
    
    // used for update
    input EXIsBranch,
    input int EXPC,
    input int EXNextPC,
    input EXJump,
    
    // used for predict
    input int IFPC,
    output int IFBranchPC,
    output logic IFPredJump
);
    
    int PC [SIZE];
    int nextPC [SIZE];
    // 11 -> 10 -> 00
    // 00 -> 01 -> 11
    bit [1:0] status [SIZE];
    int unsigned LRU [SIZE];

    initial begin
        for (int i = 0; i < SIZE; ++i) begin
            {nextPC[i], status[i]} = 0;
            PC[i] = -1;
            LRU[i] = -1;
        end
    end

    always @* begin
        automatic int index = -1;
        for (int i = 0; i < SIZE; ++i) begin
            if (IFPC == PC[i]) index &= i;
        end
        if (index == -1) begin
            IFBranchPC = 0;
            IFPredJump = 0;
        end
        else begin
            IFBranchPC = nextPC[index];
            IFPredJump = status[index][1];
        end
    end
    
    always @(posedge clk) begin
        automatic int index = -1;
        
        if (rst) begin
            for (int i = 0; i < SIZE; ++i) begin
                {nextPC[i], status[i]} = 0;
                PC[i] = -1;
                LRU[i] = -1;
            end
        end
        else if (EXIsBranch) begin
            for (int i = 0; i < SIZE; ++i) begin
                if (LRU[i] != -1) ++LRU[i];
                if (EXPC == PC[i]) index &= i;
            end
            if (index == -1) begin
                // not found
                if (EXJump) begin
                    // allocate
                    index = 0;
                    for (int i = 1; i < SIZE; ++i) begin
                        if (LRU[i] > LRU[index]) index = i;
                    end
                    
                    // update
                    PC[index] = EXPC;
                    nextPC[index] = EXNextPC;
                    LRU[index] = 0;
                    status[index] = 'b10;
                end
            end
            else begin
                // found
                LRU[index] = 0;
                if (EXJump) begin
                    case (status[index])
                        'b10: status[index] = 'b11;
                        'b01: status[index] = 'b11;
                        'b00: status[index] = 'b01;
                    endcase
                end
                else begin
                    case (status[index])
                        'b10: status[index] = 'b00;
                        'b01: status[index] = 'b00;
                        'b11: status[index] = 'b10;
                    endcase
                end
            end
        end
    end
endmodule


module IntController (
    input clk, input rst,
    input int req, input int clr,
    output int ir
);
    int irWait;
    int reqStatus;
    
    always @(posedge clk) begin
        if (rst) {reqStatus, irWait, ir} <= 0;
        else for (int i = 0; i < 32; ++i) begin
            if (clr[i]) ir[i] <= 0;
            else if (irWait[i]) {irWait[i], ir[i]} <= 'b01;
            
            if (req[i] && !reqStatus[i]) begin
                irWait[i] <= 1;
                reqStatus[i] <= 1;
            end
            else if (!req[i]) reqStatus[i] <= 0;
        end
    end
endmodule


module CPUPipeline #(
    parameter PATH = "",
    parameter SIZE_ROM = 10,
    parameter SIZE_RAM = 10,
    parameter SIZE_BTB = 8
) (
    input clk, input rst,
    input int intReq,
    // IN
    input int keyInfo,
    // OUT
    output int ledData, output nHalt,
    output int debug
);

    // IF
    int PC, IR;
    int realPC, predPC, nextPC;
    logic predJump;
    int branchPC;
    
    // ID
    Signal sig;
    int regDin;
    int R1, R2, imm;
    RegAddr rs1, rs2, rd;
    logic [1:0] fwdR1, fwdR2;
    logic loadUse;
    
    // EX
    int aluRes;
    int realR1, realR2;
    logic isBranch, jump, predSuccess;
    
    // MEM
    int mem;
    
    // WB
    int eret;
    
    
    // `CONNECT(stage, clr, en, in)
    logic bubble;
    `CONNECT(ID, bubble, nHalt && !loadUse, {PC, IR, predJump});
    `CONNECT(EX, loadUse || bubble, nHalt, {ID.PC, ID.IR, sig, rd, R1, R2, imm, fwdR1, fwdR2, ID.predJump});
    `CONNECT(MEM, 1'b0, nHalt, {EX.PC, EX.IR, EX.sig, EX.rd, realR1, realR2, EX.imm, aluRes});
    `CONNECT(WB, 1'b0, nHalt, {MEM.PC, MEM.IR, MEM.sig, MEM.rd, MEM.R1, MEM.R2, MEM.imm, MEM.aluRes, mem});
    
    
    // LoadUse & BTB
    LUController luCtrl (
        rs1, rs2, EX.rd, MEM.rd,
        EX.sig.load || EX.sig.irOp == IR_ECALL,
        fwdR1, fwdR2, loadUse
    );
    BTB #(.SIZE(SIZE_BTB)) btb (
        clk, rst,
        isBranch, EX.PC, realPC, jump,
        PC, branchPC, predJump
    );
    assign predPC = predJump ? branchPC : PC + 4;
    
    
    // Interupt
    int EPC, IE, intAddr;
    int intID;
    logic intLoad, intRet;
    
    assign bubble = !predSuccess || intLoad || intRet;
    assign intLoad = intID && !IE;
    assign intRet = EX.sig.irOp == IR_URET;
    
    
    int intAcc, intClr;
    assign intClr = intRet ? IE : 0;
    IntController intCtrl0 (clk, rst, intReq, intClr, intAcc);
    
    always @* begin
        if (EX.sig.irOp == IR_NOP) begin
            intID = 0;
            intAddr = 0;
        end
        else begin
            intID = intAcc & -intAcc;
            intAddr = 0;
            for (int i = 0; i < 32; ++i) begin
                if (intID >> i & 1) intAddr |= (i + 1) << 2;
            end
        end
    end
    
    always @(posedge clk) begin
        if (rst || intRet) IE <= 0;
        else if (intLoad) IE <= intID;
        
        if (intLoad) begin
            if (jump) EPC <= realPC;
            else EPC <= EX.PC + 4;
        end
    end
    
    
    // IF
    Register regPC (clk, rst, nHalt, nextPC, PC);
    ROM #(.PATH(PATH), .SIZE(SIZE_ROM)) rom (PC, IR);
    
    always @* begin
        if (jump) predSuccess <= EX.predJump && (ID.PC == realPC);
        else predSuccess <= !EX.predJump;
        
        if (intLoad) nextPC <= intAddr;
        else if (intRet) nextPC <= EPC;
        else if (loadUse) nextPC <= PC;
        else if (predSuccess) nextPC <= predPC;
        else nextPC <= realPC;
        
        if (EX.sig.branch[0]) begin
            isBranch <= 1;
            if (EX.sig.branch[1] ^ !aluRes) begin
                realPC <= EX.PC + (EX.imm << 1);
                jump <= 1;
            end
            else begin
                realPC <= EX.PC + 4;
                jump <= 0;
            end
        end
        else if (EX.sig.irOp == IR_JAL) begin
            isBranch <= 1;
            realPC <= EX.PC + (EX.imm << 1);
            jump <= 1;
        end
        else if (EX.sig.irOp == IR_JALR) begin
            isBranch <= 1;
            realPC <= realR1 + (EX.imm);
            jump <= 1;
        end
        else begin
            isBranch <= 0;
            realPC <= PC + 4;
            jump <= 0;
        end
    end
    
    
    // ID
    Controller controller (ID.IR, rs1, rs2, rd, imm, sig);
    Regfile regfile (
        clk, rst, 1'b1, WB.rd, rs1, rs2, regDin, R1, R2
    );
    always @* begin
        case (WB.sig.srcRegDin)
            1: regDin <= WB.aluRes;
            2: regDin <= WB.mem;
            3: regDin <= WB.PC + 4;
            4: regDin <= WB.imm << 12;
            5: regDin <= WB.PC + (WB.imm << 12);
            6: regDin <= eret;
            default: regDin <= 0;
        endcase
    end
    
    
    // EX
    ALU alu (
        realR1,
        EX.sig.srcAluB ? EX.imm : realR2,
        EX.sig.aluOp, aluRes
    );
    always @* begin
        int MEMRegDin;
        case (MEM.sig.srcRegDin)
            1: MEMRegDin <= MEM.aluRes;
            3: MEMRegDin <= MEM.PC + 4;
            4: MEMRegDin <= MEM.imm << 12;
            5: MEMRegDin <= MEM.PC + (MEM.imm << 12);
            default: MEMRegDin <= 0;
        endcase
        case (EX.fwdR1)
            1: realR1 <= regDin;
            2: realR1 <= MEMRegDin;
            default: realR1 <= EX.R1;
        endcase
        case (EX.fwdR2)
            1: realR2 <= regDin;
            2: realR2 <= MEMRegDin;
            default: realR2 <= EX.R2;
        endcase
    end
    
    
    // MEM
    RAM #(.SIZE(SIZE_RAM)) ram (
        clk, rst, MEM.sig.store,
        MEM.aluRes, MEM.sig.ramMode,
        MEM.R2, mem
    );
    
    
    // WB
    Syscall syscall (
        clk, rst, WB.sig.irOp == IR_ECALL, WB.R1, WB.R2, eret,
        keyInfo,
        ledData, nHalt
    );
    
    assign debug = intAcc;
endmodule