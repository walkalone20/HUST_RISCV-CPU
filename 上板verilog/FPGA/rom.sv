`timescale 1ns / 1ps


module ROM #(
    parameter PATH = "",
    parameter SIZE = 10
) (
    input int addr,
    output int dout
);
    int data [1 << SIZE];
    assign dout = data[addr >> 2];
    
    initial begin
        $readmemh(PATH, data);
    end
endmodule

