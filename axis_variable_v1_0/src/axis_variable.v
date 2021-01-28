
`timescale 1 ns / 1 ps

module axis_variable #
(
  parameter integer AXIS_TDATA_WIDTH = 32
)
(
  // System signals
  input  wire                        m_axis_aclk,
  input  wire                        m_axis_aresetn,

  input  wire [AXIS_TDATA_WIDTH-1:0] data_in,

  // Master side
  input  wire                        m_axis_tready,
  output wire [AXIS_TDATA_WIDTH-1:0] m_axis_tdata,
  output wire                        m_axis_tvalid
);

  reg [AXIS_TDATA_WIDTH-1:0] int_tdata_reg;
  reg int_tvalid_reg, int_tvalid_next;

  always @(posedge m_axis_aclk)
  begin
    if(~m_axis_aresetn)
    begin
      int_tdata_reg <= {(AXIS_TDATA_WIDTH){1'b0}};
      int_tvalid_reg <= 1'b0;
    end
    else
    begin
      int_tdata_reg <= data_in;
      int_tvalid_reg <= int_tvalid_next;
    end
  end

  always @*
  begin
    int_tvalid_next = int_tvalid_reg;

    // If input data changes clock a new output value
    if(int_tdata_reg != data_in)
    begin
      int_tvalid_next = 1'b1;
    end

    // Acknoledge if the AXIS-Slave has got the data 
    if(m_axis_tready & int_tvalid_reg)
    begin
      int_tvalid_next = 1'b0;
    end
  end

  assign m_axis_tdata = int_tdata_reg;
  assign m_axis_tvalid = int_tvalid_reg;

endmodule
