
`timescale 1 ns / 1 ps

module axis_labcontrol_interface #
(
    parameter integer AXIS_DATA_WIDTH = 16,
    parameter integer LC_BUS_WIDTH = 32,
    parameter integer LC_DATA_WIDTH = 16,
    parameter integer LC_ADDR_WIDTH = 8,
    parameter integer LC_SBUS_WIDTH = 3,
    parameter integer LC_RESV_WIDTH = 3,
    parameter integer LC_ADDRESS   = 'hFF,
    parameter integer TWOS_COMPL = 1
)
(
    // System signals
    input  wire                      m_axis_aclk,
    input  wire                      m_axis_aresetn,
    
    // Slave side
    output wire [AXIS_DATA_WIDTH-1:0] m_axis_tdata,
    output wire                      m_axis_tvalid,
    input  wire                      m_axis_tready,
    
    // LabControl Interface
    input wire [7:0]    DIOA,
    input wire [7:0]    DIOB,
    input wire [7:0]    DIOC,
    input wire [7:0]    DIOD
);
    // Split bus into Address, Data, Strobe
    wire [LC_DATA_WIDTH-1:0]        lc_data     = {DIOB, DIOA};
    wire [LC_ADDR_WIDTH-1:0]        lc_address  = DIOC;
    wire [LC_RESV_WIDTH-1:0]        lc_reserved = DIOD[7:5];
    wire [LC_SBUS_WIDTH-1:0]        lc_subbus   = DIOD[4:2];
    wire                            lc_direction= DIOD[1];
    wire                            lc_strobe   = DIOD[0];

    // Generate Address Match
    wire address_match = (lc_address == LC_ADDRESS);
    
    // Create synchronized strobe-pulse 
    wire strobe_sync, strobe_pulse;
    axis_labcontrol_interface_Sync sync_strobe_inst (m_axis_aclk, lc_strobe, strobe_sync);
    axis_labcontrol_interface_Pulse pulse_strobe_inst (m_axis_aclk, strobe_sync, strobe_pulse);
         
    // Generate strobe_pulse
    reg [LC_DATA_WIDTH-1:0]     data_reg;
    reg                         data_valid;
    wire                        data_ready = m_axis_tready;
    always @(posedge m_axis_aclk)
    begin
        if(~m_axis_aresetn)
        begin
            data_reg <= {(LC_DATA_WIDTH){1'b0}};
            data_valid <= 1'b0;
        end else begin
            if(strobe_pulse & address_match)
            begin
                data_valid <= 1'b1;
                data_reg <= lc_data;
            end else
            if(data_valid & data_ready)
            begin
                data_valid <= 1'b0;
            end
        end
    end
    
    localparam SIGN_BIT = (1 << (AXIS_DATA_WIDTH - 1));
    localparam NOSIGN_MASK = (SIGN_BIT - 1);

    //  Connect AXIS Data to LC-Data gathered
    if ( AXIS_DATA_WIDTH == LC_DATA_WIDTH )
        assign m_axis_tdata = data_reg;
    if ( AXIS_DATA_WIDTH < LC_DATA_WIDTH ) 
        assign m_axis_tdata = data_reg[AXIS_DATA_WIDTH-1:0]; // Take LSB's
    if ( AXIS_DATA_WIDTH > LC_DATA_WIDTH )
    begin
      if(TWOS_COMPL)
          assign m_axis_tdata = ((data_reg & NOSIGN_MASK) - (data_reg & SIGN_BIT));
      else
          assign m_axis_tdata = { {(AXIS_DATA_WIDTH - LC_DATA_WIDTH){1'b0}}, data_reg}; 
    end
 
    assign m_axis_tvalid = data_valid;
endmodule

module axis_labcontrol_interface_Sync #(
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

module axis_labcontrol_interface_Pulse #(
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

