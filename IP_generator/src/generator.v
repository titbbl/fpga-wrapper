`timescale 1ns / 1ps

module generator #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
)(
    input  wire clk,
    input  wire rst,

    output reg  [ADDR_WIDTH-1:0] M_AXI_AWADDR,
    output reg                   M_AXI_AWVALID,
    input  wire                  M_AXI_AWREADY,

    output reg  [DATA_WIDTH-1:0] M_AXI_WDATA,
    output reg                   M_AXI_WVALID,
    input  wire                  M_AXI_WREADY,

    input  wire [1:0]            M_AXI_BRESP,
    input  wire                  M_AXI_BVALID,
    output reg                   M_AXI_BREADY
);

    localparam IDLE  = 2'd0,
               ADDR  = 2'd1,
               DATA  = 2'd2,
               RESP  = 2'd3;

    reg [1:0] state = IDLE;
    reg [31:0] id_counter = 32'h00001230;
    reg [26:0] delay_counter = 0;

    localparam [ADDR_WIDTH-1:0] WRAPPER_REG1_ADDR = 32'h40000004;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state          <= IDLE;
            id_counter     <= 32'h00001230;
            delay_counter  <= 0;

            M_AXI_AWADDR   <= WRAPPER_REG1_ADDR;
            M_AXI_AWVALID  <= 0;
            M_AXI_WDATA    <= 0;
            M_AXI_WVALID   <= 0;
            M_AXI_BREADY   <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (delay_counter == 27'd100_000_000) begin
                        M_AXI_AWADDR   <= WRAPPER_REG1_ADDR;
                        M_AXI_AWVALID  <= 1;
                        state          <= ADDR;
                    end else begin
                        delay_counter <= delay_counter + 1;
                    end
                end

                ADDR: begin
                    if (M_AXI_AWREADY) begin
                        M_AXI_AWVALID  <= 0;
                        M_AXI_WDATA    <= id_counter;
                        M_AXI_WVALID   <= 1;
                        state          <= DATA;
                    end
                end

                DATA: begin
                    if (M_AXI_WREADY) begin
                        M_AXI_WVALID   <= 0;
                        M_AXI_BREADY   <= 1;
                        state          <= RESP;
                    end
                end

                RESP: begin
                    if (M_AXI_BVALID) begin
                        M_AXI_BREADY   <= 0;
                        id_counter     <= id_counter + 1;
                        delay_counter  <= 0;
                        state          <= IDLE;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
