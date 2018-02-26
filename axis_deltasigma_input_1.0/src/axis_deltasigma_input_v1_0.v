
`timescale 1 ns / 1 ps

	module axis_deltasigma_input #
	(
		// Parameters of Axi Master Bus Interface M00_AXIS
		parameter integer AXIS_TDATA_WIDTH	= 8,
		parameter TWOS_COMPL           = 1,
		parameter CLOCK_DETECT_CYCLES  = 255
	)
	(
        // System signals
        input  wire                        m_axis_aclk,
        input  wire                        m_axis_aresetn,
           
        // Master AXIS side
        input  wire                        m_axis_tready,
        output wire  [AXIS_TDATA_WIDTH-1:0] m_axis_tdata,
        output reg                         m_axis_tvalid,
    
    	//  Input Side
    	input wire                         ds_clk_i,
    	input wire                         ds_data_i,
    	input wire                         enable,
    	
    	//  Outputs
    	output wire                        clk_detect
	);
    
    // sample the data line on the incoming clock
//    reg ds_data_reg = 0;
//    always @(posedge ds_clk_i)
//    begin
//        ds_data_reg <= ds_data_i;
//    end
    
    wire ds_clk_sync, ds_clk_pulse;
    Sync sync_ds_clk0 (m_axis_aclk, ds_clk_i, ds_clk_sync);
    Pulse pulse_ds_clk0 (m_axis_aclk, ds_clk_sync, ds_clk_pulse);

    // Output to M_AXIS
    reg data;
    always @(posedge m_axis_aclk, negedge m_axis_aresetn)
    begin
        if(~m_axis_aresetn)
        begin
            m_axis_tvalid <= 0;
            data <= 0;
        end else begin
            if(ds_clk_pulse && enable)
            begin
                m_axis_tvalid <= 1;
                data <= ds_data_i; 
            end else 
            if(m_axis_tready & m_axis_tvalid)
            begin
                m_axis_tvalid <= 0;
            end
        end
    end
 
    if(TWOS_COMPL == 1)
        // either 1 or -1
        assign m_axis_tdata = (data == 1) ? { {(AXIS_TDATA_WIDTH-1){1'b0}}, 1'b1} : { {(AXIS_TDATA_WIDTH-1){1'b1}} ,1'b1};
    else
        // either 1 or 0 
        assign m_axis_tdata = (data == 1) ? { {(AXIS_TDATA_WIDTH-1){1'b0}}, 1'b1} : { {(AXIS_TDATA_WIDTH-1){1'b0}} ,1'b0}; 
 
    // Synchronize data to our target clock domain
//    reg tmp_data_reg;
//    reg tmp_clk_reg;
//    always @(posedge m_axis_aclk, negedge m_axis_aresetn)
//    begin
//        if(~m_axis_aresetn) 
//        begin
//            tmp_clk_reg <= 0;
////            tmp_data_reg <= 0;
//        end else begin
//            tmp_clk_reg <= ds_clk_i;
////            tmp_data_reg <= ds_data_reg;
//        end
//    end
//    reg int_data_reg;
//    reg int_clk_reg;
//    always @(posedge m_axis_aclk)
//    begin
//        int_data_reg <= ds_data_reg;
//        int_clk_reg <= tmp_clk_reg;
//    end
    
//    // Sample the data line in our local clock domain
//    reg int_clk_prv;
//    always @(posedge m_axis_aclk)
//    begin
//        int_clk_prv <= int_clk_reg;
//    end
//    reg m_axis_tvalid_reg;
//    wire posedge_clk_in = (int_clk_prv == 0 && int_clk_reg == 1);

    
    // Clock detector
    ClockDetector #(
        .CLOCK_DETECT_CYCLES(CLOCK_DETECT_CYCLES)
    ) clkdet0 (
        .aclk(m_axis_aclk),
        .aresetn(m_axis_aresetn),
        .clk_in(ds_clk_sync),
        .clk_detect_out(clk_detect)
    );
        
	endmodule

module Sync #(
    parameter STAGES = 2
) (
    input wire      aclk,
    input wire      s,
    output reg      o
);
    
    reg [STAGES-2:0] meta;
    always @(posedge aclk)
    begin
        {o, meta[STAGES-2:0]} <= {meta[STAGES-2:0], s};
    end
    
endmodule

module Pulse #(
    parameter STAGES = 2
) (
    input wire      aclk,
    input wire      s,
    output wire      p
);
    
    reg prv;
    always @(posedge aclk)
        prv <= s;
    assign p = s & ~prv;
endmodule

