`timescale 1ns / 1ps
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


module axis_ad5791_test (   );
    localparam DATA_WIDTH = 24;

    // CLK & RST
    reg clk25;
    reg rst;
        
    // AXIS Master side
    reg [DATA_WIDTH-1:0]   data;
    reg                    valid;
    wire                   ready;
        
    // ADC Connections
    wire               dac_sclk;      // Serial Clock Out
    wire               dac_sdi;       // Serial Data In
    wire               dac_syncn;     // Frame Sync Out, negated
    
    axis_AD5791 #(
        .AXIS_DATA_WIDTH(DATA_WIDTH)
    ) DUT (
        .s_axis_aclk(clk25),
        .s_axis_aresetn(~rst),
            
        // AXI-Stream
        .s_axis_tdata(data), 
        .s_axis_tvalid(valid),
        .s_axis_tready(ready),
             
        // DAC Connections
        .dac_sclk(dac_sclk),
        .dac_sdi(dac_sdi),
        .dac_syncn(dac_syncn)
    );
        
    initial begin
        // init
        clk25 = 0;
        rst = 1;
        data = 32'h0000;
        valid = 0;
                    
        // reset
        #40 rst = 0;
            
        #40 data = 24'b000010000000011000000001;
        #40 valid = 1;
        #40 valid = 0;
        
        #900 data = 24'b000010000000011000000010;
        #40 valid = 1;
        #60  valid = 0;
    end
        
    // Generate CLK 25 MHz
    always
    begin
        #20
        clk25 = ~clk25;
    end
endmodule
