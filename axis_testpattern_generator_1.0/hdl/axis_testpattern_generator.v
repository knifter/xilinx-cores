
module axis_testpattern_generator #
(
  parameter integer M00_AXIS_TDATA_WIDTH = 32,
  parameter integer COUNTER_START = 0,
  parameter integer COUNTER_END = 255,
  parameter integer COUNTER_INCR = 1,
  parameter integer DIVIDER = 5
)
(
  // System signals
  input  wire                        m_axis_aclk,
  input  wire                        m_axis_aresetn,
  input  wire                        enable,
  
  // Master side
  input  wire                        m_axis_tready,
  output wire [M00_AXIS_TDATA_WIDTH-1:0] m_axis_tdata,
  output wire                        m_axis_tvalid
);

  reg [M00_AXIS_TDATA_WIDTH-1:0] counter;
  reg int_tvalid_reg;

  // Divided 'clk'
  // if enable is low, we just stop rolling over the counter. Instead of just pausing the generator this will lengthen the counter increment and it will happen right after enable goes high again (if it was low sufficiently long)
  reg [$clog2(DIVIDER)-1:0] divctr; // FIXME: calc
  always @(posedge m_axis_aclk)
  begin
    if(~m_axis_aresetn)
    begin
        divctr <= 0;
    end
    else
    begin
        divctr <= divctr + 1;
        if(divctr == DIVIDER)
        begin
            if(enable)
                divctr <= 0;
            else
                // Keep it where it's at. This is needed to stop the incr
                divctr <= divctr;
        end
    end
  end
  
  // edge detector
  wire div_edge = ~|divctr;

  // Output counter
  always @(posedge m_axis_aclk)
  begin
    if(~m_axis_aresetn)
    begin
      counter <= COUNTER_END; //{(M00_AXIS_TDATA_WIDTH){1'b0}};
      int_tvalid_reg <= 1'b0;
    end
    else
    begin
      if(div_edge)
      begin
        // incr or wrap counter
        if(counter >= COUNTER_END)
            counter <= counter - (COUNTER_END - COUNTER_START);
        else
            counter <= counter + COUNTER_INCR;
        int_tvalid_reg <= 1;
      end
      else
      begin
        if(m_axis_tready == 1)
            int_tvalid_reg <= 0;
      end
    end
  end
  
  assign m_axis_tdata = counter;
  assign m_axis_tvalid = int_tvalid_reg;
endmodule
