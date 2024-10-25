`timescale 1ns / 1ps

module tb_opctrl;

    // Inputs
    reg clk;
    reg reset;
    reg polarity;
    reg [4:0] grant;
    reg [63:0] data_in_pe;
    reg [63:0] data_in_s;
    reg [63:0] data_in_n;
    reg [63:0] data_in_e;
    reg [63:0] data_in_w;
    reg receive_output;

    // Outputs
    wire [63:0] data_out;
    wire empty;
    wire send_output;
    wire clear_pe;
    wire clear_s;
    wire clear_n;
    wire clear_e;
    wire clear_w;

    // Instantiate the opctrl module
    opctrl uut (
        .clk(clk),
        .reset(reset),
        .polarity(polarity),
        .grant(grant),
        .data_in_pe(data_in_pe),
        .data_in_s(data_in_s),
        .data_in_n(data_in_n),
        .data_in_e(data_in_e),
        .data_in_w(data_in_w),
        .receive_output(receive_output),
        .data_out(data_out),
        .empty(empty),
        .send_output(send_output),
        .clear_pe(clear_pe),
        .clear_s(clear_s),
        .clear_n(clear_n),
        .clear_e(clear_e),
        .clear_w(clear_w)
    );

    // Clock generation
    always #5 clk = ~clk; // 100MHz clock (10ns period)

    always @(posedge clk) begin
        if (reset) begin
            polarity <= 1'b0; 
        end else begin
            polarity <= ~polarity;
        end
    end

    initial begin
        // Initialize inputs
        clk = 0;
        reset = 0;
        polarity = 0;
        grant = 5'b00000;
        data_in_pe = 64'hAAAA_AAAA_AAAA_AAAA;
        data_in_s = 64'hBBBB_BBBB_BBBB_BBBB;
        data_in_n = 64'hCCCC_CCCC_CCCC_CCCC;
        data_in_e = 64'hDDDD_DDDD_DDDD_DDDD;
        data_in_w = 64'hEEEE_EEEE_EEEE_EEEE;
        receive_output = 0;

        // Apply reset
        reset = 1;
        #10; // Wait for 10ns (1 clock cycle)
        reset = 0;

        // Test scenario 1: Receive data from PE
        receive_output = 1;
        grant = 5'b00001; // Grant data from PE
        #10;

        // Test scenario 2: Change polarity and receive data from S
        grant = 5'b00010; // Grant data from S
        #10;

        // Test scenario 3: Change polarity and receive data from N
        grant = 5'b00100; // Grant data from N
        #10;

        // Test scenario 4: Change polarity and receive data from E
        grant = 5'b01000; // Grant data from E
        #10;

        // Test scenario 5: Change polarity and receive data from W
        grant = 5'b10000; // Grant data from W
        #10;

        // Test scenario 6: Block data transfer with receive_output low
        receive_output = 0;
        #10;

        // Test scenario 7: Change data input values
        data_in_pe = 64'h1111_1111_1111_1111;
        data_in_s = 64'h2222_2222_2222_2222;
        data_in_n = 64'h3333_3333_3333_3333;
        data_in_e = 64'h4444_4444_4444_4444;
        data_in_w = 64'h5555_5555_5555_5555;

        // Test scenario 8: Receive data again after changing input values
        receive_output = 1;
        grant = 5'b00001; // Grant data from PE
        #10;

        // Test scenario 9: Receive data from S again
        grant = 5'b00010; // Grant data from S
        #10;

        // Test scenario 10: Set no grant and check signals
        grant = 5'b00000; // No grant
        #10;

        // End simulation after some time
        #30;
        $finish;
    end

endmodule
