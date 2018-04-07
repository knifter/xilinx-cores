
`timescale 1 ns / 1 ps

module axi_axis_reader #
(
  parameter integer AXI_DATA_WIDTH = 32,
  parameter integer AXI_ADDR_WIDTH = 12,
  parameter integer AXIS_DATA_WIDTH = 32,
  parameter integer TWOS_COMPL = 1
)
(
  // System signals
  input  wire                      aclk,
  input  wire                      aresetn,

  // Slave side
  input  wire [AXI_ADDR_WIDTH-1:0] s_axi_awaddr,  // AXI4-Lite slave: Write address
  input  wire                      s_axi_awvalid, // AXI4-Lite slave: Write address valid
  output wire                      s_axi_awready, // AXI4-Lite slave: Write address ready
  input  wire [AXI_DATA_WIDTH-1:0] s_axi_wdata,   // AXI4-Lite slave: Write data
  input  wire                      s_axi_wvalid,  // AXI4-Lite slave: Write data valid
  output wire                      s_axi_wready,  // AXI4-Lite slave: Write data ready
  output wire [1:0]                s_axi_bresp,   // AXI4-Lite slave: Write response
  output wire                      s_axi_bvalid,  // AXI4-Lite slave: Write response valid
  input  wire                      s_axi_bready,  // AXI4-Lite slave: Write response ready
  input  wire [AXI_ADDR_WIDTH-1:0] s_axi_araddr,  // AXI4-Lite slave: Read address
  input  wire                      s_axi_arvalid, // AXI4-Lite slave: Read address valid
  output wire                      s_axi_arready, // AXI4-Lite slave: Read address ready
  output wire [AXI_DATA_WIDTH-1:0] s_axi_rdata,   // AXI4-Lite slave: Read data
  output wire [1:0]                s_axi_rresp,   // AXI4-Lite slave: Read data response
  output wire                      s_axi_rvalid,  // AXI4-Lite slave: Read data valid
  input  wire                      s_axi_rready,  // AXI4-Lite slave: Read data ready

  // Slave side
  input  wire [AXIS_DATA_WIDTH-1:0] s_axis_tdata,
  input  wire                      s_axis_tvalid,
  output wire                      s_axis_tready
);

    localparam SIGN_BIT = (1 << (AXIS_DATA_WIDTH - 1));
    localparam NOSIGN_MASK = (SIGN_BIT - 1);
   
  wire [AXI_DATA_WIDTH-1:0] s_axis_tdata_sized;
  // S_AXIS_DATA_WIDTH == S_AXI_DATA_WIDTH
  if ( AXIS_DATA_WIDTH == AXI_DATA_WIDTH )  // -> [01234567]
    assign s_axis_tdata_sized = s_axis_tdata;
  if ( AXIS_DATA_WIDTH > AXI_DATA_WIDTH ) // -> [0123]4567
    assign s_axis_tdata_sized = s_axis_tdata[AXIS_DATA_WIDTH-1:(AXIS_DATA_WIDTH-AXI_DATA_WIDTH)];
  if ( AXIS_DATA_WIDTH < AXI_DATA_WIDTH ) // [<SIGN>/<0>][S123456789]
  begin
    if(TWOS_COMPL)
        assign s_axis_tdata_sized = ((s_axis_tdata & NOSIGN_MASK) - (s_axis_tdata & SIGN_BIT));
    else
        assign s_axis_tdata_sized = { {(AXI_DATA_WIDTH - AXIS_DATA_WIDTH){1'b0}}, s_axis_tdata}; 
  end

  reg int_rvalid_reg, int_rvalid_next;
  reg [AXI_DATA_WIDTH-1:0] int_rdata_reg, int_rdata_next;
  always @(posedge aclk)
  begin
    if(~aresetn)
    begin
      int_rvalid_reg <= 1'b0;
      int_rdata_reg <= {(AXI_DATA_WIDTH){1'b0}};
    end
    else
    begin
      int_rvalid_reg <= int_rvalid_next;
      int_rdata_reg <= int_rdata_next;
    end
  end
  always @*
  begin
    int_rvalid_next = int_rvalid_reg;
    int_rdata_next = int_rdata_reg;

    if(s_axi_arvalid)
    begin
      int_rvalid_next = 1'b1;
      int_rdata_next = s_axis_tvalid ? s_axis_tdata_sized : {(AXI_DATA_WIDTH){1'b0}};            
    end

    if(s_axi_rready & int_rvalid_reg)
    begin
      int_rvalid_next = 1'b0;
    end
  end

  assign s_axi_rresp = 2'd0;

  assign s_axi_arready = 1'b1;
  assign s_axi_rdata = int_rdata_reg;
  assign s_axi_rvalid = int_rvalid_reg;

  assign s_axis_tready = s_axi_rready & int_rvalid_reg;

  assign s_axi_awready = 0;
  assign s_axi_wready = 0;
  assign s_axi_bresp = 2'b00;
  assign s_axi_bvalid = 0;
endmodule
