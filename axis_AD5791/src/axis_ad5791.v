`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2017 02:21:33 PM
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

module axis_AD5791 #(
        parameter AXIS_DATA_WIDTH = 24
    )(
        input wire                          s_axis_aclk,
        input wire                          s_axis_aresetn,
        
        input wire [AXIS_DATA_WIDTH-1:0]    s_axis_tdata,
        input wire                          s_axis_tvalid,
        output wire                         s_axis_tready,
       
        output wire                         dac_sclk,
        output wire                         dac_sdi,
        output wire                         dac_syncn,
        output wire                         dac_ldacn
    );
    
    //  AXI-Stream Contract
    //   1. valid = 1, ready = 0 -> There is data waiting
    //   2. valid = 0, ready = 1 -> Ready to accept data
    //   3. valid = 1, ready = 1 -> Data is copied this cycle
    //   4. after 3, master should make valid = 0 or present new data

    // Convert Data Width
    wire [23:0] data_in;
    if(AXIS_DATA_WIDTH < 24)
        assign data_in = {s_axis_tdata, {(24 - AXIS_DATA_WIDTH){1'b0}}};
    else
        assign data_in = s_axis_tdata[23:0];

    reg data_ready_reg;
    assign s_axis_tready = data_ready_reg;
    
    // FSM: Write REGs (ADC CLK)
    localparam STATE_IDLE           = 3'b001;
    localparam STATE_START          = 3'b010;
    localparam STATE_SHIFTING       = 3'b100;
    reg [2:0] state;    
    reg [23:0] shift_out;
    reg [5:0] cnt_out;
    wire frame_sync = (state != STATE_IDLE);
    always @(posedge s_axis_aclk, negedge s_axis_aresetn)
    begin
        if(~s_axis_aresetn)
        begin
            shift_out <= 32'd0;
            cnt_out <= 0;
            data_ready_reg <= 0;
    
            state <= STATE_IDLE;
        end
        else begin

            case(state)
                // ready for action when wdata_available
                STATE_IDLE: // 0
                begin
                    if(s_axis_tvalid)
                    begin
                        shift_out <= data_in;
                        state <= STATE_START;
                        data_ready_reg <= 0;
                    end else
                        data_ready_reg <= 1;
                end
        
                STATE_START: //1
                begin
                    cnt_out <= 6'd22;
                    shift_out <= {shift_out[22:0], 1'b0};
                    
                    state <= STATE_SHIFTING;
                end
        
                // shift the other bits out
                STATE_SHIFTING: // 3
                begin
                    cnt_out <= cnt_out - 6'd1;
                    shift_out <= {shift_out[22:0], 1'b0};
                    
                    if(~|cnt_out) begin
                        state <= STATE_IDLE;
                        data_ready_reg <= 1;
                    end
                end
            endcase
        end
    end    

    assign dac_sclk = s_axis_aclk;
    assign dac_syncn = ~frame_sync;        
    assign dac_sdi = shift_out[23];
    assign dac_ldacn = 1'b0;
endmodule
