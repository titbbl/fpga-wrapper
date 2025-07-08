`timescale 1ns / 1ps

module monitor (
    input  wire        clk,
    input  wire        rst,
    input  wire        match,
    output reg  [7:0]  count,
    output reg  [7:0]  max_value,
    output wire        block
);

    // Incrémentation si non-match
    always @(posedge clk or posedge rst) begin
        if (rst)
            count <= 8'd0;
        else if (~match)
            count <= count + 1;
        else
            count <= 8'd0;
    end

    // Mise à jour de la valeur max atteinte
    always @(posedge clk or posedge rst) begin
        if (rst)
            max_value <= 8'd0;
        else if (count > max_value)
            max_value <= count;
    end

    // Blocage si seuil dépassé
    assign block = (count >= 8'd10); 

endmodule
