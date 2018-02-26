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

module axi_axis_reader_testbench(    );

    // CLK & RST
    reg clk100;
    reg rst;
    
    // AXI Slave side
    localparam AXI_ADDR_WIDTH = 12;
    localparam AXI_DATA_WIDTH = 4;
    localparam AXIS_DATA_WIDTH = 8;

    reg [AXI_ADDR_WIDTH-1:0]    s_axi_awaddr;  // AXI4-Lite slave: Write address
    reg                         s_axi_awvalid; // AXI4-Lite slave: Write address valid
    wire                        s_axi_awready; // AXI4-Lite slave: Write address ready
    reg [AXI_DATA_WIDTH-1:0]    s_axi_wdata;   // AXI4-Lite slave: Write data
    reg                         s_axi_wvalid;  // AXI4-Lite slave: Write data valid
    wire                        s_axi_wready;  // AXI4-Lite slave: Write data ready
    wire [1:0]                  s_axi_bresp;   // AXI4-Lite slave: Write response
    wire                        s_axi_bvalid;  // AXI4-Lite slave: Write response valid
    reg                         s_axi_bready;  // AXI4-Lite slave: Write response ready
    reg  [AXI_ADDR_WIDTH-1:0]   s_axi_araddr;  // AXI4-Lite slave: Read address
    reg                         s_axi_arvalid; // AXI4-Lite slave: Read address valid
    wire                        s_axi_arready; // AXI4-Lite slave: Read address ready
    wire [AXI_DATA_WIDTH-1:0]   s_axi_rdata;   // AXI4-Lite slave: Read data
    wire [1:0]                  s_axi_rresp;   // AXI4-Lite slave: Read data response
    wire                        s_axi_rvalid;  // AXI4-Lite slave: Read data valid
    reg                         s_axi_rready;  // AXI4-Lite slave: Read data ready

    // AXIS Master side
    reg [AXIS_DATA_WIDTH-1:0]   s_axis_tdata;
    reg                         s_axis_tvalid;
    wire                        s_axis_tready;
    
    wire aresetn = ~rst;
    axi_axis_reader #(
        .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
        .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
        .AXIS_DATA_WIDTH(AXIS_DATA_WIDTH)
        ) DUT (
        clk100, aresetn,
        
        s_axi_awaddr, s_axi_awvalid, s_axi_awready, 
        s_axi_wdata, s_axi_wvalid, s_axi_wready,
        s_axi_bresp, s_axi_bvalid, s_axi_bready,
        s_axi_araddr, s_axi_arvalid, s_axi_arready,
        s_axi_rdata, s_axi_rresp, s_axi_rvalid, s_axi_rready,
        
        // AXIS Master side
        s_axis_tdata, s_axis_tvalid, s_axis_tready
        );
    
    initial begin
        // init
        clk100 = 0;        
        s_axi_awaddr = { {(AXI_ADDR_WIDTH)}{1'b0} };
        s_axi_awvalid = 1'b0;
        s_axi_wdata = { {(AXI_DATA_WIDTH)}{1'b0} };
        s_axi_wvalid = 1'b0;
        s_axi_bready = 1'b1;
        s_axi_araddr = { {(AXI_ADDR_WIDTH)}{1'b0} };
        s_axi_arvalid = 1'b0;
        s_axi_rready = 1'b1;

        s_axis_tdata = { {(AXIS_DATA_WIDTH)}{1'b0} };
        s_axis_tvalid = 1'b0;
        
        // reset
        rst = 0;
        #10 rst = 1;
        #20 rst = 0;
        
        #20
        s_axis_tdata = 8'h35;
        
        #20
        s_axis_tvalid = 1;
        
        #20 s_axi_arvalid = 1;
        #10 s_axi_arvalid = 0;
        
        #20
        s_axi_rready = 1;
    end
    
    // Generate CLK 100 MHz
    always
    begin
        #5
        clk100 = ~clk100;
    end
endmodule
