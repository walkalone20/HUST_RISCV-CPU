`timescale 1ns / 1ps


module RAM #(
    parameter SIZE = 10
) (
    input clk, input rst, input we,
    input int addr, input [2:0] mode,
    input int din, output int dout
);
    int data [1 << SIZE];
    
    always @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < (1 << SIZE); ++i) data[i] <= 0;
        end
        else if (we) case(mode[1:0])
            0: case (addr[1:0])
                3: data[addr>>2][31:24] <= din[7:0];
                2: data[addr>>2][23:16] <= din[7:0];
                1: data[addr>>2][15:8] <= din[7:0];
                default: data[addr>>2][7:0] <= din[7:0];
            endcase
            1: case (addr[1])
                1: data[addr>>2][31:16] <= din[15:0];
                default: data[addr>>2][15:0] <= din[15:0];
            endcase
            default: data[addr>>2] <= din[31:0];
        endcase
    end
    
    always @* begin
        case(mode)
            0: case (addr[1:0])
                3: dout <= signed'(data[addr>>2][31:24]);
                2: dout <= signed'(data[addr>>2][23:16]);
                1: dout <= signed'(data[addr>>2][15:8]);
                default: dout <= signed'(data[addr>>2][7:0]);
            endcase
            1: case (addr[1])
                1: dout <= signed'(data[addr>>2][31:16]);
                default: dout <= signed'(data[addr>>2][15:0]);
            endcase
            4: case (addr[1:0])
                3: dout <= data[addr>>2][31:24];
                2: dout <= data[addr>>2][23:16];
                1: dout <= data[addr>>2][15:8];
                default: dout <= data[addr>>2][7:0];
            endcase
            5: case (addr[1])
                1: dout <= data[addr>>2][31:16];
                default: dout <= data[addr>>2][15:0];
            endcase
            default: dout <= data[addr>>2];
        endcase
    end
    
endmodule