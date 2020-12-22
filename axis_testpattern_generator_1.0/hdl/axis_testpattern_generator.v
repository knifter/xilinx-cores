
module axis_testpattern_generator #
(
  parameter integer M00_AXIS_TDATA_WIDTH = 32,
  parameter integer COUNTER_START = 1,
  parameter integer COUNTER_END = 5,
  parameter integer COUNTER_INCR = 1
)
(
  // System signals
  input  wire                        m_axis_aclk,
  input  wire                        m_axis_aresetn,

  // Master side
  input  wire                        m_axis_tready,
  output wire [M00_AXIS_TDATA_WIDTH-1:0] m_axis_tdata,
  output wire                        m_axis_tvalid
);

  reg [M00_AXIS_TDATA_WIDTH-1:0] int_tdata_reg;
  reg int_tvalid_reg;

  always @(posedge m_axis_aclk)
  begin
    if(~m_axis_aresetn)
    begin
      int_tdata_reg <= COUNTER_START; //{(M00_AXIS_TDATA_WIDTH){1'b0}};
      int_tvalid_reg <= 1'b1;
    end
    else
    begin
      if(m_axis_tready == 1)
      begin
        if(int_tdata_reg >= COUNTER_END)
        begin
            int_tdata_reg = COUNTER_START;
        end
        else
        begin
            int_tdata_reg <= int_tdata_reg + COUNTER_INCR;
        end
      end
    end
  end

  always @*
  begin
//    int_tvalid_next = int_tvalid_reg;

//    // If input data changes clock a new output value
//    // if(int_tdata_reg != data_in)
//    // begin
//    //   int_tvalid_next = 1'b1;
//    // end

//    // Acknoledge if the AXIS-Slave has got the data 
//    if(m_axis_tready & int_tvalid_reg)
//    begin
//      int_tvalid_next = 1'b0;
//    end
  end

  assign m_axis_tdata = int_tdata_reg;
  assign m_axis_tvalid = int_tvalid_reg;

endmodule
