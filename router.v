module router(
    input clk,
    input reset,
    output reg polarity,

    // West to East interface
    input wesi,
    input [63:0] wedi,
    output reg weri,
    output weso,
    input wero,
    output reg [63:0] wedo,

    // East to West interface
    input ewsi,
    input [63:0] ewdi,
    output reg ewri,
    output ewso,
    input ewro,
    output reg [63:0] ewdo,

    // North to South interface
    input nssi,
    input [63:0] nsdi,
    output nsri,
    output nsso,
    input nsro,
    output reg [63:0] nsdo,

    // South to North interface
    input snsi,
    input [63:0] sndi,
    output reg snri,
    output snso,
    input snro,
    output reg [63:0] sndo,

    // NIC & PE interface
    input pesi,
    input [63:0] pedi,
    output reg peri,
    output peso,
    input pero,
    output reg [63:0] pedo
);

    // Internal variable
    wire send_in_w;
    wire clear_w;
    wire data_in_w;
    wire empty_E;


    // Polarity generation
    always @(posedge clk) begin
        if (reset) begin
            polarity <= 1'b0; 
        end else begin
            polarity <= ~polarity;
        end
    end

    // Input Interface
    input_interface Input_W (
        .clk(clk),
        .rst(reset),
        .si(wesi),
        .datai(wedi),
        .ri(weri),
        .sig_buffer_clear(clear_w),
        .reqL(), 
        .reqR(), 
        .reqU(), 
        .reqD(), 
        .reqPE(), 
        .dataoL(), 
        .dataR(), 
        .dataoU(), 
        .dataoD(), 
        .dataoPE()
    );

    round_robin_arbiter Arb_E (
        .clk(clk),
        .rst(reset),
        .empty(empty_E),
        .req0(send),
        .req1(),
        .req2(),
        .req3(),
    );








endmodule