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


module axis_testpattern_generator_test (   );
    localparam DATA_WIDTH = 8;
    localparam BURSTSIZE = 0;
    localparam DIVIDER = 3;
    localparam START = 0;
    localparam END = 10;
    localparam INCR = 1;
    // CLK & RST
    reg clk25;
    reg rst;
    reg enable;
        
    // AXIS Master side
    wire[DATA_WIDTH-1:0]   tdata;
    wire                   tvalid;
    wire                   tlast;
    reg                    ready;        
    axis_testpattern_generator #(
        .M_AXIS_TDATA_WIDTH(DATA_WIDTH),
        .M_AXIS_BURSTSIZE(BURSTSIZE),
        .COUNTER_START(START),
        .COUNTER_END(END),
        .COUNTER_INCR(INCR),
        .DIVIDER(DIVIDER)
    ) DUT (
        .m_axis_aclk(clk25),
        .m_axis_aresetn(~rst),
        .enable(enable),
            
        // AXI-Stream
        .m_axis_tdata(tdata), 
        .m_axis_tvalid(tvalid),
        .m_axis_tready(ready),
        .m_axis_tlast(tlast)
    );
        
    initial begin
        // init
        clk25 = 1;
        rst = 1;
        ready = 1;
        enable = 1;
                    
        // un-reset
        #20 rst = 0;

        // async reset
        #1505
        rst = 1;
        #10
        rst = 0;
        #5
        
        // reset -> un-reset with tready low
        #500
        rst = 1;
        ready = 0;
        #20
        rst = 0;
        #40
        ready = 1; 

        // in-reset ready rattling        
        #500
        rst = 1;
        #20
        ready = 0;
        #20
        ready = 1;
        #20
        ready = 0;
        #20
        ready = 1;
        #20
        ready = 0;
        #40
        rst = 0;
        #40
        ready = 1;

        // ready hold-up
        #980
        ready = 0;
        
        #300
        ready = 1;
        
        // ready rattling
        #300
        ready = 0;
        #20
        ready = 1;
        #20
        ready = 0;
        #20
        ready = 1;
        #20
        ready = 0;
        #20
        ready = 1;
        
        #900 
        enable = 0;
        #500 
        enable = 1;
    end
    
    // Generate CLK 100 MHz
    always
    begin
        #10
        clk25 = ~clk25;
    end
endmodule
