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
    wire weso_r1_r2, wero_r1_r2;
    wire weso_r3_r4, wero_r3_r4;
    wire weso_r1_r3, wero_r1_r3;
    wire weso_r2_r4, wero_r2_r4;

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
    router r1 (
        .clk(clk),
        .reset(reset),
        .polarity(polarity),

        // West to East interface (connects to r2)
        .wesi(weso_r2_r1),
        .wedi(wedo_r2_r1),
        .weri(wero_r2_r1),
        .weso(weso_r1_r2),
        .wero(wero_r1_r2),
        .wedo(wedo_r1_r2),

        // East to West interface (no connection to the left)
        .ewsi(1'b0),
        .ewdi(64'b0),
        .ewri(),
        .ewso(),
        .ewro(),
        .ewdo(),

        // North to South interface (connects to r3)
        .nssi(weso_r3_r1),
        .nsdi(wedo_r3_r1),
        .nsri(wero_r3_r1),
        .nsso(weso_r1_r3),
        .nsro(wero_r1_r3),
        .nsdo(wedo_r1_r3),

        // South to North interface (no connection below)
        .snsi(1'b0),
        .sndi(64'b0),
        .snri(),
        .snso(),
        .snro(),
        .sndo(),

        // NIC & PE interface (external input/output)
        .pesi(pesi_r1),
        .pedi(pedi_r1),
        .peri(peri_r1),
        .peso(peso_r1),
        .pero(1'b0),
        .pedo(pedo_r1)
    );

    // Router 2 (bottom-right, connects to r1 on the left, r4 above)
    router r2 (
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
        .ewsi(1'b0),
        .ewdi(64'b0),
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
        .snsi(1'b0),
        .sndi(64'b0),
        .snri(),
        .snso(),
        .snro(),
        .sndo(),

        // NIC & PE interface (external input/output)
        .pesi(pesi_r2),
        .pedi(pedi_r2),
        .peri(peri_r2),
        .peso(peso_r2),
        .pero(1'b0),
        .pedo(pedo_r2)
    );

    // Router 3 (top-left, connects to r4 on the right, r1 below)
    router r3 (
        .clk(clk),
        .reset(reset),
        .polarity(polarity),

        // West to East interface (connects to r4)
        .wesi(weso_r4_r3),
        .wedi(wedo_r4_r3),
        .weri(wero_r4_r3),
        .weso(weso_r3_r4),
        .wero(wero_r3_r4),
        .wedo(wedo_r3_r4),

        // East to West interface (no connection to the left)
        .ewsi(1'b0),
        .ewdi(64'b0),
        .ewri(),
        .ewso(),
        .ewro(),
        .ewdo(),

        // North to South interface (no connection above)
        .nssi(1'b0),
        .nsdi(64'b0),
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
        .pero(1'b0),
        .pedo(pedo_r3)
    );

    // Router 4 (top-right, connects to r3 on the left, r2 below)
    router r4 (
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
        .ewsi(1'b0),
        .ewdi(64'b0),
        .ewri(),
        .ewso(),
        .ewro(),
        .ewdo(),

        // North to South interface (no connection above)
        .nssi(1'b0),
        .nsdi(64'b0),
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
        .pero(1'b0),
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
        pedi_r1 = 64'hAABBCCDD11223344; // Example data
        #10;
        pesi_r1 = 0; // Stop sending after 10 time units

        // Wait for a few cycles for data to propagate
        #20;

        // Test 2: r2 sends data to r1, r3, r4
        pesi_r2 = 1;
        pedi_r2 = 64'h5566778899AABBCC;
        #10;
        pesi_r2 = 0;

        #20;

        // Test 3: r3 sends data to r1, r2, r4
        pesi_r3 = 1;
        pedi_r3 = 64'h1122334455667788;
        #10;
        pesi_r3 = 0;

        #20;

        // Test 4: r4 sends data to r1, r2, r3
        pesi_r4 = 1;
        pedi_r4 = 64'h99AABBCCDDEEFF00;
        #10;
        pesi_r4 = 0;

        #20;

        // Test 5: r1, r2, and r3 send to r4
        pesi_r1 = 1;
        pedi_r1 = 64'h0011223344556677;
        pesi_r2 = 1;
        pedi_r2 = 64'h8899AABBCCDDEEFF;
        pesi_r3 = 1;
        pedi_r3 = 64'hFFEEDDCCBBAA9988;
        #10;
        pesi_r1 = 0;
        pesi_r2 = 0;
        pesi_r3 = 0;

        // Wait for data propagation
        #50;

        // End of test
        $finish;
    end

endmodule
