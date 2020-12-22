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
    localparam DATA_WIDTH = 24;

    // CLK & RST
    reg clk25;
    reg rst;
        
    // AXIS Master side
    wire[DATA_WIDTH-1:0]   data;
    wire                   valid;
    reg                    ready;
        
    axis_testpattern_generator #(
        .M00_AXIS_DATA_WIDTH(DATA_WIDTH)
//        .COUNTER_START(0),
//        .COUNTER_END(500),
//        .COUNTER_INCR(1)
    ) DUT (
        .m_axis_aclk(clk25),
        .m_axis_aresetn(~rst),
            
        // AXI-Stream
        .m_axis_tdata(data), 
        .m_axis_tvalid(valid),
        .m_axis_tready(ready)
    );
        
    initial begin
        // init
        clk25 = 0;
        rst = 1;
        ready = 0;
                    
        // reset
        #40 rst = 0;

        #99
        ready = 1;

        #99
        ready = 0;

        #99
        ready = 1;
    end
    
    // Generate CLK 100 MHz
    always
    begin
        #10
        clk25 = ~clk25;
    end
endmodule
