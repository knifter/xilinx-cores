`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2017 11:37:06 AM
// Design Name: 
// Module Name: axis_ad7763
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


module axis_ad7763 #
(
    parameter integer AXIS_DATA_WIDTH = 24
)
(
    input  wire                      aresetn,
    input  wire                      aclk,          // ADC Serial Clock & M_AXIS clk
    
    // AXIS Master side
    output wire [AXIS_DATA_WIDTH-1:0] m_axis_tdata,
    output wire                      m_axis_tvalid,
    input  wire                      m_axis_tready,
    
    // ADC Connections
    input  wire                      adc_dreadyn,      // Frame Sync Out, negated
    input  wire                      adc_sdo        // Serial Data Out
);
    wire data_ready_in = ~adc_dreadyn;
    wire data_in = adc_sdo;

    // AXI-Stream out
    reg [5:0] cnt_in;
    reg [31:0] shift_in;
    wire cnt_zero = ~|cnt_in;
    reg cnt_zero_prv;
    wire word_ready = (cnt_zero & ~cnt_zero_prv);
    reg [23:0] data_in_reg;
//    reg [6:0] status_in_reg;
    always @(posedge aclk, negedge aresetn)
    begin
        if(~aresetn)
        begin
            cnt_in <= 6'd0;
            cnt_zero_prv <= 1;
            shift_in <= 32'd0;
            data_in_reg <= 32'd0;
//            status_in_reg <= 7'd0;   
        end else begin

            // shift
            shift_in <= {shift_in[30:0], data_in};

            // start counter on frame_sync_in
            if(data_ready_in)
            begin
                cnt_in <= 6'd32;
                cnt_zero_prv <= 0;
            end else begin
                // do not keep counting through 0
                if(~cnt_zero)
                    cnt_in <= cnt_in - 6'd1;                    
                cnt_zero_prv <= cnt_zero;
            end
            
            // data_in_reg is ready next cycle
            if(word_ready)
            begin
                data_in_reg <= shift_in[31:8];
//                status_in_reg <= shift_in[7:1];
            end
        end
    end
//    wire status_address = status_in_reg[7:5];
//    wire status_dvalid = status_in_reg[4];
//    wire status_ovr = status_in_reg[3];
//    wire status_lpwr = status_in_reg[2];
//    wire status_filter_ok = status_in_reg[1]; 
    
    // Delay tvalid with one cycle (data_in_reg is delayed) and wait for tready before pulling tvalid back down
    reg m_axis_tvalid_reg, m_axis_tvalid_next;
    always @(posedge aclk, negedge aresetn)
    begin
        if(~aresetn)
        begin
            m_axis_tvalid_reg <= 1'b0;
        end else begin
            m_axis_tvalid_reg <= m_axis_tvalid_next;
        end
    end
    always @*
    begin
        m_axis_tvalid_next = m_axis_tvalid_reg;
        if(word_ready)
            m_axis_tvalid_next = 1;
        if(m_axis_tready & m_axis_tvalid_reg)
            m_axis_tvalid_next = 0;
    end
    assign m_axis_tdata = data_in_reg;
    assign m_axis_tvalid = m_axis_tvalid_reg;    
endmodule
