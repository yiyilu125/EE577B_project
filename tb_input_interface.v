`timescale 1ns / 1ps

module tb_input_interface();

    // Parameters
    parameter DATA_WIDTH = 64;
    parameter CURRENT_ADDRESS = 16'b0000_0000_0000_0000;
    parameter BUFFER_DEPTH = 1;

    // Testbench signals
    reg si;
    reg clk;
    reg rst;
    reg buf_clear_1, buf_clear_2, buf_clear_3, buf_clear_4;
    reg [DATA_WIDTH-1:0] datai;
    wire ri;
    wire [4:0] reqL, reqR, reqU, reqD, reqPE;
    wire [DATA_WIDTH-1:0] dataoL, dataoR, dataoU, dataoD, dataoPE;

    // Instantiate the input_interface module
    input_interface #(
        .DATA_WIDTH(DATA_WIDTH),
        .CURRENT_ADDRESS(CURRENT_ADDRESS),
        .DIRECTION(5'b00001),
        .BUFFER_DEPTH(BUFFER_DEPTH)
    ) uut (
        .si(si),
        .clk(clk),
        .rst(rst),
        .buf_clear_1(buf_clear_1),
        .buf_clear_2(buf_clear_2),
        .buf_clear_3(buf_clear_3),
        .buf_clear_4(buf_clear_4),
        .datai(datai),
        .ri(ri),
        .reqL(reqL),
        .reqR(reqR),
        .reqU(reqU),
        .reqD(reqD),
        .reqPE(reqPE),
        .dataoL(dataoL),
        .dataoR(dataoR),
        .dataoU(dataoU),
        .dataoD(dataoD),
        .dataoPE(dataoPE)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 time units clock period
    end

    // Stimulus generation
    initial begin
        // Initialize signals
        si = 0;
        rst = 1;
        buf_clear_1 = 0;
        buf_clear_2 = 0;
        buf_clear_3 = 0;
        buf_clear_4 = 0;
        datai = {1'b1, 2'b10, 5'b00000, 8'b0001_0000, 16'h0000,32'h1111_1111}; // Example data input

        // Reset the module

        #10 rst = 0;
        // Start sending data
        #7 si = 1; // Activate send input
        #10 si = 0; // Deactivate send input


        // Trigger buffer clear signals
        buf_clear_1 = 1;
        #9 buf_clear_1 = 0;
        #20

        // Further stimulus
        // #10 datai = {1'b1, 2'b01, 5'b00000, 8'b0000_0001, 16'h0000,32'h2222_2222}; // Change data input
        // si = 1; // Send new data
        // #10 si = 0;

        // Complete simulation after some time
        #100 $finish;
    end

    // Monitoring outputs
    initial begin
        $monitor("Time: %0t | si: %b | rst: %b | datai: 0x%h | ri: %b | reqL: %b | reqR: %b | reqU: %b | reqD: %b | reqPE: %b | dataoL: 0x%h | dataoR: 0x%h | dataoU: 0x%h | dataoD: 0x%h | dataoPE: 0x%h",
                 $time, si, rst, datai, ri, reqL, reqR, reqU, reqD, reqPE, dataoL, dataoR, dataoU, dataoD, dataoPE);
    end

endmodule
