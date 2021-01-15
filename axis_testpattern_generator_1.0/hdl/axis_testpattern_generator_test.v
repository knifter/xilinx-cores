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
    reg enable;
        
    // AXIS Master side
    wire[DATA_WIDTH-1:0]   data;
    wire                   valid;
    reg                    ready;
        
    axis_testpattern_generator #(
        .M00_AXIS_DATA_WIDTH(DATA_WIDTH),
        .COUNTER_START(1),
        .COUNTER_END(100),
        .COUNTER_INCR(1),
        .DIVIDER(5)
    ) DUT (
        .m_axis_aclk(clk25),
        .m_axis_aresetn(~rst),
        .enable(enable),
            
        // AXI-Stream
        .m_axis_tdata(data), 
        .m_axis_tvalid(valid),
        .m_axis_tready(ready)
    );
        
    initial begin
        // init
        clk25 = 1;
        rst = 1;
        ready = 1;
        enable = 1;
                    
        // reset
        #20 rst = 0;

        #500
        ready = 0;
        
        #300
        ready = 1;

        #300
        ready = 0;

        #300
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
