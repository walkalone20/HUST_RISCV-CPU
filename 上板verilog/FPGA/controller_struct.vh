typedef enum logic [5:0] {
    IR_NOP,
    IR_ADD,
    IR_SUB,
    IR_SLL,
    IR_SLT,
    IR_SLTU,
    IR_XOR,
    IR_SRL,
    IR_SRA,
    IR_OR,
    IR_AND,
    IR_ADDI,
    IR_SLLI,
    IR_SLTI,
    IR_SLTIU,
    IR_XORI,
    IR_SRLI,
    IR_SRAI,
    IR_ORI,
    IR_ANDI,
    IR_SB,
    IR_SH,
    IR_SW,
    IR_LB,
    IR_LH,
    IR_LW,
    IR_LBU,
    IR_LHU,
    IR_BEQ,
    IR_BNE,
    IR_BLT,
    IR_BGE,
    IR_BLTU,
    IR_BGEU,
    IR_JAL,
    IR_JALR,
    IR_LUI,
    IR_AUIPC,
    IR_ECALL,
    IR_URET,
    IR_CSRRSI,
    IR_CSRRCI
} InstrOp;


typedef enum logic [3:0] {
    IR_TYPE_R,
    IR_TYPE_I,
    IR_TYPE_S,
    IR_TYPE_B,
    IR_TYPE_U,
    IR_TYPE_J
} InstrType;


typedef struct packed {
    InstrOp irOp;
    InstrType irType;
    AluOp aluOp;
    logic rs1, rs2;
    logic [2:0] srcRegDin;
    logic srcAluB;
    logic [1:0] branch;
    logic store, load;
    logic [2:0] ramMode;
} Signal;