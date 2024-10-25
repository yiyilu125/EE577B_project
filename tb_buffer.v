module tb_buffer;

    // Testbench parameters
    parameter DATA_WIDTH = 64;
    parameter DEPTH = 1;

    // Testbench signals
    reg clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [DATA_WIDTH-1:0] data_in;
    wire [DATA_WIDTH-1:0] data_out;
    wire full;
    wire empty;

    // Instantiate the buffer
    buffer #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) uut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Testbench initial setup
    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;

        // Reset the buffer
        #10 rst = 0;

        // Write data to the buffer
        #10 wr_en = 1;
        data_in = 64'hA5A5A5A5A5A5A5A5;  // Input some data
        #10 wr_en = 0;

        // Wait and then read from the buffer
        #10 rd_en = 1;
        #10 rd_en = 0;

        // Write new data
        #10 wr_en = 1;
        data_in = 64'hDEADBEEFDEADBEEF;  // New data
        #10 wr_en = 0;

        // Read the new data
        #10 rd_en = 1;
        #10 rd_en = 0;

        // End simulation
        #20 $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time=%0d, clk=%b, rst=%b, wr_en=%b, rd_en=%b, data_in=%h, data_out=%h, full=%b, empty=%b",
                 $time, clk, rst, wr_en, rd_en, data_in, data_out, full, empty);
    end
endmodule

