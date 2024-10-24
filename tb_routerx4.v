/*
In this testbench, we will build a 2x2mesh to test the functionality of routing communication.

Topology:
             data-> r3------r4 <-data
                    |        |
                    |        |
             data-> r1------r2 <-data

r1:[16'h0000]; r2:[16'h0100]; r3:[16'h0001]; r4:[16'h0101]; 

Testing materials:
test1: r1 sends to r2, r3, r4
test2: r2 sends to r1, r3, r4
test3: r3 sends to r1, r2, r4
test4: r4 sends to r1, r2, r3
test5: r1, r2, r3 sends to r4 
                    
*/
module tb_routerx4();
    // Testbench signals
    reg clk;
    reg reset;
    wire polarity;

    // Wires for inter-router connections
    //r1 & r2
    wire weso_r1_r2, wero_r1_r2;
    wire weso_r2_r1, wero_r2_r1;
    //r3 & r4
    wire weso_r3_r4, wero_r3_r4;
    wire weso_r4_r3, wero_r4_r3;
    //r1 & r3
    wire weso_r1_r3, wero_r1_r3;
    wire weso_r3_r1, wero_r3_r1;
    //r2 & r4
    wire weso_r2_r4, wero_r2_r4;
    wire weso_r4_r2, wero_r4_r2;

    wire [63:0] wedo_r1_r2, wedo_r2_r1;
    wire [63:0] wedo_r3_r4, wedo_r4_r3;
    wire [63:0] wedo_r1_r3, wedo_r3_r1;
    wire [63:0] wedo_r2_r4, wedo_r4_r2;

    // NIC & PE connections (for external input/output)
    reg pesi_r1, pesi_r2, pesi_r3, pesi_r4;
    reg [63:0] pedi_r1, pedi_r2, pedi_r3, pedi_r4;
    wire peri_r1, peri_r2, peri_r3, peri_r4;
    wire peso_r1, peso_r2, peso_r3, peso_r4;
    wire [63:0] pedo_r1, pedo_r2, pedo_r3, pedo_r4;

    // Clock generation
    always #5 clk = ~clk;

    // Instantiate the router modules with the connections

    // Router 1 (bottom-left, connects to r2 on the right, r3 above)
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
        .ewsi(weso_r2_r1),
        .ewdi(wedo_r2_r1),
        .ewri(wero_r2_r1),
        .ewso(weso_r1_r2),
        .ewro(wero_r1_r2),
        .ewdo(wedo_r1_r2),

        // North to South interface (connects to r3)
        .nssi(weso_r3_r1),
        .nsdi(wedo_r3_r1),
        .nsri(wero_r3_r1),
        .nsso(weso_r1_r3),
        .nsro(wero_r1_r3),
        .nsdo(wedo_r1_r3),

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
        .peso(peso_r1),
        .pero(1'b1),
        .pedo(pedo_r1)
    );

    // Router 2 (bottom-right, connects to r1 on the left, r4 above)
    router #(
        .DATA_WIDTH(64),
        .CURRENT_ADDRESS(16'b0000_0001_0000_0000), //current address in the mesh
        .BUFFER_DEPTH(1)
    ) r2 (
        .clk(clk),
        .reset(reset),
        .polarity(polarity),

        // West to East interface (connects to r1)
        .wesi(weso_r1_r2),
        .wedi(wedo_r1_r2),
        .weri(wero_r1_r2),
        .weso(weso_r2_r1),
        .wero(wero_r2_r1),
        .wedo(wedo_r2_r1),

        // East to West interface (no connection to the right)
        .ewsi(),
        .ewdi(),
        .ewri(),
        .ewso(),
        .ewro(),
        .ewdo(),

        // North to South interface (connects to r4)
        .nssi(weso_r4_r2),
        .nsdi(wedo_r4_r2),
        .nsri(wero_r4_r2),
        .nsso(weso_r2_r4),
        .nsro(wero_r2_r4),
        .nsdo(wedo_r2_r4),

        // South to North interface (no connection below)
        .snsi(),
        .sndi(),
        .snri(),
        .snso(),
        .snro(),
        .sndo(),

        // NIC & PE interface (external input/output)
        .pesi(pesi_r2),
        .pedi(pedi_r2),
        .peri(peri_r2),
        .peso(peso_r2),
        .pero(1'b1),
        .pedo(pedo_r2)
    );

    // Router 3 (top-left, connects to r4 on the right, r1 below)
    router #(
        .DATA_WIDTH(64),
        .CURRENT_ADDRESS(16'b0000_0000_0000_0001), //current address in the mesh
        .BUFFER_DEPTH(1)
    ) r3 (
        .clk(clk),
        .reset(reset),
        .polarity(polarity),

        // West to East interface (connects to r4)
        .wesi(),
        .wedi(),
        .weri(),
        .weso(),
        .wero(),
        .wedo(),

        // East to West interface (no connection to the left)
        .ewsi(weso_r4_r3),
        .ewdi(wedo_r4_r3),
        .ewri(wero_r4_r3),
        .ewso(weso_r3_r4),
        .ewro(wero_r3_r4),
        .ewdo(wedo_r3_r4),

        // North to South interface (no connection above)
        .nssi(),
        .nsdi(),
        .nsri(),
        .nsso(),
        .nsro(),
        .nsdo(),

        // South to North interface (connects to r1)
        .snsi(weso_r1_r3),
        .sndi(wedo_r1_r3),
        .snri(wero_r1_r3),
        .snso(weso_r3_r1),
        .snro(wero_r3_r1),
        .sndo(wedo_r3_r1),

        // NIC & PE interface (external input/output)
        .pesi(pesi_r3),
        .pedi(pedi_r3),
        .peri(peri_r3),
        .peso(peso_r3),
        .pero(1'b1),
        .pedo(pedo_r3)
    );

    // Router 4 (top-right, connects to r3 on the left, r2 below)
    router #(
        .DATA_WIDTH(64),
        .CURRENT_ADDRESS(16'b0000_0001_0000_0001), //current address in the mesh
        .BUFFER_DEPTH(1)
    ) r4 (
        .clk(clk),
        .reset(reset),
        .polarity(polarity),

        // West to East interface (connects to r3)
        .wesi(weso_r3_r4),
        .wedi(wedo_r3_r4),
        .weri(wero_r3_r4),
        .weso(weso_r4_r3),
        .wero(wero_r4_r3),
        .wedo(wedo_r4_r3),

        // East to West interface (no connection to the right)
        .ewsi(),
        .ewdi(),
        .ewri(),
        .ewso(),
        .ewro(),
        .ewdo(),

        // North to South interface (no connection above)
        .nssi(),
        .nsdi(),
        .nsri(),
        .nsso(),
        .nsro(),
        .nsdo(),

        // South to North interface (connects to r2)
        .snsi(weso_r2_r4),
        .sndi(wedo_r2_r4),
        .snri(wero_r2_r4),
        .snso(weso_r4_r2),
        .snro(wero_r4_r2),
        .sndo(wedo_r4_r2),

        // NIC & PE interface (external input/output)
        .pesi(pesi_r4),
        .pedi(pedi_r4),
        .peri(peri_r4),
        .peso(peso_r4),
        .pero(1'b1),
        .pedo(pedo_r4)
    );

    // Task to reset all routers
    task reset_routers();
        begin
            reset = 1;
            #10;
            reset = 0;
        end
    endtask

    // Test sequence for sending data              !!!!!!!!!!!!!!!!!!TODO!!!!!!!!!!!!!!!!
    initial begin
        // Initialize
        clk = 0;
        reset_routers();

        // Test 1: r1 sends data to r2, r3, r4
        pesi_r1 = 1;
        pedi_r1 = {1'b1, 2'b10, 5'b00000, 8'b0001_0000, 16'h0000,32'h1111_1111}; // {vc, dir, NA, hop, source_address, data}
        #10;
        pesi_r1 = 0; // Stop sending after 10 time units
        #20
        pesi_r1 = 1;
        pedi_r1 = {1'b1, 2'b01, 5'b00000, 8'b0000_0001, 16'h0000,32'h2222_2222}; 
        #10;
        pesi_r1 = 0; // Stop sending after 10 time units
        #20
        pesi_r1 = 1;
        pedi_r1 = {1'b1, 2'b11, 5'b00000, 8'b0001_0001, 16'h0000,32'h3333_3333}; 
        #10;
        pesi_r1 = 0; // Stop sending after 10 time units

        //Wait for a few cycles for data to propagate
        #20;

        // Test 2: r2 sends data to r1, r3, r4
        pesi_r2 = 1;
        pedi_r2 = {1'b1, 2'b00, 5'b00000, 8'b0001_0000, 16'h0000,32'h4444_4444};
        #10;
        pesi_r2 = 0;
        #20
        pesi_r2 = 1;
        pedi_r2 = {1'b1, 2'b01, 5'b00000, 8'b0001_0001, 16'h0000,32'h5555_5555};
        #10;
        pesi_r2 = 0;
        #20
        pesi_r2 = 1;
        pedi_r2 = {1'b1, 2'b01, 5'b00000, 8'b0000_0001, 16'h0000,32'h6666_6666};
        #10;
        pesi_r2 = 0;

        #20;

        // // Test 3: r3 sends data to r1, r2, r4
        pesi_r3 = 1;
        pedi_r3 = {1'b1, 2'b00, 5'b00000, 8'b0000_0001, 16'h0000,32'h7777_7777};
        #10;
        pesi_r3 = 0;
        #20
        pesi_r3 = 1;
        pedi_r3 = {1'b1, 2'b00, 5'b00000, 8'b0001_0001, 16'h0000,32'h8888_8888};
        #10;
        pesi_r3 = 0;
        #20
        pesi_r3 = 1;
        pedi_r3 = {1'b1, 2'b10, 5'b00000, 8'b0001_0000, 16'h0000,32'h9999_9999};
        #10;
        pesi_r3 = 0;
        #20

        #20;

        // // Test 4: r4 sends data to r1, r2, r3
        // pesi_r4 = 1;
        // pedi_r4 = 64'h99AABBCCDDEEFF00;
        // #10;
        // pesi_r4 = 0;

        // #20;

        // // Test 5: r1, r2, and r3 send to r4
        // pesi_r1 = 1;
        // pedi_r1 = 64'h0011223344556677;
        // pesi_r2 = 1;
        // pedi_r2 = 64'h8899AABBCCDDEEFF;
        // pesi_r3 = 1;
        // pedi_r3 = 64'hFFEEDDCCBBAA9988;
        // #10;
        // pesi_r1 = 0;
        // pesi_r2 = 0;
        // pesi_r3 = 0;

        // Wait for data propagation
        #50;

        // End of test
        $finish;
    end

    // Monitor signal changes
    // Monitor task
    task monitor_signals;
        begin
            // Display important signals at every clock cycle
            $display("Time: %0t | clk: %0b | pesi: %0b | peri: %0b | pedi: %h | peso: %0b | pedo: %h",
                    $time, clk, pesi, peri, pedi, peso, pedo);
        end
    endtask

    // Continuous monitoring on every clock cycle
    always @(posedge clk or negedge clk) begin
        monitor_signals;
    end
    

endmodule
