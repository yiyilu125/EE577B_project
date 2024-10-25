module tb_input_ctrl;

    // Parameters
    parameter BUFFER_DATA_WIDTH = 64;

    // Inputs
    reg sendI;
    reg [63:0] dataI;
    reg clk;
    reg rst;
    reg polarity;
    reg sig_channel_clean;

    // Outputs
    wire receiveI;
    wire [63:0] inner_dataO;
    wire sig_req_channel;

    // Instantiate the Unit Under Test (UUT)
    input_ctrl #(
        .BUFFER_DATA_WIDTH(BUFFER_DATA_WIDTH)
    ) uut (
        .sendI(sendI),
        .dataI(dataI),
        .clk(clk),
        .rst(rst),
        .sig_channel_clean(sig_channel_clean),
        .receiveI(receiveI),
        .inner_dataO(inner_dataO),
        .sig_req_channel(sig_req_channel)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time units clock period
    end

    // Stimulus process
    initial begin
        // Initialize Inputs
        sendI = 0;
        dataI = 64'h0;
        rst = 1; // Assert reset
        sig_channel_clean = 0;

        // Wait for global reset
        #10;
        rst = 0; // Deassert reset

        // // Test Case 1: Send data with ODD_POLARITY state
        // #10;
        // sendI = 1; // Signal to send data
        // dataI = 64'hA5A5A5A5A5A5A5A5; // Sample data
        // sig_channel_clean = 1; // Allow reading from buffer

        // // Wait for a clock cycle
        // #10;
        // sig_channel_clean = 0; // Disable reading from buffer

        // // Test Case 2: Change polarity and check EVEN_POLARITY state
        // #10;
        // sendI = 1; // Signal to send data
        // dataI = 64'h5A5A5A5A5A5A5A5A; // Sample data

        // // Wait for a clock cycle
        // #10;
        // sig_channel_clean = 1; // Allow reading from buffer

        // // Test Case 3: Reset the module
        // #10;
        // rst = 1; // Assert reset
        // #10;
        // rst = 0; // Deassert reset

        // Finish simulation after a few cycles
        #50;
        $finish;
    end

    // Monitor Outputs
    initial begin
        $monitor("Time: %0t | sendI: %b | dataI: %h | receiveI: %b | inner_dataO: %h | sig_req_channel: %b", 
                  $time, sendI, dataI, receiveI, inner_dataO, sig_req_channel);
    end

endmodule
