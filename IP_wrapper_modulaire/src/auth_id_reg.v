`timescale 1ns / 1ps
module authorized_id_register (
    input  wire        clk,
    input  wire        rst,
    input  wire        wr_en,
    input  wire [23:0] id_in,
    output reg  [23:0] id_out
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            id_out <= 24'd0;
        else if (wr_en)
            id_out <= id_in;
    end
endmodule