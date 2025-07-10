`timescale 1 ns / 1 ps
module wrapper_logic (
    input  wire        clk,
    input  wire        rst,
    input  wire [31:0] id_fixed,
    input  wire [31:0] id_dynamic,
    output wire        access_granted,
    output wire        access_denied,
    output wire        irq_flag
);

    wire match;

    comparator u_cmp (
        .id_fixed(id_fixed[23:0]),
        .id_dynamic(id_dynamic[23:0]),
        .match(match)
    );

    monitor u_mon (
        .clk(clk),
        .rst(rst),
        .match(match),
        .access_granted(access_granted),
        .access_denied(access_denied),
        .irq_flag(irq_flag)
    );

endmodule

