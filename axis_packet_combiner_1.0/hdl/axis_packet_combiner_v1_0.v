
`timescale 1 ns / 1 ps

module axis_packet_combiner #
(
    // Users to add parameters here
    parameter integer AXIS_TDATA_WIDTH = 32,
    parameter integer PACKETS_PER_PACKET = 256,
    parameter integer DISCARD_FIRST_PACKET = 1
)
(
    input  wire                        axis_aclk,
    input  wire                        axis_aresetn,
    
    output  wire                       s_axis_tready,
    input  wire [AXIS_TDATA_WIDTH-1:0] s_axis_tdata,
    input  wire                        s_axis_tvalid,
    input  wire                        s_axis_tlast,

    input  wire                        m_axis_tready,
    output wire [AXIS_TDATA_WIDTH-1:0] m_axis_tdata,
    output wire                        m_axis_tvalid,
    output wire                        m_axis_tlast,
    
    output wire                        synced_out
);
    wire data_valid = s_axis_tready & s_axis_tvalid;
    wire data_last_valid = data_valid & s_axis_tlast;
    
    // detect the first tlast = 1 to prevent sending half input packets
    // Note: tlast can be tied to 1 in which case packet_len = 1 and counte counts samples instead of packets
    reg synced;
    always @(posedge axis_aclk, negedge axis_aresetn)
    begin
        if(~axis_aresetn)
        begin
            if(DISCARD_FIRST_PACKET)
                synced <= 0;
            else
                synced <= 1;
        end else begin   
            // skip everything until we've seen the last sample from a packet
            if(data_last_valid)
            begin
                synced <= 1;
            end
        end
    end

    // Count packets in inputstream
    reg [$clog2(PACKETS_PER_PACKET)-1:0] ip_cnt;
    wire op_end = ~|ip_cnt;
    always @(posedge axis_aclk, negedge axis_aresetn)
    begin
        if(~axis_aresetn)
        begin
            ip_cnt <= PACKETS_PER_PACKET - 1;
        end
        else
        begin
            if(data_last_valid && synced)
            begin
                if(op_end) begin
                    ip_cnt <= PACKETS_PER_PACKET - 1;
                end else begin
                    ip_cnt <= ip_cnt - 1;
                end
            end
        end
    end
  
    wire gen_tlast = op_end && synced && data_last_valid;

    assign s_axis_tready = m_axis_tready;

    assign m_axis_tvalid = s_axis_tvalid & synced;
    assign m_axis_tdata = s_axis_tdata;
    assign m_axis_tlast = gen_tlast;

    assign synced_out = synced;
endmodule
