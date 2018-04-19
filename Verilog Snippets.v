// Synchronize signal s from another clock to o on aclk domain
module Sync #(
    parameter STAGES = 2
) (
    input wire      aclk,
    input wire      s,
    output reg      o
);
    
    reg [STAGES-2:0] meta;
    always @(posedge aclk)
    begin
        {o, meta[STAGES-2:0]} <= {meta[STAGES-2:0], s};
    end
    
endmodule

// Synchronized Edge Detector
module EdgeDetector #(
    parameter STAGES = 2
) (
    input wire      aclk,
    input wire      s,
    output wire      p
);
    
    reg prv;
    always @(posedge aclk)
        prv <= s;
    assign p = s & ~prv;
endmodule

