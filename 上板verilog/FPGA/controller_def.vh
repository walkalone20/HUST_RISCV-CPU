`define IR_CTRL_NOP '{IR_NOP, IR_TYPE_R, ALU_SLL, 0, 0, 0, 0, 0, 0, 0, 0}

`define IR_MASK_ADD 'hfe00707f
`define IR_FRMT_ADD 'h00000033
`define IR_CTRL_ADD '{IR_ADD, IR_TYPE_R, ALU_ADD, 1, 1, 1, 0, 0, 0, 0, 0}
`define IR_MASK_SUB 'hfe00707f
`define IR_FRMT_SUB 'h40000033
`define IR_CTRL_SUB '{IR_SUB, IR_TYPE_R, ALU_SUB, 1, 1, 1, 0, 0, 0, 0, 0}
`define IR_MASK_SLL 'hfe00707f
`define IR_FRMT_SLL 'h00001033
`define IR_CTRL_SLL '{IR_SLL, IR_TYPE_R, ALU_SLL, 1, 1, 1, 0, 0, 0, 0, 0}
`define IR_MASK_SLT 'hfe00707f
`define IR_FRMT_SLT 'h00002033
`define IR_CTRL_SLT '{IR_SLT, IR_TYPE_R, ALU_LT, 1, 1, 1, 0, 0, 0, 0, 0}
`define IR_MASK_SLTU 'hfe00707f
`define IR_FRMT_SLTU 'h00003033
`define IR_CTRL_SLTU '{IR_SLTU, IR_TYPE_R, ALU_LTU, 1, 1, 1, 0, 0, 0, 0, 0}
`define IR_MASK_XOR 'hfe00707f
`define IR_FRMT_XOR 'h00004033
`define IR_CTRL_XOR '{IR_XOR, IR_TYPE_R, ALU_XOR, 1, 1, 1, 0, 0, 0, 0, 0}
`define IR_MASK_SRL 'hfe00707f
`define IR_FRMT_SRL 'h00005033
`define IR_CTRL_SRL '{IR_SRL, IR_TYPE_R, ALU_SRL, 1, 1, 1, 0, 0, 0, 0, 0}
`define IR_MASK_SRA 'hfe00707f
`define IR_FRMT_SRA 'h40005033
`define IR_CTRL_SRA '{IR_SRA, IR_TYPE_R, ALU_SRA, 1, 1, 1, 0, 0, 0, 0, 0}
`define IR_MASK_OR 'hfe00707f
`define IR_FRMT_OR 'h00006033
`define IR_CTRL_OR '{IR_OR, IR_TYPE_R, ALU_OR, 1, 1, 1, 0, 0, 0, 0, 0}
`define IR_MASK_AND 'hfe00707f
`define IR_FRMT_AND 'h00007033
`define IR_CTRL_AND '{IR_AND, IR_TYPE_R, ALU_AND, 1, 1, 1, 0, 0, 0, 0, 0}
`define IR_MASK_ADDI 'h0000707f
`define IR_FRMT_ADDI 'h00000013
`define IR_CTRL_ADDI '{IR_ADDI, IR_TYPE_I, ALU_ADD, 1, 0, 1, 1, 0, 0, 0, 0}
`define IR_MASK_SLLI 'hfe00707f
`define IR_FRMT_SLLI 'h00001013
`define IR_CTRL_SLLI '{IR_SLLI, IR_TYPE_I, ALU_SLL, 1, 0, 1, 1, 0, 0, 0, 0}
`define IR_MASK_SLTI 'h0000707f
`define IR_FRMT_SLTI 'h00002013
`define IR_CTRL_SLTI '{IR_SLTI, IR_TYPE_I, ALU_LT, 1, 0, 1, 1, 0, 0, 0, 0}
`define IR_MASK_SLTIU 'h0000707f
`define IR_FRMT_SLTIU 'h00003013
`define IR_CTRL_SLTIU '{IR_SLTIU, IR_TYPE_I, ALU_LTU, 1, 0, 1, 1, 0, 0, 0, 0}
`define IR_MASK_XORI 'h0000707f
`define IR_FRMT_XORI 'h00004013
`define IR_CTRL_XORI '{IR_XORI, IR_TYPE_I, ALU_XOR, 1, 0, 1, 1, 0, 0, 0, 0}
`define IR_MASK_SRLI 'hfe00707f
`define IR_FRMT_SRLI 'h00005013
`define IR_CTRL_SRLI '{IR_SRLI, IR_TYPE_I, ALU_SRL, 1, 0, 1, 1, 0, 0, 0, 0}
`define IR_MASK_SRAI 'hfe00707f
`define IR_FRMT_SRAI 'h40005013
`define IR_CTRL_SRAI '{IR_SRAI, IR_TYPE_I, ALU_SRA, 1, 0, 1, 1, 0, 0, 0, 0}
`define IR_MASK_ORI 'h0000707f
`define IR_FRMT_ORI 'h00006013
`define IR_CTRL_ORI '{IR_ORI, IR_TYPE_I, ALU_OR, 1, 0, 1, 1, 0, 0, 0, 0}
`define IR_MASK_ANDI 'h0000707f
`define IR_FRMT_ANDI 'h00007013
`define IR_CTRL_ANDI '{IR_ANDI, IR_TYPE_I, ALU_AND, 1, 0, 1, 1, 0, 0, 0, 0}
`define IR_MASK_SB 'h0000707f
`define IR_FRMT_SB 'h00000023
`define IR_CTRL_SB '{IR_SB, IR_TYPE_S, ALU_ADD, 1, 1, 0, 1, 0, 1, 0, 0}
`define IR_MASK_SH 'h0000707f
`define IR_FRMT_SH 'h00001023
`define IR_CTRL_SH '{IR_SH, IR_TYPE_S, ALU_ADD, 1, 1, 0, 1, 0, 1, 0, 1}
`define IR_MASK_SW 'h0000707f
`define IR_FRMT_SW 'h00002023
`define IR_CTRL_SW '{IR_SW, IR_TYPE_S, ALU_ADD, 1, 1, 0, 1, 0, 1, 0, 2}
`define IR_MASK_LB 'h0000707f
`define IR_FRMT_LB 'h00000003
`define IR_CTRL_LB '{IR_LB, IR_TYPE_I, ALU_ADD, 1, 0, 2, 1, 0, 0, 1, 0}
`define IR_MASK_LH 'h0000707f
`define IR_FRMT_LH 'h00001003
`define IR_CTRL_LH '{IR_LH, IR_TYPE_I, ALU_ADD, 1, 0, 2, 1, 0, 0, 1, 1}
`define IR_MASK_LW 'h0000707f
`define IR_FRMT_LW 'h00002003
`define IR_CTRL_LW '{IR_LW, IR_TYPE_I, ALU_ADD, 1, 0, 2, 1, 0, 0, 1, 2}
`define IR_MASK_LBU 'h0000707f
`define IR_FRMT_LBU 'h00004003
`define IR_CTRL_LBU '{IR_LBU, IR_TYPE_I, ALU_ADD, 1, 0, 2, 1, 0, 0, 1, 4}
`define IR_MASK_LHU 'h0000707f
`define IR_FRMT_LHU 'h00005003
`define IR_CTRL_LHU '{IR_LHU, IR_TYPE_I, ALU_ADD, 1, 0, 2, 1, 0, 0, 1, 5}
`define IR_MASK_BEQ 'h0000707f
`define IR_FRMT_BEQ 'h00000063
`define IR_CTRL_BEQ '{IR_BEQ, IR_TYPE_B, ALU_XOR, 1, 1, 0, 0, 1, 0, 0, 0}
`define IR_MASK_BNE 'h0000707f
`define IR_FRMT_BNE 'h00001063
`define IR_CTRL_BNE '{IR_BNE, IR_TYPE_B, ALU_XOR, 1, 1, 0, 0, 3, 0, 0, 0}
`define IR_MASK_BLT 'h0000707f
`define IR_FRMT_BLT 'h00004063
`define IR_CTRL_BLT '{IR_BLT, IR_TYPE_B, ALU_LT, 1, 1, 0, 0, 3, 0, 0, 0}
`define IR_MASK_BGE 'h0000707f
`define IR_FRMT_BGE 'h00005063
`define IR_CTRL_BGE '{IR_BGE, IR_TYPE_B, ALU_LT, 1, 1, 0, 0, 1, 0, 0, 0}
`define IR_MASK_BLTU 'h0000707f
`define IR_FRMT_BLTU 'h00006063
`define IR_CTRL_BLTU '{IR_BLTU, IR_TYPE_B, ALU_LTU, 1, 1, 0, 0, 3, 0, 0, 0}
`define IR_MASK_BGEU 'h0000707f
`define IR_FRMT_BGEU 'h00007063
`define IR_CTRL_BGEU '{IR_BGEU, IR_TYPE_B, ALU_LTU, 1, 1, 0, 0, 1, 0, 0, 0}
`define IR_MASK_JAL 'h0000007f
`define IR_FRMT_JAL 'h0000006f
`define IR_CTRL_JAL '{IR_JAL, IR_TYPE_J, ALU_SLL, 0, 0, 3, 0, 0, 0, 0, 0}
`define IR_MASK_JALR 'h0000707f
`define IR_FRMT_JALR 'h00000067
`define IR_CTRL_JALR '{IR_JALR, IR_TYPE_I, ALU_SLL, 1, 0, 3, 0, 0, 0, 0, 0}
`define IR_MASK_LUI 'h0000007f
`define IR_FRMT_LUI 'h00000037
`define IR_CTRL_LUI '{IR_LUI, IR_TYPE_U, ALU_SLL, 0, 0, 4, 0, 0, 0, 0, 0}
`define IR_MASK_AUIPC 'h0000007f
`define IR_FRMT_AUIPC 'h00000017
`define IR_CTRL_AUIPC '{IR_AUIPC, IR_TYPE_U, ALU_SLL, 0, 0, 5, 0, 0, 0, 0, 0}
`define IR_MASK_ECALL 'hffffffff
`define IR_FRMT_ECALL 'h00000073
`define IR_CTRL_ECALL '{IR_ECALL, IR_TYPE_I, ALU_SLL, 1, 1, 6, 0, 0, 0, 0, 0}
`define IR_MASK_URET 'hffffffff
`define IR_FRMT_URET 'h00200073
`define IR_CTRL_URET '{IR_URET, IR_TYPE_I, ALU_SLL, 0, 0, 0, 0, 0, 0, 0, 0}
`define IR_MASK_CSRRSI 'h0000707f
`define IR_FRMT_CSRRSI 'h00006073
`define IR_CTRL_CSRRSI '{IR_CSRRSI, IR_TYPE_I, ALU_SLL, 0, 0, 0, 0, 0, 0, 0, 0}
`define IR_MASK_CSRRCI 'h0000707f
`define IR_FRMT_CSRRCI 'h00007073
`define IR_CTRL_CSRRCI '{IR_CSRRCI, IR_TYPE_I, ALU_SLL, 0, 0, 0, 0, 0, 0, 0, 0}
