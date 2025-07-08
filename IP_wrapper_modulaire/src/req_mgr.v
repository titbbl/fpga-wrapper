`timescale 1ns / 1ps
module comparator_max (
    input  wire [7:0] a,
    input  wire [7:0] b,
    output wire       equal
);
    assign equal = (a == b);
endmodule