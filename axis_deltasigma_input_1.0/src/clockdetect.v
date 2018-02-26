
module ClockDetector #
(
	parameter CLOCK_DETECT_CYCLES  = 255
)
(
    // System signals
    input  wire                        aclk,
    input  wire                        aresetn,

    // Inputs    
    input wire                         clk_in,
    
    //  Outputs
    output wire                        clk_detect_out
);
    parameter CLOCK_DETECT_CYCLES_WIDTH = $clog2(CLOCK_DETECT_CYCLES) + 1;

    reg clk_in_prv;
    always @(posedge aclk)
    begin
        if(~aresetn)
        begin
            clk_in_prv <= 0;
        end else begin
            clk_in_prv <= clk_in;
        end
    end
    wire posedge_clk_in = clk_in && ~clk_in_prv;

    reg [CLOCK_DETECT_CYCLES_WIDTH-1:0] clk_detect_counter;
    wire counter_zero = ~|clk_detect_counter;    
    always @(posedge aclk, negedge aresetn)
    begin
        if(~aresetn)
        begin
            clk_detect_counter <= 0;
        end else 
        begin
            if(posedge_clk_in)
                clk_detect_counter <= CLOCK_DETECT_CYCLES;
            else
                if(~counter_zero)
                    clk_detect_counter <= clk_detect_counter - 1;               
        end
    end
    assign clk_detect_out = ~counter_zero;
endmodule
