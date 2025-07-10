`timescale 1 ns / 1 ps
module monitor (
    input  wire clk,
    input  wire rst,
    input  wire match,
    output reg  access_granted,
    output reg  access_denied,
    output reg  irq_flag
);

    reg [3:0] fail_count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            access_granted <= 0;
            access_denied  <= 0;
            irq_flag       <= 0;
            fail_count     <= 0;
        end else begin
            if (match) begin
                access_granted <= 1;
                access_denied  <= 0;
                fail_count     <= 0;
                irq_flag       <= 0;
            end else begin
                access_granted <= 0;
                access_denied  <= 1;
                if (fail_count >= 3)
                    irq_flag <= 1;
                else
                    fail_count <= fail_count + 1;
            end
        end
    end

endmodule

