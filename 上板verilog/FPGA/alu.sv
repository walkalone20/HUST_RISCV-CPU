`timescale 1ns / 1ps


typedef enum logic [3:0] {
    ALU_SLL,
    ALU_SRA,
    ALU_SRL,
    ALU_MUL,
    ALU_DIV,
    ALU_ADD,
    ALU_SUB,
    ALU_AND,
    ALU_OR,
    ALU_XOR,
    ALU_LT,
    ALU_LTU
} AluOp;


module ALU (
    input int A, input int B, input AluOp S,
    output longint R
);
    
    always @* begin
        case (S)
            ALU_SLL: R <= A << B[4:0];
            ALU_SRA: R <= A >>> B[4:0];
            ALU_SRL: R <= unsigned'(A) >> B[4:0];
            ALU_MUL: R <= A * B;
            ALU_DIV: R <= {A % B, A / B};
            ALU_ADD: R <= A + B;
            ALU_SUB: R <= A - B;
            ALU_AND: R <= A & B;
            ALU_OR:  R <= A | B;
            ALU_XOR: R <= A ^ B;
            ALU_LT:  R <= A < B;
            ALU_LTU: R <= unsigned'(A) < unsigned'(B);
            default: R <= 0;
        endcase
    end
endmodule

