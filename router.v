module router #(
    parameter DATA_WIDTH = 64,  // Width of the data
    parameter CURRENT_ADDRESS = 16'b0000_0000_0000_0000, //current address in the mesh
    parameter BUFFER_DEPTH = 1
)(
    input clk,
    input reset,
    output reg polarity,

    // West to East interface
    input wesi,
    input [63:0] wedi,
    output weri,
    output weso,
    input wero,
    output reg [63:0] wedo,

    // East to West interface
    input ewsi,
    input [63:0] ewdi,
    output ewri,
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
    output snri,
    output snso,
    input snro,
    output reg [63:0] sndo,

    // NIC & PE interface
    input pesi,
    input [63:0] pedi,
    output peri,
    output peso,
    input pero,
    output reg [63:0] pedo
);

    // Internal variable
    wire [4:0] send_req_wn, send_req_nw, send_req_ws, send_req_sw, send_req_we;
    wire [4:0] send_req_ew, send_req_wp, send_req_pw, send_req_ns, send_req_sn;
    wire [4:0] send_req_ne, send_req_en, send_req_np, send_req_pn, send_req_sp;
    wire [4:0] send_req_ps, send_req_se, send_req_es, send_req_ep, send_req_pe;

    wire [63:0] data_in_wn, data_in_nw, data_in_ws, data_in_sw, data_in_we;
    wire [63:0] data_in_ew, data_in_wp, data_in_pw, data_in_ns, data_in_sn;
    wire [63:0] data_in_ne, data_in_en, data_in_np, data_in_pn, data_in_sp;
    wire [63:0] data_in_ps, data_in_se, data_in_es, data_in_ep, data_in_pe;

    wire clear_wn, clear_nw, clear_ws, clear_sw, clear_we;
    wire clear_ew, clear_wp, clear_pw, clear_ns, clear_sn;
    wire clear_ne, clear_en, clear_np, clear_pn, clear_sp;
    wire clear_ps, clear_se, clear_es, clear_ep, clear_pe;

    wire empty_e, empty_w, empty_n, empty_s, empty_pe;
    wire [4:0] grant_e, grant_w, grant_n, grant_s, grant_pe;

	wire [63:0] data_out_w, data_out_e, data_out_n, data_out_s, data_out_pe; 
	always@(*)begin
		ewdo = data_out_w;
        wedo = data_out_e;
		nsdo = data_out_s;
		sndo = data_out_n;
        pedo = data_out_pe;
	end

    // Polarity generation
    always @(posedge clk) begin
        if (reset) begin
            polarity <= 1'b0; 
        end else begin
            polarity <= ~polarity;
        end
    end

    // Input Interface
    input_interface #(
        .DATA_WIDTH(DATA_WIDTH),
        .CURRENT_ADDRESS(CURRENT_ADDRESS),
        .DIRECTION(5'b10000),
        .BUFFER_DEPTH(BUFFER_DEPTH)
    ) Input_W (
        .clk(clk),
        .rst(reset),
        .si(wesi),
        .datai(wedi),
        .ri(weri),
        .buf_clear_1(clear_ew),
        .buf_clear_2(clear_nw),
        .buf_clear_3(clear_sw),
        .buf_clear_4(clear_pw),
        .reqL(), 
        .reqR(send_req_we), 
        .reqU(send_req_wn), 
        .reqD(send_req_ws), 
        .reqPE(send_req_wp), 
        .dataoL(), 
        .dataoR(data_in_we), 
        .dataoU(data_in_wn), 
        .dataoD(data_in_ws), 
        .dataoPE(data_in_wp)
    );

    input_interface #(
        .DATA_WIDTH(DATA_WIDTH),
        .CURRENT_ADDRESS(CURRENT_ADDRESS),
        .DIRECTION(5'b01000),
        .BUFFER_DEPTH(BUFFER_DEPTH)
    ) Input_E (
        .clk(clk),
        .rst(reset),
        .si(ewsi),
        .datai(ewdi),
        .ri(ewri),
        .buf_clear_1(clear_we),
        .buf_clear_2(clear_ne),
        .buf_clear_3(clear_se),
        .buf_clear_4(clear_pe),
        .reqL(send_req_ew), 
        .reqR(), 
        .reqU(send_req_en), 
        .reqD(send_req_es), 
        .reqPE(send_req_ep), 
        .dataoL(data_in_ew), 
        .dataoR(), 
        .dataoU(data_in_en), 
        .dataoD(data_in_es), 
        .dataoPE(data_in_ep)
    );

    input_interface #(
        .DATA_WIDTH(DATA_WIDTH),
        .CURRENT_ADDRESS(CURRENT_ADDRESS),
        .DIRECTION(5'b00100),
        .BUFFER_DEPTH(BUFFER_DEPTH)
    ) Input_N (
        .clk(clk),
        .rst(reset),
        .si(nssi),
        .datai(nsdi),
        .ri(nsri),
        .buf_clear_1(clear_en),
        .buf_clear_2(clear_wn),
        .buf_clear_3(clear_sn),
        .buf_clear_4(clear_pn),
        .reqL(send_req_nw), 
        .reqR(send_req_ne), 
        .reqU(), 
        .reqD(send_req_ns), 
        .reqPE(send_req_np), 
        .dataoL(data_in_nw), 
        .dataoR(data_in_ne), 
        .dataoU(), 
        .dataoD(data_in_ns), 
        .dataoPE(data_in_np)
    );

    input_interface #(
        .DATA_WIDTH(DATA_WIDTH),
        .CURRENT_ADDRESS(CURRENT_ADDRESS),
        .DIRECTION(5'b00010),
        .BUFFER_DEPTH(BUFFER_DEPTH)
    ) Input_S (
        .clk(clk),
        .rst(reset),
        .si(snsi),
        .datai(sndi),
        .ri(snri),
        .buf_clear_1(clear_ws),
        .buf_clear_2(clear_es),
        .buf_clear_3(clear_ns),
        .buf_clear_4(clear_ps),
        .reqL(send_req_sw), 
        .reqR(send_req_se), 
        .reqU(send_req_sn), 
        .reqD(), 
        .reqPE(send_req_sp), 
        .dataoL(data_in_sw), 
        .dataoR(data_in_se), 
        .dataoU(data_in_sn), 
        .dataoD(), 
        .dataoPE(data_in_sp)
    );

    input_interface #(
        .DATA_WIDTH(DATA_WIDTH),
        .CURRENT_ADDRESS(CURRENT_ADDRESS),
        .DIRECTION(5'b00001),
        .BUFFER_DEPTH(BUFFER_DEPTH)
    ) Input_PE (
        .clk(clk),
        .rst(reset),
        .si(pesi),
        .datai(pedi),
        .ri(peri),
        .buf_clear_1(clear_wp),
        .buf_clear_2(clear_ep),
        .buf_clear_3(clear_sp),
        .buf_clear_4(clear_np),
        .reqL(send_req_pw), 
        .reqR(send_req_pe), 
        .reqU(send_req_pn), 
        .reqD(send_req_ps), 
        .reqPE(), 
        .dataoL(data_in_pw), 
        .dataoR(data_in_pe), 
        .dataoU(data_in_pn), 
        .dataoD(data_in_ps), 
        .dataoPE()
    );



    // Arbiter
    round_robin_arbiter Arb_E (
        .clk(clk),
        .rst(reset),
        .empty(empty_e),
        .req0(send_req_pe),
        .req1(send_req_we),
        .req2(send_req_se),
        .req3(send_req_ne),
        .grant(grant_e)
    );

    round_robin_arbiter Arb_W (
        .clk(clk),
        .rst(reset),
        .empty(empty_w),
        .req0(send_req_pw),
        .req1(send_req_ew),
        .req2(send_req_sw),
        .req3(send_req_nw),
        .grant(grant_w)
    );

    round_robin_arbiter Arb_N (
        .clk(clk),
        .rst(reset),
        .empty(empty_n),
        .req0(send_req_pn),
        .req1(send_req_wn),
        .req2(send_req_en),
        .req3(send_req_sn),
        .grant(grant_n)
    );

    round_robin_arbiter Arb_S (
        .clk(clk),
        .rst(reset),
        .empty(empty_s),
        .req0(send_req_ps),
        .req1(send_req_ws),
        .req2(send_req_es),
        .req3(send_req_ns),
        .grant(grant_s)
    );

    round_robin_arbiter Arb_PE (
        .clk(clk),
        .rst(reset),
        .empty(empty_pe),
        .req0(send_req_wp),
        .req1(send_req_ep),
        .req2(send_req_sp),
        .req3(send_req_np),
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
        .data_out(data_out_w),
        .empty(empty_w),
        .send_output(ewso),
        .clear_pe(clear_wp),
        .clear_s(clear_ws),
        .clear_n(clear_wn),
        .clear_e(clear_we),
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
        .data_out(data_out_e),
        .empty(empty_e),
        .send_output(weso),
        .clear_pe(clear_ep),
        .clear_s(clear_es),
        .clear_n(clear_en),
        .clear_e(),
        .clear_w(clear_ew)
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
        .data_out(data_out_n),
        .empty(empty_n),
        .send_output(snso),
        .clear_pe(clear_np),
        .clear_s(clear_ns),
        .clear_n(),
        .clear_e(clear_ne),
        .clear_w(clear_nw)
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
        .data_out(data_out_s),
        .empty(empty_s),
        .send_output(nsso),
        .clear_pe(clear_sp),
        .clear_s(),
        .clear_n(clear_sn),
        .clear_e(clear_se),
        .clear_w(clear_sw)
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
        .data_out(data_out_pe),
        .empty(empty_pe),
        .send_output(peso),
        .clear_pe(),
        .clear_s(clear_ps),
        .clear_n(clear_pn),
        .clear_e(clear_pe),
        .clear_w(clear_pw)
    );

    

endmodule