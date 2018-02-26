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

module axis_labcontrol_interface_test(    );

    // CLK & RST
    reg clk100;
    reg rst;
    
    // AXI Slave side
    localparam AXIS_DATA_WIDTH = 16;
    localparam LC_ADDR_WIDTH = 8;
    localparam LC_DATA_WIDTH = 16;
    localparam LC_SBUS_WIDTH = 3;
    localparam LC_RESV_WIDTH = 3;
   
    localparam LC_ADDRESS = 8'h11;

    // AXIS Master side
    wire [AXIS_DATA_WIDTH-1:0]  m_axis_tdata;
    wire                        m_axis_tvalid;
    reg                         m_axis_tready;
    reg [LC_DATA_WIDTH-1:0]     data;
    reg [LC_ADDR_WIDTH-1:0]     addr;
    reg [LC_RESV_WIDTH-1:0]     reserved;
    reg [LC_SBUS_WIDTH-1:0]     subbus;
    reg                         dir;
    reg                         strobe;
    wire [31:0]                 lc_bus = {data, addr, reserved, subbus, dir, strobe};
    
    wire aresetn = ~rst;
    axis_labcontrol_interface #(
        .AXIS_DATA_WIDTH(AXIS_DATA_WIDTH),
        .LC_DATA_WIDTH(LC_DATA_WIDTH),
        .LC_ADDR_WIDTH(LC_ADDR_WIDTH),
        .LC_ADDRESS(LC_ADDRESS)
        ) DUT (
        .m_axis_aclk(clk100),
        .m_axis_aresetn(~rst),
                
        // AXIS Master side
        .m_axis_tdata(m_axis_tdata), 
        .m_axis_tvalid(m_axis_tvalid), 
        .m_axis_tready(m_axis_tready),
        
        .DIOA(lc_bus[31:24]),
        .DIOB(lc_bus[23:16]),
        .DIOC(lc_bus[15:8]),
        .DIOD(lc_bus[7:0])
        );
    
    initial begin
        // init
        clk100 = 0;
        data = 16'd0;
        addr = 8'd0;
        strobe = 1'b0;       
        subbus = 3'b000;
        dir = 1'b1;
        reserved = 2'b000; 
        m_axis_tready = 0'b0;
        
        // reset
        rst = 0;
        #10 rst = 1;
        #20 rst = 0;
        
        // Reject by address
        #100
        addr = 8'b10000000;
        data = 16'hFFFF;
        #10 strobe = 1;
        #100 strobe = 0;
        
        // tready after valid
        #100
        addr = 'h11;
        data = 'h5353;
        #10 strobe = 1;
        #100 strobe = 0;
        data = 'hFFFF;
        #20 m_axis_tready = 1;
        #10 m_axis_tready = 0;

        // tready before tvalid
        #10 m_axis_tready = 1;
        data = 'h8181;
        #10 strobe = 1;
        #100 strobe = 0;
        #10 m_axis_tready = 0;
        
        // short write (between clocks)
        // tready before tvalid
        data = 'hF33F;
        #7 strobe = 1;
        #5 strobe = 0;
        #20 m_axis_tready = 1;
        #10 m_axis_tready = 0;

        // Leave tready high
        #50 m_axis_tready = 1;
        data = 'h9999;
        #10 strobe = 1;
        //#100 strobe = 0;                          
    end
    
    // Generate CLK 100 MHz
    always
    begin
        #5
        clk100 = ~clk100;
    end
endmodule
