`timescale 1ns / 1ps
module max_register (
    input  wire clk,
    input  wire rst,
    input  wire [7:0] count_in,
    output reg  [7:0] max_out
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            max_out <= 8'd0;
        else if (count_in > max_out)
            max_out <= count_in;
    end
endmodule