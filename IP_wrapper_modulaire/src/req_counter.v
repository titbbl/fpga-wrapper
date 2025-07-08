`timescale 1ns / 1ps
module counter (
    input  wire clk,
    input  wire rst,
    input  wire en,
    output reg  [7:0] count
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 8'd0;
        else if (en)
            count <= count + 1;
    end
endmodule