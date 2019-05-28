
`timescale 1 ns / 1 ps

module axis_sniffer_v1_0 #
(
    // Parameters of Axi Slave Bus Interface S_AXIS
    parameter integer AXIS_TDATA_WIDTH	= 32
)
(
    // Users to add ports here

    // User ports ends
    // Do not modify the ports beyond this line

    // For all AXIS
    input wire  aclk,
    input wire  aresetn,

    // Ports of Axi Slave Bus Interface S_AXIS
    output wire  s_axis_tready,
    input wire [AXIS_TDATA_WIDTH-1 : 0] s_axis_tdata,
    input wire  s_axis_tvalid,

    // Ports of Axi Master Bus Interface M_AXIS
    output wire  m_axis_tvalid,
    output wire [AXIS_TDATA_WIDTH-1 : 0] m_axis_tdata,
    input wire  m_axis_tready,

    // Ports of Axi Master Bus Interface M_AXIS_SNIF
    output wire  m_axis_snif_tvalid,
    output wire [AXIS_TDATA_WIDTH-1 : 0] m_axis_snif_tdata
);
// Slave-Master pass-through
assign m_axis_tdata = s_axis_tdata;
assign s_axis_tready = m_axis_tready;
assign m_axis_tvalid = s_axis_tvalid;

// Sniffer link
assign m_axis_snif_tdata = s_axis_tdata;
assign m_axis_snif_tvalid = s_axis_tvalid;

endmodule
