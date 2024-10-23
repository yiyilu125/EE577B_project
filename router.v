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
    wire send_req_we;
    wire clear_w;
    wire data_in_w;
    wire empty_e;
    wire grant_e;


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
        .sig_buffer_clear(clear_we),
        .reqL(), 
        .reqR(send_req_we), 
        .reqU(), 
        .reqD(), 
        .reqPE(), 
        .dataoL(), 
        .dataoR(data_in_we), 
        .dataoU(), 
        .dataoD(), 
        .dataoPE()
    );

    input_interface Input_E (
        .clk(clk),
        .rst(reset),
        .si(ewsi),
        .datai(ewdi),
        .ri(ewri),
        .sig_buffer_clear(clear_ew),
        .reqL(), 
        .reqR(send_req_ew), 
        .reqU(), 
        .reqD(), 
        .reqPE(), 
        .dataoL(), 
        .dataoR(data_in_ew), 
        .dataoU(), 
        .dataoD(), 
        .dataoPE()
    );

    input_interface Input_N (
        .clk(clk),
        .rst(reset),
        .si(nssi),
        .datai(nsdi),
        .ri(nsri),
        .sig_buffer_clear(clear_n),
        .reqL(), 
        .reqR(send_req_n), 
        .reqU(), 
        .reqD(), 
        .reqPE(), 
        .dataoL(), 
        .dataoR(data_in_n), 
        .dataoU(), 
        .dataoD(), 
        .dataoPE()
    );

    input_interface Input_S (
        .clk(clk),
        .rst(reset),
        .si(snsi),
        .datai(sndi),
        .ri(snri),
        .sig_buffer_clear(clear_s),
        .reqL(), 
        .reqR(send_req_s), 
        .reqU(), 
        .reqD(), 
        .reqPE(), 
        .dataoL(), 
        .dataoR(data_in_s), 
        .dataoU(), 
        .dataoD(), 
        .dataoPE()
    );

    input_interface Input_PE (
        .clk(clk),
        .rst(reset),
        .si(pesi),
        .datai(pedi),
        .ri(peri),
        .sig_buffer_clear(clear_pe),
        .reqL(), 
        .reqR(send_req_pe), 
        .reqU(), 
        .reqD(), 
        .reqPE(), 
        .dataoL(), 
        .dataoR(data_in_pe), 
        .dataoU(), 
        .dataoD(), 
        .dataoPE()
    );


    // Arbiter
    round_robin_arbiter Arb_E (
        .clk(clk),
        .rst(reset),
        .empty(empty_e),
        .req0(send_req_e),
        .req1(),
        .req2(),
        .req3(),
        .grant(grant_e)
    );

    round_robin_arbiter Arb_W (
        .clk(clk),
        .rst(reset),
        .empty(empty_w),
        .req0(send_req_w),
        .req1(),
        .req2(),
        .req3(),
        .grant(grant_w)
    );

    round_robin_arbiter Arb_N (
        .clk(clk),
        .rst(reset),
        .empty(empty_n),
        .req0(send_req_n),
        .req1(),
        .req2(),
        .req3(),
        .grant(grant_n)
    );

    round_robin_arbiter Arb_S (
        .clk(clk),
        .rst(reset),
        .empty(empty_s),
        .req0(send_req_s),
        .req1(),
        .req2(),
        .req3(),
        .grant(grant_s)
    );

    round_robin_arbiter Arb_PE (
        .clk(clk),
        .rst(reset),
        .empty(empty_pe),
        .req0(send_req_pe),
        .req1(),
        .req2(),
        .req3(),
        .grant(grant_pe)
    );



    opctrl Output_E (
        .clk(clk),
        .reset(reset),
        .polarity(polarity),
        .grant(grant_E),
        .data_in_pe(),
        .data_in_s(),
        .data_in_n(),
        .data_in_e(),
        .data_in_w(data_in_w),
        .receive_output(wero),
        .data_out(wedo),
        .empty(empty_E),
        .send_output(weso),
        .clear_pe(),
        .clear_s(),
        .clear_n(),
        .clear_e(),
        .clear_w(clear_w)
    )








endmodule