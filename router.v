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
    wire send_req_wn;
    wire send_req_nw;
    wire send_req_ws;
    wire send_req_sw;
    wire send_req_we;
    wire send_req_ew;
    wire send_req_wp;
    wire send_req_pw;
    wire send_req_ns;
    wire send_req_sn;
    wire send_req_ne;
    wire send_req_en;
    wire send_req_np;
    wire send_req_pn;
    wire send_req_sp;
    wire send_req_ps;
    wire send_req_se;
    wire send_req_es;
    wire send_req_ep;
    wire send_req_pe;

    wire data_in_wn;
    wire data_in_nw;
    wire data_in_ws;
    wire data_in_sw;
    wire data_in_we;
    wire data_in_ew;
    wire data_in_wp;
    wire data_in_pw;
    wire data_in_ns;
    wire data_in_sn;
    wire data_in_ne;
    wire data_in_en;
    wire data_in_np;
    wire data_in_pn;
    wire data_in_sp;
    wire data_in_ps;
    wire data_in_se;
    wire data_in_es;
    wire data_in_ep;
    wire data_in_pe;

    wire clear_e, clear_w, clear_n, clear_s, clear_pe;
    wire empty_e, empty_w, empty_n, empty_s, empty_pe;
    wire grant_e, grant_w, grant_n, grant_s, grant_pe;

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


    // Output Control
    opctrl Output_W (
        .clk(clk),
        .reset(reset),
        .polarity(polarity),
        .grant(grant_w),
        .data_in_pe(data_in_pw),
        .data_in_s(data_in_sw),
        .data_in_n(data_in_nw),
        .data_in_e(data_in_ew),
        .data_in_w(),
        .receive_output(ewro),
        .data_out(ewdo),
        .empty(empty_w),
        .send_output(ewso),
        .clear_pe(clear_pe),
        .clear_s(clear_s),
        .clear_n(clear_n),
        .clear_e(clear_e),
        .clear_w()
    );

        opctrl Output_E (
        .clk(clk),
        .reset(reset),
        .polarity(polarity),
        .grant(grant_e),
        .data_in_pe(data_in_pe),
        .data_in_s(data_in_se),
        .data_in_n(data_in_ne),
        .data_in_e(),
        .data_in_w(data_in_we),
        .receive_output(wero),
        .data_out(wedo),
        .empty(empty_e),
        .send_output(weso),
        .clear_pe(clear_pe),
        .clear_s(clear_s),
        .clear_n(clear_n),
        .clear_e(),
        .clear_w(clear_w)
    );

    opctrl Output_N (
        .clk(clk),
        .reset(reset),
        .polarity(polarity),
        .grant(grant_n),
        .data_in_pe(data_in_pn),
        .data_in_s(data_in_sn),
        .data_in_n(),
        .data_in_e(data_in_en),
        .data_in_w(data_in_wn),
        .receive_output(snro),
        .data_out(sndo),
        .empty(empty_n),
        .send_output(snso),
        .clear_pe(clear_pe),
        .clear_s(clear_s),
        .clear_n(),
        .clear_e(clear_e),
        .clear_w(clear_w)
    );

    opctrl Output_S (
        .clk(clk),
        .reset(reset),
        .polarity(polarity),
        .grant(grant_s),
        .data_in_pe(data_in_ps),
        .data_in_s(),
        .data_in_n(data_in_ns),
        .data_in_e(data_in_es),
        .data_in_w(data_in_ws),
        .receive_output(nsro),
        .data_out(nsdo),
        .empty(empty_s),
        .send_output(nsso),
        .clear_pe(clear_pe),
        .clear_s(),
        .clear_n(clear_n),
        .clear_e(clear_e),
        .clear_w(clear_w)
    );

    opctrl Output_PE (
        .clk(clk),
        .reset(reset),
        .polarity(polarity),
        .grant(grant_pe),
        .data_in_pe(),
        .data_in_s(data_in_sp),
        .data_in_n(data_in_np),
        .data_in_e(data_in_ep),
        .data_in_w(data_in_wp),
        .receive_output(pero),
        .data_out(pedo),
        .empty(empty_pe),
        .send_output(peso),
        .clear_pe(),
        .clear_s(clear_s),
        .clear_n(clear_n),
        .clear_e(clear_e),
        .clear_w(clear_w)
    );

    

endmodule