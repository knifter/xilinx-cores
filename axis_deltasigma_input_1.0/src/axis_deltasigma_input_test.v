`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2017 02:28:22 PM
// Design Name: 
// Module Name: axis_deltasigma_input_test
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


module axis_deltasigma_input_test(
    );
    
    reg aclk, aresetn;
    reg ds_clk, ds_data;
    reg ds_clk_en;
    reg enable;
    reg tready;
    wire tvalid;
    wire [7:0] tdata;
    
    axis_deltasigma_input DUT(
        .m_axis_aclk(aclk),
        .m_axis_aresetn(aresetn),
        
        .ds_clk_i(ds_clk & ds_clk_en),
        .ds_data_i(ds_data),
        .enable(enable),
        
        .m_axis_tvalid(tvalid),
        .m_axis_tready(tready),
        .m_axis_tdata(tdata)
        );
        
    initial begin
        aclk = 0;
        aresetn = 0;
        ds_clk_en = 0;
        ds_clk = 0;
        ds_data = 0;
        enable = 0;
        
        #50
        aresetn = 1;
        enable = 1;
        tready = 0;
        
        #300
        ds_data = 1;
        ds_clk_en = 1;
        
        #50
        tready = 1;
        
        #200
        ds_data = 0;
        
        #500
        ds_clk_en = 0;
    end
        
    always begin
        #2.5
        aclk = ~aclk;
    end
    
    always begin
        #104
        ds_clk = ~ds_clk;
    end             
     
endmodule
