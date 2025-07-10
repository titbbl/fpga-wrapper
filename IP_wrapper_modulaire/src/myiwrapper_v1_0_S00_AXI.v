`timescale 1 ns / 1 ps
module myipwrapper_v1_0_S00_AXI #(
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

    output reg  [31:0]                   reg_id_fixed,
    input  wire                          access_granted,
    input  wire                          access_denied,
    input  wire                          irq_flag
);
    reg [31:0] slv_reg2 = 0; // Control register
    
    assign S_AXI_AWREADY = 1;
    assign S_AXI_WREADY  = 1;
    assign S_AXI_BRESP   = 2'b00;
    assign S_AXI_BVALID  = S_AXI_AWVALID && S_AXI_WVALID;

    always @(posedge S_AXI_ACLK) begin
        if (!S_AXI_ARESETN) begin
            reg_id_fixed <= 0;
            slv_reg2     <= 0;
        end else if (S_AXI_AWVALID && S_AXI_WVALID) begin
            case (S_AXI_AWADDR[4:2])
                3'h0: reg_id_fixed <= S_AXI_WDATA;
                3'h2: slv_reg2     <= S_AXI_WDATA;
            endcase
        end
    end


    assign S_AXI_ARREADY = 1;
    assign S_AXI_RRESP   = 2'b00;
    assign S_AXI_RVALID  = S_AXI_ARVALID;
    assign S_AXI_RDATA = (S_AXI_ARADDR[4:2] == 3'h0) ? reg_id_fixed :
                         (S_AXI_ARADDR[4:2] == 3'h4) ? {29'd0, irq_flag, access_denied, access_granted} :
                         32'hDEADDEAD;
endmodule