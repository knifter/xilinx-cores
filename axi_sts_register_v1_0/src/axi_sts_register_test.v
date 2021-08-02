`timescale 1ns / 1ps

module axi_sts_register_test(
    );
    reg aclk;
    reg aresetn;
    
    localparam STS_DATA_WIDTH = 32;
    localparam AXI_ADDR_WIDTH = 32;
    localparam AXI_DATA_WIDTH = 32;
    
    reg [STS_DATA_WIDTH-1:0] sts_data_in;

    // AXI Master
    // Write channel
    reg [AXI_ADDR_WIDTH-1:0] s_axi_awaddr;  // AXI4-Lite slave: Write address
    reg                      s_axi_awvalid; // AXI4-Lite slave: Write address valid
    wire                     s_axi_awready; // AXI4-Lite slave: Write address ready
    reg [AXI_DATA_WIDTH-1:0] s_axi_wdata;   // AXI4-Lite slave: Write data
    reg                      s_axi_wvalid;  // AXI4-Lite slave: Write data valid
    wire                     s_axi_wready;  // AXI4-Lite slave: Write data ready
    wire                     s_axi_bresp;   // AXI4-Lite slave: Write response
    wire                     s_axi_bvalid;  // AXI4-Lite slave: Write response valid
    reg                      s_axi_bready;  // AXI4-Lite slave: Write response ready
    
    // Read channel
    reg [AXI_ADDR_WIDTH-1:0] s_axi_araddr;  // AXI4-Lite slave: Read address
    reg                      s_axi_arvalid; // AXI4-Lite slave: Read address valid
    wire                     s_axi_arready; // AXI4-Lite slave: Read address ready
    wire [AXI_DATA_WIDTH-1:0] s_axi_rdata;   // AXI4-Lite slave: Read data
    wire [1:0]               s_axi_rresp;   // AXI4-Lite slave: Read data response
    wire                     s_axi_rvalid;  // AXI4-Lite slave: Read data valid
    reg                      s_axi_rready;   // AXI4-Lite slave: Read data ready

//    axi_vip_mst #() MASTER ();
    
    axi_sts_register #(
        .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
        .AXI_DATA_WIDTH(AXI_DATA_WIDTH),
        .STS_DATA_WIDTH(STS_DATA_WIDTH)
    ) DUT (
        .aclk(aclk),
        .aresetn(aresetn),
        
        .sts_data(sts_data_in),
        
        // AXI Slave Interface
        .s_axi_awaddr(s_axi_awaddr),    
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_awready(s_axi_awready),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wvalid(s_axi_wvalid),    
        .s_axi_wready(s_axi_wready),    
        .s_axi_bresp(s_axi_bresp),      
        .s_axi_bvalid(s_axi_bvalid),    
        .s_axi_bready(s_axi_bready),    
        .s_axi_araddr(s_axi_araddr),    
        .s_axi_arvalid(s_axi_arvalid),  
        .s_axi_arready(s_axi_arready),  
        .s_axi_rdata(s_axi_rdata),      
        .s_axi_rresp(s_axi_rresp),      
        .s_axi_rvalid(s_axi_rvalid),    
        .s_axi_rready(s_axi_rready)
    );
    
    initial begin
        aclk = 1;
        aresetn = 0;
        
        // AXI Write, always idle
        s_axi_awaddr = 0;
        s_axi_awvalid = 0;
        s_axi_wdata = 0;
        s_axi_bready = 0;
        s_axi_wvalid = 0;
        
        // Read, idle for now
        s_axi_araddr = 0;
        s_axi_arvalid = 0;
        s_axi_rready = 0;
        
        sts_data_in = 32'h55555555;
        
        #50
        aresetn = 1;
        
        #10
        // Start AXI Read
        s_axi_araddr = 0;
        s_axi_arvalid = 1;
        #10
        s_axi_arvalid = 0;
                
        #30
        s_axi_rready = 1;
        
        #10
        s_axi_rready = 0;
        
        #20
        s_axi_araddr = 4;
        s_axi_arvalid = 1;
        #10
        s_axi_arvalid = 0;
        
    end
    
    always begin
        #5 aclk = ~aclk;
    end
       
endmodule
