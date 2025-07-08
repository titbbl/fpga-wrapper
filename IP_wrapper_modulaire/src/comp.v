`timescale 1ns / 1ps
module comparator (
    input  wire [23:0] id_a,
    input  wire [23:0] id_b,
    output wire        match
);
    assign match = (id_a == id_b);
endmodule