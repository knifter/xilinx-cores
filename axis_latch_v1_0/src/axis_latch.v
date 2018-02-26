
`timescale 1 ns / 1 ps

module axis_latch #
(
  parameter integer AXIS_TDATA_WIDTH = 32
)
(
    // System signals
    input  wire                        aclk,
    input  wire                        aresetn,
    
    // Slave AXI4-Stream setting the constant
    input wire  [AXIS_TDATA_WIDTH-1:0] s_axis_tdata,
    input wire                         s_axis_tvalid,
    output wire                        s_axis_tready,
    
    // Master side
    output wire [AXIS_TDATA_WIDTH-1:0] m_axis_tdata,
    output wire                        m_axis_tvalid,
    input wire                         m_axis_tready
);

    reg [AXIS_TDATA_WIDTH-1:0]  data_reg;
    reg                         data_valid;

    assign m_axis_tdata = data_reg;    
    assign s_axis_tready = 1'b1;

    always @(posedge aclk)
    begin
        if(~aresetn)
        begin
            data_valid <= 1'b0;
            data_reg <= 'd0;
        end else begin
            if(s_axis_tvalid)
            begin
                data_reg <= s_axis_tdata;
                data_valid <= 1'b1; // remains 1 after first write
            end
        end
    end
    assign m_axis_tvalid = data_valid;
endmodule
