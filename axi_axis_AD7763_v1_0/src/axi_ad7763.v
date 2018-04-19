`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2017 11:37:48 AM
// Design Name: 
// Module Name: axi_ad7763
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


module axi_ad7763 #
(
    parameter integer AXI_DATA_WIDTH = 32,
    parameter integer AXI_ADDR_WIDTH = 12
)
(
    // System signals
    input  wire                      aclk,
    input  wire                      aresetn,
    
    // AXI Slave side
    input  wire [AXI_ADDR_WIDTH-1:0] s_axi_awaddr,  // AXI4-Lite slave: Write address
    input  wire                      s_axi_awvalid, // AXI4-Lite slave: Write address valid
    output wire                      s_axi_awready, // AXI4-Lite slave: Write address ready
    input  wire [AXI_DATA_WIDTH-1:0] s_axi_wdata,   // AXI4-Lite slave: Write data
    input  wire                      s_axi_wvalid,  // AXI4-Lite slave: Write data valid
    output wire                      s_axi_wready,  // AXI4-Lite slave: Write data ready
    output wire [1:0]                s_axi_bresp,   // AXI4-Lite slave: Write response
    output wire                      s_axi_bvalid,  // AXI4-Lite slave: Write response valid
    input  wire                      s_axi_bready,  // AXI4-Lite slave: Write response ready
    input  wire [AXI_ADDR_WIDTH-1:0] s_axi_araddr,  // AXI4-Lite slave: Read address
    input  wire                      s_axi_arvalid, // AXI4-Lite slave: Read address valid
    output wire                      s_axi_arready, // AXI4-Lite slave: Read address ready
    output wire [AXI_DATA_WIDTH-1:0] s_axi_rdata,   // AXI4-Lite slave: Read data
    output wire [1:0]                s_axi_rresp,   // AXI4-Lite slave: Read data response
    output wire                      s_axi_rvalid,  // AXI4-Lite slave: Read data valid
    input  wire                      s_axi_rready,  // AXI4-Lite slave: Read data ready
        
    // ADC Connections
    input  wire                      adc_sco,       // Serial Clock Out
    output wire                      adc_fsin,      // Frame Sync In, negated
    output wire                      adc_sdi        // Serial Data In
);

    reg frame_sync_out;
    assign adc_fsin = ~frame_sync_out;        
     
    // Always ready for writing address & data    
    assign s_axi_awready = 1'b1;
    
    // Send response
    // Manage bvalid = 1 after wvalid = 1
    reg int_bvalid_reg, int_bvalid_next;
    always @(posedge aclk, negedge aresetn)
    begin
        if(~aresetn)
        begin
          int_bvalid_reg <= 1'b0;
        end
        else
        begin
          int_bvalid_reg <= int_bvalid_next;
        end
    end
    always @*
    begin
        int_bvalid_next = int_bvalid_reg;
    
        if(s_axi_wvalid)
        begin
          int_bvalid_next = 1'b1;
        end
        
        if(s_axi_bready & int_bvalid_reg)
        begin
          int_bvalid_next = 1'b0;
        end
    end
    assign s_axi_bvalid = int_bvalid_reg;
    assign s_axi_bresp = 2'b0;                  // OKAY
    
    // Latch wdata into our shift register
    reg [31:0] int_wdata_reg;
    reg int_wdata_available_reg;
    reg int_wdata_available_next;
    always @(posedge aclk, negedge aresetn)
    begin
        if(~aresetn)
        begin
            int_wdata_reg <= 32'd0;
            int_wdata_available_reg <= 1'b0;
        end
        else
        begin
            int_wdata_available_reg <= int_wdata_available_next;
            if(s_axi_wvalid && s_axi_wready)
            begin
                int_wdata_reg <= s_axi_wdata;
            end
        end
    end
    always @*
    begin
        int_wdata_available_next = int_wdata_available_reg;
        if(s_axi_wvalid)
        begin
            int_wdata_available_next = 1'b1;
        end
        
        if(frame_sync_out & int_wdata_available_reg)
        begin
            int_wdata_available_next = 1'b0;
        end
    end
    
    // Set wready = 0 while working
    reg s_axi_wready_reg;
    reg out_wready_next;
    always @(posedge aclk, negedge aresetn)
    begin
        if(~aresetn)
        begin
            s_axi_wready_reg <= 0;
        end else begin
            s_axi_wready_reg <= out_wready_next;
        end
    end
    always @*
    begin
        out_wready_next = s_axi_wready_reg;
        if(state == STATE_IDLE)
        begin
            out_wready_next = 1'b1;
        end else begin
            out_wready_next = 1'b0;
        end
    end
    assign s_axi_wready = s_axi_wready_reg;

    // tie off other signal lines
    assign s_axi_arready = 1'd0; // Not ready to read address
    assign s_axi_rdata = 32'b0;     // Read Data channel
    assign s_axi_rresp = 2'b11;  // Response Code: DECERR
    assign s_axi_rvalid = 1'b0; // Not valid
    
    // Write REGs (ADC CLK)
    wire wdata_available_sync;
    axi_ad7763_Sync sync0(adc_sco, wdata_available_sync, int_wdata_available_reg); 
    
    reg [3:0] state;    
    localparam STATE_IDLE			= 4'b0000;
    localparam STATE_START          = 4'b0001;
    localparam STATE_FIRST          = 4'b0010;
    localparam STATE_SHIFTING       = 4'b0011;
    reg [31:0] shift_out;
    reg [5:0] cnt_out;
    always @(posedge adc_sco, negedge aresetn)
    begin
        if(~aresetn)
        begin
            shift_out <= 32'd0;
            frame_sync_out <= 0;
            cnt_out <= 0;
            
            state <= STATE_IDLE;
        end
        else begin
            case(state)
                // ready for action when wdata_available
                STATE_IDLE:
                begin
                    if(wdata_available_sync) // TODO int_wdata is being set at the same time!
                    begin
                        shift_out <= int_wdata_reg;
                        state <= STATE_START;
                    end
                end

                // Start control word by pulsing frame_sync_out
                STATE_START: 
                begin
                    frame_sync_out <= 1;
                    
                    state <= STATE_FIRST;
                end
                
                // frame_sync down and first bit on the shifter
                STATE_FIRST:
                begin
                    cnt_out <= 31;
                    frame_sync_out <= 0;
                    
                    state <= STATE_SHIFTING;
                end
                
                // shift the other bits out
                STATE_SHIFTING: 
                begin
                    cnt_out <= cnt_out - 6'd1;
                    shift_out <= {shift_out[30:0], 1'b0};
                    if(~|cnt_out) begin
                        state <= STATE_IDLE;
                    end
                end
            endcase
        end
    end    
    assign adc_sdi = shift_out[31];
endmodule

module axi_ad7763_Sync #(
    parameter STAGES = 2
) (
    input wire      aclk,
    output reg      o,
    input wire      s
);
    
    reg [STAGES-2:0] meta;
    always @(posedge aclk)
    begin
        {o, meta[STAGES-2:0]} <= {meta[STAGES-2:0], s};
    end
    
endmodule