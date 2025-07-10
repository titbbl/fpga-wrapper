`timescale 1 ns / 1 ps
module comparator (
    input  wire [23:0] id_fixed,
    input  wire [23:0] id_dynamic,
    output wire        match
);
    assign match = (id_fixed == id_dynamic);
endmodule