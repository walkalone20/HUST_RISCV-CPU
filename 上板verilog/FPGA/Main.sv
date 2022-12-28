`timescale 1ns / 1ps

`include "include.vh"


module Clock #(
    parameter T = 27
) (
    input rawClk,
    output clk
);
    int cnt;
    assign clk = cnt[T];
    always @(posedge rawClk) cnt <= cnt + 1;
endmodule

module SegDecoder (
    input [3:0] digit,
    output bit [7:0] seg
);
    always @* begin
        case (digit)
            4'b0000 : seg[7:0] <= 8'b11000000;
            4'b0001 : seg[7:0] <= 8'b11111001;
            4'b0010 : seg[7:0] <= 8'b10100100;
            4'b0011 : seg[7:0] <= 8'b10110000;
            4'b0100 : seg[7:0] <= 8'b10011001;
            4'b0101 : seg[7:0] <= 8'b10010010;
            4'b0110 : seg[7:0] <= 8'b10000010;
            4'b0111 : seg[7:0] <= 8'b11111000;
            4'b1000 : seg[7:0] <= 8'b10000000;
            4'b1001 : seg[7:0] <= 8'b10011000;
            4'b1010 : seg[7:0] <= 8'b10001000;
            4'b1011 : seg[7:0] <= 8'b10000011;
            4'b1100 : seg[7:0] <= 8'b11000110;
            4'b1101 : seg[7:0] <= 8'b10100001;
            4'b1110 : seg[7:0] <= 8'b10000110;
            default : seg[7:0] <= 8'b10001110;
        endcase
    end
endmodule

module HexDisplay #(
    parameter T = 16
) (
    input rawClk,
    input int num,
    output bit [7:0] an,
    output [7:0] seg
);
    bit clk;
    Clock #(.T(T)) clkDiv (rawClk, clk);
    
    int pos;
    bit [3:0] digit;
    SegDecoder decoder (digit, seg);
    
    always @(posedge clk) begin
        pos <= pos == 7? 0 : pos + 1;
        an <= ~(1 << pos);
        digit <= num >> (pos << 2);
    end
endmodule

module Main(
    input CLK100MHZ,
    input RESETN,
    input [15:0] SW,
    input [4:0] BTN,
    
    inout PS2_CLK,
    inout PS2_DATA,
    
    output [7:0] AN,
    output [7:0] SEG,
    output [15:0] LED
);

    int intReq;
    
    
    // BUTTON INT (0~9)
    assign intReq[9:0] = {
        !BTN[4], BTN[4],
        !BTN[3], BTN[3],
        !BTN[2], BTN[2],
        !BTN[1], BTN[1],
        !BTN[0], BTN[0]
    };
    
    
    // CLOCK INT (10)
    bit clockInt;
    assign intReq[10] = clockInt;
    int cnt;
    always @(posedge CLK100MHZ) begin
        if (cnt < 50_000) cnt <= cnt + 1;
        else begin
            cnt <= 0;
            clockInt <= !clockInt;
        end
    end 
        
    // LED
    int ledData;
    HexDisplay #(.T(16)) display (CLK100MHZ, ledData, AN, SEG);
    
    
    
    // CPU
    bit clk, rst, nHalt;
    assign rst = !RESETN;
    Clock #(.T(2)) clkDiv (CLK100MHZ, clk);
    CPUPipeline #(.PATH(`PROG_PATH(test/main)), .SIZE_RAM(7)) cpu (
        clk, rst, intReq,
        keyInfo,
        ledData, nHalt, LED[15:1]
    );
    
    assign LED[0] = nHalt;
endmodule
