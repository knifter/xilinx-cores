`timescale 1ns / 100ps
module axis_testpattern_generator_roko #
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

  reg [$clog2(COUNTER_END)-1:0] counter;
  reg [$clog2(COUNTER_END)-1:0] int_counter;
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
            divctr <= 0;
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
      counter <= COUNTER_END;
      int_counter <= COUNTER_END;
      int_tvalid_reg <= 1'b0;
    end
    else
    begin
      if((divctr == DIVIDER-1) && enable)
      begin
        // incr or wrap internal counter
        if(int_counter >= COUNTER_END)
          int_counter <= int_counter - (COUNTER_END - COUNTER_START);
        else
          int_counter <= int_counter + COUNTER_INCR;
      end

      if(m_axis_tready == 1)
      begin
        int_tvalid_reg <= 1'b1;
        // incr or wrap external counter
        if((counter < int_counter) || (divctr == DIVIDER && enable && counter == int_counter))
          counter <= counter + COUNTER_INCR;
        else if (counter == COUNTER_END && int_counter != COUNTER_END)
          counter <= counter - (COUNTER_END - COUNTER_START);
        else
          int_tvalid_reg <= 1'b0;
      end
    end
  end
  
  wire data_out_check = m_axis_tvalid & m_axis_tready & m_axis_aclk;
  
  assign m_axis_tdata = counter;
  assign m_axis_tvalid = int_tvalid_reg;
endmodule
