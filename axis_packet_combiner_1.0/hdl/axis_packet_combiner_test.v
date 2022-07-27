`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2017 01:56:48 PM
// Design Name: 
// Module Name: ad5791_dac_fsm
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


module axis_packet_combiner_test (   );
    localparam DATA_WIDTH = 32;
    localparam PACKETS_PER_PACKET = 1024;
    localparam DISCARD_FIRST = 1;
    // CLK & RST
    reg clk;
    reg rst;
        
    // AXIS Slave
    reg[DATA_WIDTH-1:0]   s_tdata;
    reg                   s_tvalid;
    reg                   s_tlast;
    wire                  s_tready;
    // AXIS Master
    wire[DATA_WIDTH-1:0]  m_tdata;
    wire                  m_tvalid;
    wire                  m_tlast;
    reg                   m_tready;
        
    axis_packet_combiner #(
        .AXIS_TDATA_WIDTH(DATA_WIDTH),
        .PACKETS_PER_PACKET(PACKETS_PER_PACKET),
        .DISCARD_FIRST_PACKET(DISCARD_FIRST)
    ) DUT (
        .axis_aclk(clk),
        .axis_aresetn(~rst),
            
        // AXI-Stream
        .s_axis_tdata(s_tdata), 
        .s_axis_tvalid(s_tvalid),
        .s_axis_tready(s_tready),
        .s_axis_tlast(s_tlast),
        
        .m_axis_tdata(m_tdata), 
        .m_axis_tvalid(m_tvalid),
        .m_axis_tready(m_tready),
        .m_axis_tlast(m_tlast)        
       
    );
        
    initial begin
        // TEST 1: 3 3-value packets combined into 1 9-value packet
        // init
        clk = 1;
        rst = 1;
        
        s_tlast <= 0;
        s_tdata <= 255;
        s_tvalid <= 0;
        m_tready = 1;
                    
        // un-reset
        #20 rst = 0;

        // we assume 3 vals per input packet
        // send the two last values of a partial packet
        #60
        s_tdata <= 2;
        s_tvalid <= 1;
        s_tlast <= 0;
        #20 s_tvalid <= 0;
        #60        
        s_tdata <= 3;
        s_tvalid <= 1;
        s_tlast <= 1;
        #20 s_tvalid <= 0;

        // Now send complete packet 1
        #60        
        s_tdata <= 11;
        s_tvalid <= 1;
        s_tlast <= 0;
        #20 s_tvalid <= 0;
        #60        
        s_tdata <= 12;
        s_tvalid <= 1;
        s_tlast <= 0;
        #20 s_tvalid <= 0;
        #60        
        s_tdata <= 13;
        s_tvalid <= 1;
        s_tlast <= 1;
        #20 s_tvalid <= 0;

        // Now send complete packet 2
        #60        
        s_tdata <= 21;
        s_tvalid <= 1;
        s_tlast <= 0;
        #20 s_tvalid <= 0;
        #60        
        s_tdata <= 22;
        s_tvalid <= 1;
        s_tlast <= 0;
        #20 s_tvalid <= 0;
        #60        
        s_tdata <= 23;
        s_tvalid <= 1;
        s_tlast <= 1;
        #20 s_tvalid <= 0;

        // Now send complete packet 3
        #60        
        s_tdata <= 31;
        s_tvalid <= 1;
        s_tlast <= 0;
        #20 s_tvalid <= 0;
        #60        
        s_tdata <= 32;
        s_tvalid <= 1;
        s_tlast <= 0;
        #20 s_tvalid <= 0;
        #60        
        s_tdata <= 33;
        s_tvalid <= 1;
        s_tlast <= 1;
        #20 s_tvalid <= 0;

        // Now send compelte packet 4, 
        #60        
        s_tdata <= 41;
        s_tvalid <= 1;
        s_tlast <= 0;
        #20 s_tvalid <= 0;
        #60        
        s_tdata <= 42;
        s_tvalid <= 1;
        s_tlast <= 0;
        #20 s_tvalid <= 0;
        #60        
        s_tdata <= 43;
        s_tvalid <= 1;
        s_tlast <= 1;
        #20 s_tvalid <= 0;
        // Done
        
        // TEST 2: Again 3x3 to 1x9, Full-Speed
        // init
        rst = 1;
        
        s_tlast <= 0;
        s_tdata <= 255;
        s_tvalid <= 0;
        m_tready = 1;
                    
        // un-reset
        #80 rst = 0;

        // we assume 3 vals per input packet
        // send the two last values of a partial packet
        #20
        s_tdata <= 2;
        s_tvalid <= 1;
        s_tlast <= 0;
        #20        
        s_tdata <= 3;
        s_tlast <= 1;
        #20        

        // Now send complete packet 1 
        s_tdata <= 11;
        s_tlast <= 0;
//        #20        
//        s_tdata <= 12;
        #20        
        s_tdata <= 13;
        s_tlast <= 1;
        #20        

        // Now send complete packet 2 
        s_tdata <= 21;
        s_tlast <= 0;
//        #20        
//        s_tdata <= 22;
        #20        
        s_tdata <= 23;
        s_tlast <= 1;
        #20        

        // Now send complete packet 3
        s_tdata <= 31;
        s_tlast <= 0;
//        #20        
//        s_tdata <= 32;
        #20        
        s_tdata <= 33;
        s_tlast <= 1;
        #20        

        // Now send complete packet 4
        s_tdata <= 41;
        s_tlast <= 0;
//        #20        
//        s_tdata <= 42;
        #20        
        s_tdata <= 43;
        s_tlast <= 1;
        #20        

        // Now send complete packet 5
        s_tdata <= 51;
        s_tlast <= 0;
//        #20        
//        s_tdata <= 52;
        #20        
        s_tdata <= 53;
        s_tlast <= 1;
        #20
        // Done
        
        // TEST 3: packet-size = 1 (TLAST tied 1)
        // init
        rst = 1;
        
        s_tlast <= 1;
        s_tdata <= 255;
        s_tvalid <= 0;
        m_tready = 1;
                    
        // un-reset
        #80 rst = 0;

        // send 1 value packets, first is ignored (the core can't know that packet length = 1 and synced will only go high _after_ first TLAST
        #60
        s_tdata <= 0;
        s_tvalid <= 1;
        #20 s_tvalid <= 0;
        #60
        s_tdata <= 1;
        s_tvalid <= 1;
        #20 s_tvalid <= 0;
        #60        
        s_tdata <= 2;
        s_tvalid <= 1;
        #20 s_tvalid <= 0;
        #60        
        s_tdata <= 3;
        s_tvalid <= 1;
        #20 s_tvalid <= 0;
        #60        
        s_tdata <= 4;
        s_tvalid <= 1;
        #20 s_tvalid <= 0;
        #60        
        s_tdata <= 5;
        s_tvalid <= 1;
        #20 s_tvalid <= 0;
        #60        
        s_tdata <= 6;
        s_tvalid <= 1;
        #20 s_tvalid <= 0;
        #60        
        s_tdata <= 7;
        s_tvalid <= 1;
        #20 s_tvalid <= 0;
        #60        
        s_tdata <= 8;
        s_tvalid <= 1;
        #20 s_tvalid <= 0;
        #60        
        s_tdata <= 9;
        s_tvalid <= 1;
        #20 s_tvalid <= 0;
        // Done
        
        // TEST 4: packet-size = 1, Full-Speed
        // init
        rst = 1;
        
        s_tlast <= 1;
        s_tdata <= 255;
        s_tvalid <= 0;
        m_tready = 1;
                    
        // un-reset
        #80 rst = 0;

        // send 1 value packets
        s_tvalid <= 1;
        s_tdata <= 0;
        #20 s_tdata <= 1;
        #20 s_tdata <= 2;
        #20 s_tdata <= 3;
        #20 s_tdata <= 4;
        #20 s_tdata <= 5;
        #20 s_tdata <= 6;
        #20 s_tdata <= 7;
        #20 s_tdata <= 8;
        #20 s_tdata <= 9;
        
        #20 s_tvalid = 0;
        // Done        
    end
    
    // Generate CLK 100 MHz
    always
    begin
        #10
        clk = ~clk;
    end
endmodule
