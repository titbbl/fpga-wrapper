`timescale 1ns / 1ps

module wrapper #(parameter ADDR_WIDTH = 5, parameter DATA_WIDTH = 32) (
    input  wire                     s00_axi_aclk,
    input  wire                     s00_axi_aresetn,
    input  wire [ADDR_WIDTH-1:0]    s00_axi_awaddr,
    input  wire                     s00_axi_awvalid,
    output wire                     s00_axi_awready,
    input  wire [DATA_WIDTH-1:0]    s00_axi_wdata,
    input  wire                     s00_axi_wvalid,
    output wire                     s00_axi_wready,
    output wire [1:0]               s00_axi_bresp,
    output wire                     s00_axi_bvalid,
    input  wire                     s00_axi_bready,
    input  wire [ADDR_WIDTH-1:0]    s00_axi_araddr,
    input  wire                     s00_axi_arvalid,
    output wire                     s00_axi_arready,
    output wire [DATA_WIDTH-1:0]    s00_axi_rdata,
    output wire [1:0]               s00_axi_rresp,
    output wire                     s00_axi_rvalid,
    input  wire                     s00_axi_rready,

    input  wire                     s01_axi_aclk,
    input  wire                     s01_axi_aresetn,
    input  wire [ADDR_WIDTH-1:0]    s01_axi_awaddr,
    input  wire                     s01_axi_awvalid,
    output wire                     s01_axi_awready,
    input  wire [DATA_WIDTH-1:0]    s01_axi_wdata,
    input  wire                     s01_axi_wvalid,
    output wire                     s01_axi_wready,
    output wire [1:0]               s01_axi_bresp,
    output wire                     s01_axi_bvalid,
    input  wire                     s01_axi_bready,
    input  wire [ADDR_WIDTH-1:0]    s01_axi_araddr,
    input  wire                     s01_axi_arvalid,
    output wire                     s01_axi_arready,
    output wire [DATA_WIDTH-1:0]    s01_axi_rdata,
    output wire [1:0]               s01_axi_rresp,
    output wire                     s01_axi_rvalid,
    input  wire                     s01_axi_rready
);

    wire clk = s00_axi_aclk;
    wire rst = ~s00_axi_aresetn;

    // === Internal registers ===
    reg  [23:0] id_fixed    = 24'd0;
    reg  [23:0] id_dynamic  = 24'd0;
    wire        match;
    wire [7:0]  count;
    wire [7:0]  max_val;
    wire        block;

    // === AXI Write decode ===
    wire s00_wr_en = s00_axi_wvalid && s00_axi_awvalid;
    assign s00_axi_awready = 1;
    assign s00_axi_wready  = 1;
    assign s00_axi_bresp   = 2'b00;
    assign s00_axi_bvalid  = s00_wr_en;

    always @(posedge clk) begin
        if (s00_wr_en && s00_axi_awaddr == 5'h00)
            id_fixed <= s00_axi_wdata[23:0];
    end

    wire s01_wr_en = s01_axi_wvalid && s01_axi_awvalid;
    assign s01_axi_awready = 1;
    assign s01_axi_wready  = 1;
    assign s01_axi_bresp   = 2'b00;
    assign s01_axi_bvalid  = s01_wr_en;

    always @(posedge clk) begin
        if (s01_wr_en && s01_axi_awaddr == 5'h04)
            id_dynamic <= s01_axi_wdata[23:0];
    end

    // === AXI Read
    assign s00_axi_arready = 1;
    assign s00_axi_rresp   = 2'b00;
    assign s00_axi_rvalid  = s00_axi_arvalid;
    assign s00_axi_rdata   = (s00_axi_araddr == 5'h00) ? {8'd0, id_fixed} :
                             (s00_axi_araddr == 5'h04) ? {8'd0, id_dynamic} :
                             (s00_axi_araddr == 5'h10) ? {16'd0, 8'd0, block, match} :
                             32'hDEADBEEF;

    assign s01_axi_arready = 1;
    assign s01_axi_rresp   = 2'b00;
    assign s01_axi_rvalid  = s01_axi_arvalid;
    assign s01_axi_rdata   = 32'h12345678;

    // === Instantiate comparator and monitor ===
    comparator u_cmp (
        .id_a(id_fixed),
        .id_b(id_dynamic),
        .match(match)
    );

    monitor u_monitor (
        .clk(clk),
        .rst(rst),
        .match(match),
        .count(count),
        .max_value(max_val),
        .block(block)
    );

endmodule
