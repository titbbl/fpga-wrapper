`timescale 1ns / 1ps
module response_manager (
    input  wire clk,
    input  wire rst,
    input  wire legit_hit,
    input  wire max_hit,
    output reg  wrapper_resp_o
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            wrapper_resp_o <= 1'b0;
        else
            wrapper_resp_o <= legit_hit & ~max_hit;
    end
endmodule