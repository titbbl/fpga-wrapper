// ========================================
// myipwrapper_v1_0.v (TOP MODULE)
// ========================================

`timescale 1 ns / 1 ps

module myipwrapper_v1_0 #(
    parameter integer C_S00_AXI_DATA_WIDTH = 32,
    parameter integer C_S00_AXI_ADDR_WIDTH = 5,
    parameter integer C_S01_AXI_DATA_WIDTH = 32,
    parameter integer C_S01_AXI_ADDR_WIDTH = 5
)(
    // S00_AXI (MicroBlaze)
    input  wire                             s00_axi_aclk,
    input  wire                             s00_axi_aresetn,
    input  wire [C_S00_AXI_ADDR_WIDTH-1:0]  s00_axi_awaddr,
    input  wire                             s00_axi_awvalid,
    output wire                             s00_axi_awready,
    input  wire [C_S00_AXI_DATA_WIDTH-1:0]  s00_axi_wdata,
    input  wire                             s00_axi_wvalid,
    output wire                             s00_axi_wready,
    output wire [1:0]                       s00_axi_bresp,
    output wire                             s00_axi_bvalid,
    input  wire                             s00_axi_bready,
    input  wire [C_S00_AXI_ADDR_WIDTH-1:0]  s00_axi_araddr,
    input  wire                             s00_axi_arvalid,
    output wire                             s00_axi_arready,
    output wire [C_S00_AXI_DATA_WIDTH-1:0]  s00_axi_rdata,
    output wire [1:0]                       s00_axi_rresp,
    output wire                             s00_axi_rvalid,
    input  wire                             s00_axi_rready,

    // S01_AXI (Generator)
    input  wire                             s01_axi_aclk,
    input  wire                             s01_axi_aresetn,
    input  wire [C_S01_AXI_ADDR_WIDTH-1:0]  s01_axi_awaddr,
    input  wire                             s01_axi_awvalid,
    output wire                             s01_axi_awready,
    input  wire [C_S01_AXI_DATA_WIDTH-1:0]  s01_axi_wdata,
    input  wire                             s01_axi_wvalid,
    output wire                             s01_axi_wready,
    output wire [1:0]                       s01_axi_bresp,
    output wire                             s01_axi_bvalid,
    input  wire                             s01_axi_bready,
    input  wire [C_S01_AXI_ADDR_WIDTH-1:0]  s01_axi_araddr,
    input  wire                             s01_axi_arvalid,
    output wire                             s01_axi_arready,
    output wire [C_S01_AXI_DATA_WIDTH-1:0]  s01_axi_rdata,
    output wire [1:0]                       s01_axi_rresp,
    output wire                             s01_axi_rvalid,
    input  wire                             s01_axi_rready
);

    wire [23:0] id_fixed;
    wire [23:0] id_dynamic;
    wire        access_granted;
    wire        access_denied;
    wire        irq_flag;

    // MicroBlaze side
    myipwrapper_v1_0_S00_AXI #(
        .C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
        .C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
    ) s00_axi_inst (
        .S_AXI_ACLK(s00_axi_aclk),
        .S_AXI_ARESETN(s00_axi_aresetn),
        .S_AXI_AWADDR(s00_axi_awaddr),
        .S_AXI_AWVALID(s00_axi_awvalid),
        .S_AXI_AWREADY(s00_axi_awready),
        .S_AXI_WDATA(s00_axi_wdata),
        .S_AXI_WVALID(s00_axi_wvalid),
        .S_AXI_WREADY(s00_axi_wready),
        .S_AXI_BRESP(s00_axi_bresp),
        .S_AXI_BVALID(s00_axi_bvalid),
        .S_AXI_BREADY(s00_axi_bready),
        .S_AXI_ARADDR(s00_axi_araddr),
        .S_AXI_ARVALID(s00_axi_arvalid),
        .S_AXI_ARREADY(s00_axi_arready),
        .S_AXI_RDATA(s00_axi_rdata),
        .S_AXI_RRESP(s00_axi_rresp),
        .S_AXI_RVALID(s00_axi_rvalid),
        .S_AXI_RREADY(s00_axi_rready),
        .reg_id_fixed(id_fixed),
        .access_granted(access_granted),
        .access_denied(access_denied),
        .irq_flag(irq_flag)
    );

    // Generator side
    myipwrapper_v1_0_S01_AXI #(
        .C_S_AXI_DATA_WIDTH(C_S01_AXI_DATA_WIDTH),
        .C_S_AXI_ADDR_WIDTH(C_S01_AXI_ADDR_WIDTH)
    ) s01_axi_inst (
        .S_AXI_ACLK(s01_axi_aclk),
        .S_AXI_ARESETN(s01_axi_aresetn),
        .S_AXI_AWADDR(s01_axi_awaddr),
        .S_AXI_AWVALID(s01_axi_awvalid),
        .S_AXI_AWREADY(s01_axi_awready),
        .S_AXI_WDATA(s01_axi_wdata),
        .S_AXI_WVALID(s01_axi_wvalid),
        .S_AXI_WREADY(s01_axi_wready),
        .S_AXI_BRESP(s01_axi_bresp),
        .S_AXI_BVALID(s01_axi_bvalid),
        .S_AXI_BREADY(s01_axi_bready),
        .S_AXI_ARADDR(s01_axi_araddr),
        .S_AXI_ARVALID(s01_axi_arvalid),
        .S_AXI_ARREADY(s01_axi_arready),
        .S_AXI_RDATA(s01_axi_rdata),
        .S_AXI_RRESP(s01_axi_rresp),
        .S_AXI_RVALID(s01_axi_rvalid),
        .S_AXI_RREADY(s01_axi_rready),
        .reg_id_dynamic(id_dynamic)
    );

    // Logic inside wrapper
    wrapper_logic logic_inst (
        .clk(s00_axi_aclk),
        .rst(~s00_axi_aresetn),
        .id_fixed(id_fixed),
        .id_dynamic(id_dynamic),
        .access_granted(access_granted),
        .access_denied(access_denied),
        .irq_flag(irq_flag)
    );

endmodule
