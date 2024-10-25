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
    wire [4:0] clear;

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

        // Check initial state after reset
        #10;
        if (empty !== 1 || data_out !== 64'b0 || send_output !== 0) begin
            $display("Test failed after reset.");
        end else begin
            $display("Reset state passed.");
        end

        // Test data reception when `receive_output` is high
        receive_output = 1;
        grant = 5'b00001; // Grant data from PE
        polarity = 0;     // Even clock cycle
        #10;

        // Check data storage in even register
        if (data_out !== 64'hAAAA_AAAA_AAAA_AAAA) begin
            $display("Test failed for data reception from PE at polarity 0.");
        end else begin
            $display("Data reception from PE at polarity 0 passed.");
        end

        // Change polarity to 1 (odd clock cycle)
        polarity = 1;
        grant = 5'b00010; // Grant data from S
        #10;

        // Check data storage in odd register
        if (data_out !== 64'hBBBB_BBBB_BBBB_BBBB) begin
            $display("Test failed for data reception from S at polarity 1.");
        end else begin
            $display("Data reception from S at polarity 1 passed.");
        end

        // Test send_output behavior when `receive_output` is low
        receive_output = 0;
        #10;
        if (send_output !== 0) begin
            $display("Test failed: send_output should be low when receive_output is low.");
        end else begin
            $display("Send_output behavior with receive_output low passed.");
        end

        // Test `clear` signals with different grants
        receive_output = 1;
        polarity = 0;
        grant = 5'b00100; // Grant data from N
        #10;

        if (!clear_n || clear_pe || clear_s || clear_e || clear_w) begin
            $display("Test failed for clear signal from N.");
        end else begin
            $display("Clear signal from N passed.");
        end

        // Test data reception from E with polarity 0 and verify output
        grant = 5'b01000; // Grant data from E
        polarity = 0;
        #10;

        if (data_out !== 64'hDDDD_DDDD_DDDD_DDDD) begin
            $display("Test failed for data reception from E at polarity 0.");
        end else begin
            $display("Data reception from E at polarity 0 passed.");
        end

        // Test `clear` signal when grant is zero
        grant = 5'b00000; // No grant
        #10;
        if (clear !== 5'b00000) begin
            $display("Test failed: clear signal should be zero when no grant.");
        end else begin
            $display("Clear signal with no grant passed.");
        end

        $display("All tests completed.");
        $finish;
    end

endmodule
