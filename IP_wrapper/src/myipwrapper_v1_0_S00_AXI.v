`timescale 1 ns / 1 ps

module myipwrapper_v1_0_S00_AXI #
(
    parameter integer C_S_AXI_DATA_WIDTH = 32,
    parameter integer C_S_AXI_ADDR_WIDTH = 5
)
(
    input  wire S_AXI_ACLK,
    input  wire S_AXI_ARESETN,
    input  wire [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_AWADDR,
    input  wire [2:0] S_AXI_AWPROT,
    input  wire S_AXI_AWVALID,
    output wire S_AXI_AWREADY,
    input  wire [C_S_AXI_DATA_WIDTH-1:0] S_AXI_WDATA,
    input  wire [(C_S_AXI_DATA_WIDTH/8)-1:0] S_AXI_WSTRB,
    input  wire S_AXI_WVALID,
    output wire S_AXI_WREADY,
    output wire [1:0] S_AXI_BRESP,
    output wire S_AXI_BVALID,
    input  wire S_AXI_BREADY,
    input  wire [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR,
    input  wire [2:0] S_AXI_ARPROT,
    input  wire S_AXI_ARVALID,
    output wire S_AXI_ARREADY,
    output wire [C_S_AXI_DATA_WIDTH-1:0] S_AXI_RDATA,
    output wire [1:0] S_AXI_RRESP,
    output wire S_AXI_RVALID,
    input  wire S_AXI_RREADY
);

    // === Paramètres internes ===
    localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
    localparam integer OPT_MEM_ADDR_BITS = 2;

    // === Registres internes
    reg [31:0] reg0 = 0;  // ID fixe (MicroBlaze)
    reg [31:0] reg1 = 0;  // ID généré (Generator IP)
    reg [31:0] reg2 = 0;  // Control (bit 0 = req_valid)

    reg [31:0] axi_rdata;
    reg        axi_awready = 0;
    reg        axi_wready  = 0;
    reg        axi_bvalid  = 0;
    reg [1:0]  axi_bresp   = 0;
    reg        axi_arready = 0;
    reg        axi_rvalid  = 0;
    reg [1:0]  axi_rresp   = 0;
    reg [C_S_AXI_ADDR_WIDTH-1:0] axi_awaddr = 0;
    reg [C_S_AXI_ADDR_WIDTH-1:0] axi_araddr = 0;
    reg        aw_en = 1;

    // === Signaux de statut
    wire access_granted;
    wire access_denied;
    wire irq_flag;

    // === Assignations AXI
    assign S_AXI_AWREADY = axi_awready;
    assign S_AXI_WREADY  = axi_wready;
    assign S_AXI_BVALID  = axi_bvalid;
    assign S_AXI_BRESP   = axi_bresp;
    assign S_AXI_ARREADY = axi_arready;
    assign S_AXI_RDATA   = axi_rdata;
    assign S_AXI_RVALID  = axi_rvalid;
    assign S_AXI_RRESP   = axi_rresp;

    wire slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;
    wire slv_reg_rden = axi_arready && S_AXI_ARVALID && ~axi_rvalid;

    // === Write address ready
    always @(posedge S_AXI_ACLK) begin
        if (~S_AXI_ARESETN) begin
            axi_awready <= 0;
            aw_en <= 1;
        end else if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en) begin
            axi_awready <= 1;
            aw_en <= 0;
        end else if (S_AXI_BREADY && axi_bvalid) begin
            aw_en <= 1;
            axi_awready <= 0;
        end else begin
            axi_awready <= 0;
        end
    end

    // === Capture adresse écriture
    always @(posedge S_AXI_ACLK) begin
        if (~S_AXI_ARESETN)
            axi_awaddr <= 0;
        else if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
            axi_awaddr <= S_AXI_AWADDR;
    end

    // === Write data ready
    always @(posedge S_AXI_ACLK) begin
        if (~S_AXI_ARESETN)
            axi_wready <= 0;
        else if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID && aw_en)
            axi_wready <= 1;
        else
            axi_wready <= 0;
    end

    // === Écriture des registres
    always @(posedge S_AXI_ACLK) begin
        if (~S_AXI_ARESETN) begin
            reg0 <= 0;
            reg1 <= 0;
            reg2 <= 0;
        end else if (slv_reg_wren) begin
            case (axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB])
                3'h0: reg0 <= S_AXI_WDATA;
                3'h1: reg1 <= S_AXI_WDATA;
                3'h2: reg2 <= S_AXI_WDATA;
            endcase
        end
    end

    // === Write response
    always @(posedge S_AXI_ACLK) begin
        if (~S_AXI_ARESETN) begin
            axi_bvalid <= 0;
            axi_bresp  <= 2'b00;
        end else if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID) begin
            axi_bvalid <= 1;
            axi_bresp  <= 2'b00;
        end else if (S_AXI_BREADY && axi_bvalid) begin
            axi_bvalid <= 0;
        end
    end

    // === Read address ready
    always @(posedge S_AXI_ACLK) begin
        if (~S_AXI_ARESETN) begin
            axi_arready <= 0;
            axi_araddr  <= 0;
        end else if (~axi_arready && S_AXI_ARVALID) begin
            axi_arready <= 1;
            axi_araddr  <= S_AXI_ARADDR;
        end else begin
            axi_arready <= 0;
        end
    end

    // === Read valid
    always @(posedge S_AXI_ACLK) begin
        if (~S_AXI_ARESETN) begin
            axi_rvalid <= 0;
            axi_rresp  <= 2'b00;
        end else if (slv_reg_rden) begin
            axi_rvalid <= 1;
            axi_rresp  <= 2'b00;
        end else if (axi_rvalid && S_AXI_RREADY) begin
            axi_rvalid <= 0;
        end
    end

    // === Lecture des registres
    always @(*) begin
        case (axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB])
            3'h0: axi_rdata = reg0;
            3'h1: axi_rdata = reg1;
            3'h2: axi_rdata = reg2;
            3'h4: axi_rdata = {29'b0, irq_flag, access_denied, access_granted};
            default: axi_rdata = 32'hDEADBEEF;
        endcase
    end

    // === Instanciation du comparateur
    wrapper uut (
        .clk(S_AXI_ACLK),
        .rst(~S_AXI_ARESETN),
        .id_fixed(reg0),
        .id_dynamic(reg1),
        .req_valid(reg2[0]),
        .access_granted(access_granted),
        .access_denied(access_denied),
        .irq_flag(irq_flag)
    );

endmodule
