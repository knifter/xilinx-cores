
`timescale 1 ns / 1 ps

module axi_axis_ad7763 #
(
    parameter integer AXI_DATA_WIDTH = 32,
    parameter integer AXI_ADDR_WIDTH = 12,
    parameter integer AXIS_DATA_WIDTH = 24
)
(
    // System signals
    input  wire                      s_axi_aclk,
    input  wire                      s_axi_aresetn,
    input  wire                      s_ad7763_clk,
    
    // AXI Slave side
    input  wire [AXI_ADDR_WIDTH-1:0] s_axi_awaddr,  // AXI4-Lite slave: Write address
    input  wire                      s_axi_awvalid, // AXI4-Lite slave: Write address valid
    output wire                      s_axi_awready, // AXI4-Lite slave: Write address ready
    input  wire [AXI_DATA_WIDTH-1:0] s_axi_wdata,   // AXI4-Lite slave: Write data
    input  wire                      s_axi_wvalid,  // AXI4-Lite slave: Write data valid
    output wire                      s_axi_wready,  // AXI4-Lite slave: Write data ready
    output wire [1:0]                s_axi_bresp,   // AXI4-Lite slave: Write response
    output wire                      s_axi_bvalid,  // AXI4-Lite slave: Write response valid
    input  wire                      s_axi_bready,  // AXI4-Lite slave: Write response ready
    input  wire [AXI_ADDR_WIDTH-1:0] s_axi_araddr,  // AXI4-Lite slave: Read address
    input  wire                      s_axi_arvalid, // AXI4-Lite slave: Read address valid
    output wire                      s_axi_arready, // AXI4-Lite slave: Read address ready
    output wire [AXI_DATA_WIDTH-1:0] s_axi_rdata,   // AXI4-Lite slave: Read data
    output wire [1:0]                s_axi_rresp,   // AXI4-Lite slave: Read data response
    output wire                      s_axi_rvalid,  // AXI4-Lite slave: Read data valid
    input  wire                      s_axi_rready,  // AXI4-Lite slave: Read data ready
    
    // AXIS Master side
    output wire [AXIS_DATA_WIDTH-1:0] m_axis_tdata,
    output wire                      m_axis_tvalid,
    input  wire                      m_axis_tready,
    output wire                      m_axis_aclk,   // Stream Clock == ADC Clock
    
    // ADC Connections
    input  wire                      adc_dreadyn,   // ADC Data Ready Out, negated
    input  wire                      adc_sdo,       // ADC Serial Data Out
    output wire                      adc_fsin,      // ADC Frame Sync In, negated
    output wire                      adc_sdi        // ADC Serial Data In
);

    assign m_axis_aclk = s_ad7763_clk;
    
    // AXI Control In
    axi_ad7763 #(
        .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
        .AXI_DATA_WIDTH(AXI_DATA_WIDTH)
    )axi_inst(
        .aclk(s_axi_aclk),
        .aresetn(s_axi_aresetn),

        .s_axi_awaddr(s_axi_awaddr),    // AXI4-Lite slave: Write address
        .s_axi_awvalid(s_axi_awvalid),  // AXI4-Lite slave: Write address valid
        .s_axi_awready(s_axi_awready),  // AXI4-Lite slave: Write address ready
        .s_axi_wdata(s_axi_wdata),      // AXI4-Lite slave: Write data
        .s_axi_wvalid(s_axi_wvalid),    // AXI4-Lite slave: Write data valid
        .s_axi_wready(s_axi_wready),    // AXI4-Lite slave: Write data ready
        .s_axi_bresp(s_axi_bresp),      // AXI4-Lite slave: Write response
        .s_axi_bvalid(s_axi_bvalid),    // AXI4-Lite slave: Write response valid
        .s_axi_bready(s_axi_bready),    // AXI4-Lite slave: Write response ready
        .s_axi_araddr(s_axi_araddr),    // AXI4-Lite slave: Read address
        .s_axi_arvalid(s_axi_arvalid),  // AXI4-Lite slave: Read address valid
        .s_axi_arready(s_axi_arready),  // AXI4-Lite slave: Read address ready
        .s_axi_rdata(s_axi_rdata),      // AXI4-Lite slave: Read data
        .s_axi_rresp(s_axi_rresp),      // AXI4-Lite slave: Read data response
        .s_axi_rvalid(s_axi_rvalid),    // AXI4-Lite slave: Read data valid
        .s_axi_rready(s_axi_rready),    // AXI4-Lite slave: Read data ready
        
        // ADC Connections
        .adc_sco(s_ad7763_clk),         // Serial Clock Out
        .adc_fsin(adc_fsin),            // Frame Sync In, negated
        .adc_sdi(adc_sdi)               // Serial Data In
    );

    // AXI-Stream Out
    axis_ad7763 #(
        .AXIS_DATA_WIDTH(AXIS_DATA_WIDTH)
    )axis_inst(
        .aclk(s_ad7763_clk),
        .aresetn(s_axi_aresetn),
        
        .m_axis_tdata(m_axis_tdata),
        .m_axis_tvalid(m_axis_tvalid),
        .m_axis_tready(m_axis_tready),
            
        .adc_dreadyn(adc_dreadyn),
        .adc_sdo(adc_sdo)
        );
endmodule
