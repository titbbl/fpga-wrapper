`timescale 1 ns / 1 ps
module myipwrapper_v1_0_S01_AXI #(
    parameter integer C_S_AXI_DATA_WIDTH = 32,
    parameter integer C_S_AXI_ADDR_WIDTH = 5
)(
    input  wire                          S_AXI_ACLK,
    input  wire                          S_AXI_ARESETN,
    input  wire [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_AWADDR,
    input  wire                          S_AXI_AWVALID,
    output wire                          S_AXI_AWREADY,
    input  wire [C_S_AXI_DATA_WIDTH-1:0] S_AXI_WDATA,
    input  wire                          S_AXI_WVALID,
    output wire                          S_AXI_WREADY,
    output wire [1:0]                    S_AXI_BRESP,
    output wire                          S_AXI_BVALID,
    input  wire                          S_AXI_BREADY,
    input  wire [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR,
    input  wire                          S_AXI_ARVALID,
    output wire                          S_AXI_ARREADY,
    output wire [C_S_AXI_DATA_WIDTH-1:0] S_AXI_RDATA,
    output wire [1:0]                    S_AXI_RRESP,
    output wire                          S_AXI_RVALID,
    input  wire                          S_AXI_RREADY,

    output reg  [31:0]                   reg_id_dynamic
);
    assign S_AXI_AWREADY = 1;
    assign S_AXI_WREADY  = 1;
    assign S_AXI_BRESP   = 2'b00;
    assign S_AXI_BVALID  = S_AXI_AWVALID && S_AXI_WVALID;

    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN)
            reg_id_dynamic <= 0;
        else if (S_AXI_AWVALID && S_AXI_WVALID && S_AXI_AWADDR[4:2] == 3'h1)
            reg_id_dynamic <= S_AXI_WDATA;
    end

    assign S_AXI_ARREADY = 1;
    assign S_AXI_RRESP   = 2'b00;
    assign S_AXI_RVALID  = S_AXI_ARVALID;
    assign S_AXI_RDATA   = (S_AXI_ARADDR[4:2] == 3'h1) ? reg_id_dynamic : 32'h12345678;
endmodule
