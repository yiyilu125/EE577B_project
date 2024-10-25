module tb_router();

    reg pesi_r1, clk, reset;
    reg [63:0] pedi_r1;
    wire weso_r1_r2;
    reg wero_r1_r2;
    wire [63:0] wedo_r1_r2;
    wire peri_r1;
    wire polarity;

    router #(
        .DATA_WIDTH(64),
        .CURRENT_ADDRESS(16'b0000_0000_0000_0000), //current address in the mesh
        .BUFFER_DEPTH(1)
    ) r1 (
        .clk(clk),
        .reset(reset),
        .polarity(polarity),

        // West to East interface (connects to r2)
        .wesi(),
        .wedi(),
        .weri(),
        .weso(),
        .wero(),
        .wedo(),

        // East to West interface (no connection to the left)
        .ewsi(),
        .ewdi(),
        .ewri(),
        .ewso(weso_r1_r2),
        .ewro(wero_r1_r2),
        .ewdo(wedo_r1_r2),

        // North to South interface (connects to r3)
        .nssi(),
        .nsdi(),
        .nsri(),
        .nsso(),
        .nsro(),
        .nsdo(),

        // South to North interface (no connection below)
        .snsi(),
        .sndi(),
        .snri(),
        .snso(),
        .snro(),
        .sndo(),

        // NIC & PE interface (external input/output)
        .pesi(pesi_r1),
        .pedi(pedi_r1),
        .peri(peri_r1),
        .peso(),
        .pero(),
        .pedo()
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Reset and test stimulus
    initial begin
        // Initialize inputs
        reset = 1;
        pesi_r1 = 0;
        pedi_r1 = 64'h0000_0000_0000_0000;
        wero_r1_r2 = 0;

        // Apply reset
        #10 reset = 0;

        // Start sending data from PE interface of router 1
        #20 pesi_r1 = 1;  // PE sends data to r1
        pedi_r1 = {1'b1, 2'b10, 5'b00000, 8'b0001_0000, 16'h0000,32'h1111_1111};  // Example data

        #20 pesi_r1 = 0;  // Stop sending data
        pedi_r1 = 64'h0000_0000_0000_0000;

        // Trigger East-West communication (simulate wero)
        

        // Finish simulation after some delay
        #50 $finish;
    end

    // Always-on monitor
    initial begin
        $monitor("Time: %0t | clk: %0b | polarity: %0b | pesi_r1: %0b | peri_r1: %0b | pedi_r1: %h | weso_r1_r2: %0b | wedo_r1_r2: %h",
                 $time, clk, polarity, pesi_r1, peri_r1, pedi_r1, weso_r1_r2, wedo_r1_r2);
    end
endmodule
