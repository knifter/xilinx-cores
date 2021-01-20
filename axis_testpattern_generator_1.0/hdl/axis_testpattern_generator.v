`timescale 1ns / 100ps

module axis_testpattern_generator #
(
  parameter integer M00_AXIS_TDATA_WIDTH = 32,
  parameter integer COUNTER_START = 0,
  parameter integer COUNTER_END = 255,
  parameter integer COUNTER_INCR = 1,
  parameter integer DIVIDER = 8
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

  // Divided 'clk'
  // if enable is low, we just stop rolling over the counter. Instead of just pausing the generator this will lengthen the counter increment and it will happen right after enable goes high again (if it was low sufficiently long)
  reg [$clog2(DIVIDER)-1:0] divctr; // FIXME: calc
  wire divzero = ~|divctr;
  always @(posedge m_axis_aclk, negedge m_axis_aresetn)
  begin
    if(~m_axis_aresetn)
    begin
        divctr <= DIVIDER;
    end
    else
    begin
        divctr <= divctr - 1;
        if(divzero)
            divctr <= DIVIDER;
    end
  end
  wire div_edge = (divzero || DIVIDER == 1) && enable;

  // edge detector, head counter
  reg [M00_AXIS_TDATA_WIDTH-1:0] counter_head;
  always @(posedge m_axis_aclk, negedge m_axis_aresetn)
  begin
    if(~m_axis_aresetn)
    begin
      counter_head <= COUNTER_START; //{(M00_AXIS_TDATA_WIDTH){1'b0}};
    end
    else
    begin
      if(div_edge)
      begin
        // incr & wrap counter
        if(counter_head >= COUNTER_END-COUNTER_INCR+1)
            counter_head <= counter_head + COUNTER_INCR - (COUNTER_END - COUNTER_START) - 1;
        else
            counter_head <= counter_head + COUNTER_INCR;
      end
    end
  end

  // Output register and virtual FIFO Statemachine
  reg [M00_AXIS_TDATA_WIDTH-1:0] counter_tail;
  wire fifo_cnt = |(counter_head - counter_tail);
  reg m_axis_tvalid_reg;
  reg [0:0] state;    
  localparam STATE_INIT	 = 1'd0;
  localparam STATE_RUN   = 1'd1;
  always @(posedge m_axis_aclk, negedge m_axis_aresetn)
  begin
    if(~m_axis_aresetn)
    begin
        counter_tail <= COUNTER_START;
        m_axis_tvalid_reg <= 0;

        state <= STATE_INIT;
    end else 
    case(state)
        STATE_INIT: //0
        begin
            m_axis_tvalid_reg <= 1;
            state <= STATE_RUN;
        end

        STATE_RUN:
        begin
            if(m_axis_tready == 1)
            begin    
                // incr or wrap external counter
                if(fifo_cnt) begin
                    m_axis_tvalid_reg <= 1'b1;

                    if(counter_tail >= COUNTER_END-COUNTER_INCR+1)
                        counter_tail <= counter_tail + COUNTER_INCR - (COUNTER_END - COUNTER_START) - 1;
                    else
                        counter_tail <= counter_tail + COUNTER_INCR;
                end else
                  m_axis_tvalid_reg <= 1'b0;
            end
        end
    endcase
  end
            
  // outputs
  assign m_axis_tdata = counter_tail;
  assign m_axis_tvalid = m_axis_tvalid_reg;
  
  wire data_out_check = m_axis_tvalid & m_axis_tready & m_axis_aclk;
endmodule
