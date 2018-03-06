`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/10/2017 03:34:13 PM
// Design Name: 
// Module Name: ad5791_axi_control
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


module AD5791_AXO_Control #
(
    parameter integer AXI_DATA_WIDTH = 32,
    parameter integer AXI_ADDR_WIDTH = 10
)
(
    input  wire                      s_axi_aclk,
    input  wire                      s_axi_aresetn,
    
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

    input  wire                      data_aclk,
    input  wire                      data_aresetn,
    output wire [AXI_DATA_WIDTH-1:0] data_out,
    output wire                      data_valid,
    input  wire                      data_ready
    );
    
    // AXI: Always ready for unimplemented things ;)
    assign s_axi_awready = 1'b1;    // Ready for write address (ignored)
    assign s_axi_arready = 1'd0;    // Not ready for read address (would not now what to return)
    assign s_axi_rdata = 32'b0;     // Read Data channel
    assign s_axi_rresp = 2'b11;     // Response Code: DEC(ode)ERR(or)
    assign s_axi_rvalid = 1'b0;     // Reading is Not valid, unsupported

    // AXI: Send response
    // Always send an OK response immidiately after wvalid = 1
    reg int_bvalid_reg, int_bvalid_next;
    always @(posedge s_axi_aclk, negedge s_axi_aresetn)
    begin
        if(~s_axi_aresetn)
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
    assign s_axi_bresp = 2'b0;                  // OKAY
    assign s_axi_bvalid = int_bvalid_reg;

    // clk(AXI): Accept wdata as soon as possible
    reg [AXI_DATA_WIDTH-1:0] wdata_latch, wdata_latch_next;
    reg                      wdata_latch_valid, wdata_latch_valid_next;
    wire                     wdata_latch_ready;
    always @(posedge s_axi_aclk, negedge s_axi_aresetn)
    begin
        if(~s_axi_aresetn)
        begin
            wdata_latch <= 'd0;
            wdata_latch_valid <= 1'b0;
        end else begin
            wdata_latch <= wdata_latch_next;
            wdata_latch_valid <= wdata_latch_valid_next;
        end
    end
    always @(*)
    begin
        wdata_latch_next = wdata_latch;
        wdata_latch_valid_next = wdata_latch_valid;
        if(s_axi_wvalid & ~wdata_latch_valid) // & wdata_latch_ready))
        begin
            wdata_latch_valid_next = 1'b1;
            wdata_latch_next = s_axi_wdata;
        end
        if(wdata_latch_valid & wdata_latch_ready)
        begin
            wdata_latch_valid_next = 1'b0;
        end
    end
    assign s_axi_wready = ~wdata_latch_valid & ~axi_data_valid_reg;
    
    // SYNC data_valid clk(axi)->clk(axis)
    reg wdata_valid_meta;
    always @(posedge data_aclk, negedge data_aresetn)
    begin
        if(~data_aresetn)
        begin
            wdata_valid_meta <= 1'b0;
        end else begin
            wdata_valid_meta <= wdata_latch_valid;
        end
    end

    // Sync data & valid into data_clk    
    reg [AXI_DATA_WIDTH-1:0]    data_out_reg, data_out_next;
    reg                         data_valid_reg, data_valid_next;
    always @(posedge data_aclk, negedge data_aresetn)
    begin
        if(~data_aresetn)
        begin
            data_valid_reg <= 0;
            data_out_reg <= 'd0;
        end else begin
            data_valid_reg <= data_valid_next;
            data_out_reg <= data_out_next;
        end
    end
    always @(*)
    begin
            data_valid_next = data_valid_reg;
            data_out_next = data_out_reg;
            if(wdata_valid_meta & ~data_valid)
            begin
                data_valid_next = 1;
                data_out_next = wdata_latch;
            end
            if(data_ready & data_valid)
            begin
                data_valid_next = 0;
            end
    end
    assign data_valid = data_valid_reg;
    assign data_out = data_out_reg;

    // return data_ready into the s_axi_clk domain
    reg axi_data_ready_meta, axi_data_ready_reg;
    always @(posedge s_axi_aclk, negedge s_axi_aresetn)
    begin
        if(~s_axi_aresetn)
        begin
            axi_data_ready_meta <= 1'b0;
            axi_data_ready_reg <= 1'b0;
        end else begin
            axi_data_ready_meta <= data_ready;
            axi_data_ready_reg <= axi_data_ready_meta;
        end
    end
    // return data_valid into the s_axi_clk domain
    reg axi_data_valid_meta, axi_data_valid_reg;
    always @(posedge s_axi_aclk, negedge s_axi_aresetn)
    begin
        if(~s_axi_aresetn)
        begin
            axi_data_valid_meta <= 1'b0;
            axi_data_valid_reg <= 1'b0;
        end else begin
            axi_data_valid_meta <= data_valid;
            axi_data_valid_reg <= axi_data_valid_meta;
        end
    end
    assign wdata_latch_ready = axi_data_valid_reg;
    
    
endmodule
