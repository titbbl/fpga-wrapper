`timescale 1ns / 1ps

module wrapper (
    input  wire        clk,
    input  wire        rst,

    input  wire [31:0] id_fixed,
    input  wire [31:0] id_dynamic,
    input  wire        req_valid,

    output reg         access_granted,
    output reg         access_denied,
    output reg         irq_flag
);

    reg [1:0] irq_counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            access_granted <= 0;
            access_denied  <= 0;
            irq_flag       <= 0;
            irq_counter    <= 0;
        end else begin
            if (id_fixed == id_dynamic) begin
                access_granted <= 1;
                access_denied  <= 0;
                irq_flag       <= 0;
                irq_counter    <= 0;
            end else begin
                access_granted <= 0;
                access_denied  <= 1;

                if (irq_counter == 2) begin
                    irq_flag    <= 1;
                    irq_counter <= 0;
                end else begin
                    irq_flag    <= 0;
                    irq_counter <= irq_counter + 1;
                end
            end
        end
    end

endmodule

