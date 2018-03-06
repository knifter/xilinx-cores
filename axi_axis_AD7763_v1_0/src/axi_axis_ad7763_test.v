`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/24/2017 12:28:24 PM
// Design Name: 
// Module Name: axi_axis_ad7763_test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module axi_axis_ad7763_test(    );

    // CLK & RST
    reg clk100;
    reg clk40;
    reg rst;
    
    // AXI Slave side
    localparam AXI_ADDR_WIDTH = 12;
    localparam AXI_DATA_WIDTH = 32;

    reg [AXI_ADDR_WIDTH-1:0]    s_axi_awaddr;  // AXI4-Lite slave: Write address
    reg                         s_axi_awvalid; // AXI4-Lite slave: Write address valid
    wire                        s_axi_awready; // AXI4-Lite slave: Write address ready
    reg [AXI_DATA_WIDTH-1:0]    s_axi_wdata;   // AXI4-Lite slave: Write data
    reg                         s_axi_wvalid;  // AXI4-Lite slave: Write data valid
    wire                        s_axi_wready;  // AXI4-Lite slave: Write data ready
    wire [1:0]                  s_axi_bresp;   // AXI4-Lite slave: Write response
    wire                        s_axi_bvalid;  // AXI4-Lite slave: Write response valid
    reg                         s_axi_bready;  // AXI4-Lite slave: Write response ready
    reg  [AXI_DATA_WIDTH-1:0]   s_axi_araddr;  // AXI4-Lite slave: Read address
    reg                         s_axi_arvalid; // AXI4-Lite slave: Read address valid
    wire                        s_axi_arready; // AXI4-Lite slave: Read address ready
    wire [AXI_DATA_WIDTH-1:0]   s_axi_rdata;   // AXI4-Lite slave: Read data
    wire [1:0]                  s_axi_rresp;   // AXI4-Lite slave: Read data response
    wire                        s_axi_rvalid;  // AXI4-Lite slave: Read data valid
    reg                         s_axi_rready;  // AXI4-Lite slave: Read data ready

    // AXIS Master side
    localparam AXIS_WIDTH = 24;
    wire [AXIS_WIDTH-1:0]       m_axis_tdata;
    wire                        m_axis_tvalid;
    reg                         m_axis_tready;
    
    // ADC Connections
    wire               adc_sco;       // Serial Clock Out
    reg                adc_fson;      // Frame Sync Out, negated
    reg                adc_sdo;       // Serial Data Out
    wire               adc_fsin;      // Frame Sync In, negated
    wire               adc_sdi;        // Serial Data In

    wire aresetn = ~rst;
    assign adc_sco = clk40;
    axi_axis_ad7763 DUT(
        clk100, aresetn,
        
        s_axi_awaddr, s_axi_awvalid, s_axi_awready, 
        s_axi_wdata, s_axi_wvalid, s_axi_wready,
        s_axi_bresp, s_axi_bvalid, s_axi_bready,
        s_axi_araddr, s_axi_arvalid, s_axi_arready,
        s_axi_rdata, s_axi_rresp, s_axi_rvalid, s_axi_rready,
        
        // AXIS Master side
        m_axis_tdata, m_axis_tvalid, m_axis_tready,
         
        // ADC Connections
        adc_sco, adc_fson, adc_sdo, adc_fsin, adc_sdi
        );
    
    reg [23:0] adc;
    initial begin
        // init
        clk40 = 0;
        clk100 = 0;
        rst = 1;
        s_axi_wvalid = 0;
        s_axi_wdata = 32'hFFFF;
        s_axi_bready = 0;
        adc_fson = 1;
        adc_sdo  = 0;
        m_axis_tready = 0;
        adc = 0;
        
        // reset
        #10 rst = 0;
        //#60 rst = 0;
        
        // write wdata
        s_axi_wdata = 32'h11FF3355;
        s_axi_bready = 1;
        #10 s_axi_wvalid = 1; 
        #10 s_axi_wvalid = 0;

//        // write wdata (do not accept)        
//        #50
//        s_axi_wdata = 32'hFFFFFFFF;
//        s_axi_bready = 1;
//        #10 s_axi_wvalid = 1;
//        #10 s_axi_wvalid = 0;
                
        #17000
        m_axis_tready = 1;
//        #25
//        m_axis_tready = 0;
    end
    
    always begin
        //#100 adc = adc; // stretch
        #25 adc_fson = 0;
        adc = adc + 1;
        #25 adc_fson = 1;
        adc_sdo = adc[23];
        #25 adc_sdo = adc[22];
        #25 adc_sdo = adc[21];
        #25 adc_sdo = adc[20];
        #25 adc_sdo = adc[19];
        #25 adc_sdo = adc[18];
        #25 adc_sdo = adc[17];
        #25 adc_sdo = adc[16];
        #25 adc_sdo = adc[15];
        #25 adc_sdo = adc[14];
        #25 adc_sdo = adc[13];
        #25 adc_sdo = adc[12];
        #25 adc_sdo = adc[11];
        #25 adc_sdo = adc[10];
        #25 adc_sdo = adc[9];
        #25 adc_sdo = adc[8];
        #25 adc_sdo = adc[7];
        #25 adc_sdo = adc[6];
        #25 adc_sdo = adc[5];
        #25 adc_sdo = adc[4];
        #25 adc_sdo = adc[3];
        #25 adc_sdo = adc[2];
        #25 adc_sdo = adc[1];
        #25 adc_sdo = adc[0];        
        #25 adc_sdo = 0; // ST6
        #25 adc_sdo = 0; // ST5
        #25 adc_sdo = 0; // ST4
        #25 adc_sdo = 0; // ST3
        #25 adc_sdo = 0; // ST2
        #25 adc_sdo = 0; // ST1
        #25 adc_sdo = 0; // ST0
        #25 adc_sdo = 0; // Tri-State
    end    
    
    // Generate CLK 40 MH
    always begin
        #12.5
        clk40 = ~clk40;
    end

    // Generate CLK 100 MHz
    always
    begin
        #5
        clk100 = ~clk100;
    end
endmodule
