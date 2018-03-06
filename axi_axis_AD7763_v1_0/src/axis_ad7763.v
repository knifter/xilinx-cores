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
    
    // AXIS Master side
    output wire [AXIS_DATA_WIDTH-1:0] m_axis_tdata,
    output wire                      m_axis_tvalid,
    input  wire                      m_axis_tready,
    
    // ADC Connections
    input  wire                      adc_sco,       // Serial Clock Out
    input  wire                      adc_fson,      // Frame Sync Out, negated
    input  wire                      adc_sdo        // Serial Data Out
);
    wire frame_sync_in = ~adc_fson;
    wire data_in = adc_sdo;

    // AXI-Stream out
    reg [5:0] cnt_in;
    reg [31:0] shift_in;
    wire cnt_zero = ~|cnt_in;
    reg cnt_zero_prv;
    wire word_ready = (cnt_zero & ~cnt_zero_prv);
    reg [31:0] data_in_reg;
    always @(posedge adc_sco, negedge aresetn)
    begin
        if(~aresetn)
        begin
            cnt_in <= 0;
            cnt_zero_prv <= 1;
            shift_in <= 32'd0;
            data_in_reg <= 32'd0;   
        end else begin

            // shift
            shift_in <= {shift_in[30:0], data_in};

            // start counter on frame_sync_in
            if(frame_sync_in)
            begin
                cnt_in <= 32;
                cnt_zero_prv <= 0;
            end else begin
                // do not keep counting through 0
                if(~cnt_zero)
                    cnt_in <= cnt_in - 32'd1;                    
                cnt_zero_prv <= cnt_zero;
            end
            
            // data_in_reg is ready next cycle
            if(word_ready)
            begin
                data_in_reg <= shift_in;
            end
        end
    end
    assign m_axis_tdata = data_in_reg[31:8];
    
    // Delay tvalid with one cycle (data_in_reg is delayed) and wait for tready before pulling tvalid back down
    reg m_axis_tvalid_reg, m_axis_tvalid_next;
    always @(posedge adc_sco, negedge aresetn)
    begin
        if(~aresetn)
        begin
            m_axis_tvalid_reg <= 1'b0;
        end else begin
            m_axis_tvalid_reg <= m_axis_tvalid_next; // TODO: in here? or outside the if(frame_sync)?
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
    assign m_axis_tvalid = m_axis_tvalid_reg;    
endmodule
