module tb_mesh4x4;
    parameter CLOCK_PERIOD = 10; // Clock period in ns

    reg clk;
    reg reset;
    wire polarity;

    // Input/Output signals for mesh4x4
    reg pesi_00, pesi_01, pesi_02, pesi_03;
    reg [63:0] pedi_00, pedi_01, pedi_02, pedi_03;
    wire peri_00, peri_01, peri_02, peri_03;
    reg pero_00, pero_01, pero_02, pero_03;
    wire [63:0] pedo_00, pedo_01, pedo_02, pedo_03;
    wire peso_00, peso_01, peso_02, peso_03;

    reg pesi_10, pesi_11, pesi_12, pesi_13;
    reg [63:0] pedi_10, pedi_11, pedi_12, pedi_13;
    wire peri_10, peri_11, peri_12, peri_13;
    reg pero_10, pero_11, pero_12, pero_13;
    wire [63:0] pedo_10, pedo_11, pedo_12, pedo_13;
    wire peso_10, peso_11, peso_12, peso_13;

    reg pesi_20, pesi_21, pesi_22, pesi_23;
    reg [63:0] pedi_20, pedi_21, pedi_22, pedi_23;
    wire peri_20, peri_21, peri_22, peri_23;
    reg pero_20, pero_21, pero_22, pero_23;
    wire [63:0] pedo_20, pedo_21, pedo_22, pedo_23;
    wire peso_20, peso_21, peso_22, peso_23;

    reg pesi_30, pesi_31, pesi_32, pesi_33;
    reg [63:0] pedi_30, pedi_31, pedi_32, pedi_33;
    wire peri_30, peri_31, peri_32, peri_33;
    reg pero_30, pero_31, pero_32, pero_33;
    wire [63:0] pedo_30, pedo_31, pedo_32, pedo_33;
    wire peso_30, peso_31, peso_32, peso_33;

    // Instantiate the mesh4x4 module
    mesh4x4 uut (
        .clk(clk),
        .reset(reset),
        .polarity(polarity),
        .pesi_r0 (pesi_00), .pedi_r0 (pedi_00), .peri_r0 (peri_00), .pero_r0 (pero_00), .pedo_r0 (pedo_00), .peso_r0 (peso_00),
        .pesi_r4 (pesi_01), .pedi_r4 (pedi_01), .peri_r4 (peri_01), .pero_r4 (pero_01), .pedo_r4 (pedo_01), .peso_r4 (peso_01),
        .pesi_r8 (pesi_02), .pedi_r8 (pedi_02), .peri_r8 (peri_02), .pero_r8 (pero_02), .pedo_r8 (pedo_02), .peso_r8 (peso_02),
        .pesi_r12(pesi_03), .pedi_r12(pedi_03), .peri_r12(peri_03), .pero_r12(pero_03), .pedo_r12(pedo_03), .peso_r12(peso_03),
        .pesi_r1 (pesi_10), .pedi_r1 (pedi_10), .peri_r1 (peri_10), .pero_r1 (pero_10), .pedo_r1 (pedo_10), .peso_r1 (peso_10),
        .pesi_r5 (pesi_11), .pedi_r5 (pedi_11), .peri_r5 (peri_11), .pero_r5 (pero_11), .pedo_r5 (pedo_11), .peso_r5 (peso_11),
        .pesi_r9 (pesi_12), .pedi_r9 (pedi_12), .peri_r9 (peri_12), .pero_r9 (pero_12), .pedo_r9 (pedo_12), .peso_r9 (peso_12),
        .pesi_r13(pesi_13), .pedi_r13(pedi_13), .peri_r13(peri_13), .pero_r13(pero_13), .pedo_r13(pedo_13), .peso_r13(peso_13),
        .pesi_r2 (pesi_20), .pedi_r2 (pedi_20), .peri_r2 (peri_20), .pero_r2 (pero_20), .pedo_r2 (pedo_20), .peso_r2 (peso_20),
        .pesi_r6 (pesi_21), .pedi_r6 (pedi_21), .peri_r6 (peri_21), .pero_r6 (pero_21), .pedo_r6 (pedo_21), .peso_r6 (peso_21),
        .pesi_r10(pesi_22), .pedi_r10(pedi_22), .peri_r10(peri_22), .pero_r10(pero_22), .pedo_r10(pedo_22), .peso_r10(peso_22),
        .pesi_r14(pesi_23), .pedi_r14(pedi_23), .peri_r14(peri_23), .pero_r14(pero_23), .pedo_r14(pedo_23), .peso_r14(peso_23),
        .pesi_r3 (pesi_30), .pedi_r3 (pedi_30), .peri_r3 (peri_30), .pero_r3 (pero_30), .pedo_r3 (pedo_30), .peso_r3 (peso_30),
        .pesi_r7 (pesi_31), .pedi_r7 (pedi_31), .peri_r7 (peri_31), .pero_r7 (pero_31), .pedo_r7 (pedo_31), .peso_r7 (peso_31),
        .pesi_r11(pesi_32), .pedi_r11(pedi_32), .peri_r11(peri_32), .pero_r11(pero_32), .pedo_r11(pedo_32), .peso_r11(peso_32),
        .pesi_r15(pesi_33), .pedi_r15(pedi_33), .peri_r15(peri_33), .pero_r15(pero_33), .pedo_r15(pedo_33), .peso_r15(peso_33)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLOCK_PERIOD / 2) clk = ~clk; // Toggle clock every half period
    end

    // Stimulus generation
    initial begin
        // Initialize signals
        reset = 1;
        pesi_00 = 0; pesi_01 = 0; pesi_02 = 0; pesi_03 = 0;
        pesi_10 = 0; pesi_11 = 0; pesi_12 = 0; pesi_13 = 0;
        pesi_20 = 0; pesi_21 = 0; pesi_22 = 0; pesi_23 = 0;
        pesi_30 = 0; pesi_31 = 0; pesi_32 = 0; pesi_33 = 0;

        #15 reset = 0; // Release reset


        // Test 1: R(1,1) sends package to all other nodes
        #10 pesi_11 = 1;
            pedi_11 = {1'b0, 2'b00, 5'b00000, 8'h11, 16'h0101, 32'h1111_1111};     // R(0,0)
        // #10 pedi_11 = {1'b1, 2'b00, 5'b00000, 8'h10, 16'h0101, 32'h1111_1111};     // R(0,1)
        // #10 pedi_11 = {1'b0, 2'b01, 5'b00000, 8'h11, 16'h0101, 32'h2222_2222};     // R(0,2)
        // #10 pedi_11 = {1'b1, 2'b01, 5'b00000, 8'h12, 16'h0101, 32'h3333_3333};     // R(0,3)
        // #10 pedi_11 = {1'b0, 2'b00, 5'b00000, 8'h01, 16'h0101, 32'h4444_4444};     // R(1,0)
        // // this line is R(1,1) itself
        // #10 pedi_11 = {1'b1, 2'b01, 5'b00000, 8'h01, 16'h0101, 32'h6666_6666};     // R(1,2)
        // #10 pedi_11 = {1'b0, 2'b01, 5'b00000, 8'h02, 16'h0101, 32'h7777_7777};     // R(1,3)
        // #10 pedi_11 = {1'b1, 2'b10, 5'b00000, 8'h11, 16'h0101, 32'h8888_8888};     // R(2,0)
        // #10 pedi_11 = {1'b0, 2'b10, 5'b00000, 8'h10, 16'h0101, 32'h9999_9999};     // R(2,1)
        // #10 pedi_11 = {1'b1, 2'b11, 5'b00000, 8'h11, 16'h0101, 32'hAAAA_AAAA};     // R(2,2)
        // #10 pedi_11 = {1'b0, 2'b11, 5'b00000, 8'h12, 16'h0101, 32'hBBBB_BBBB};     // R(2,3)
        // #10 pedi_11 = {1'b1, 2'b10, 5'b00000, 8'h21, 16'h0101, 32'hCCCC_CCCC};     // R(3,0)
        // #10 pedi_11 = {1'b0, 2'b10, 5'b00000, 8'h20, 16'h0101, 32'hDDDD_DDDD};     // R(3,1)
        // #10 pedi_11 = {1'b1, 2'b11, 5'b00000, 8'h21, 16'h0101, 32'hEEEE_EEEE};     // R(3,2)
        // #10 pedi_11 = {1'b0, 2'b11, 5'b00000, 8'h22, 16'h0101, 32'hFFFF_FFFF};     // R(3,3)
        #10 pesi_11 = 0;


        // Test 2: All other nodes send packages to R(2,2)
        #50 
        pedi_00 = 1; pedi_00 = {1'b0, 2'b11, 5'b00000, 8'h22, 16'h0000, 32'h1111_1111};    // R(0,0)
        // pedi_01 = 1; pedi_01 = {1'b1, 2'b11, 5'b00000, 8'h21, 16'h0001, 32'h1111_1111};    // R(0,1)
        // pedi_02 = 1; pedi_02 = {1'b0, 2'b10, 5'b00000, 8'h20, 16'h0002, 32'h2222_2222};    // R(0,2)
        // pedi_03 = 1; pedi_03 = {1'b1, 2'b10, 5'b00000, 8'h21, 16'h0003, 32'h3333_3333};    // R(0,3)
        // pedi_10 = 1; pedi_10 = {1'b0, 2'b11, 5'b00000, 8'h12, 16'h0100, 32'h4444_4444};    // R(1,0)
        // pedi_11 = 1; pedi_11 = {1'b1, 2'b11, 5'b00000, 8'h11, 16'h0101, 32'h5555_5555};    // R(1,1)
        // pedi_12 = 1; pedi_12 = {1'b0, 2'b10, 5'b00000, 8'h10, 16'h0102, 32'h6666_6666};    // R(1,2)
        // pedi_13 = 1; pedi_13 = {1'b1, 2'b10, 5'b00000, 8'h11, 16'h0103, 32'h7777_7777};    // R(1,3)
        // pedi_20 = 1; pedi_20 = {1'b0, 2'b01, 5'b00000, 8'h02, 16'h0200, 32'h8888_8888};    // R(2,0)
        // pedi_21 = 1; pedi_21 = {1'b1, 2'b01, 5'b00000, 8'h01, 16'h0201, 32'h9999_9999};    // R(2,1)
        // // this line is R(2,2) itself
        // pedi_23 = 1; pedi_23 = {1'b0, 2'b00, 5'b00000, 8'h01, 16'h0203, 32'hBBBB_BBBB};    // R(2,3)
        // pedi_30 = 1; pedi_30 = {1'b1, 2'b01, 5'b00000, 8'h12, 16'h0300, 32'hCCCC_CCCC};    // R(3,0)
        // pedi_31 = 1; pedi_31 = {1'b0, 2'b01, 5'b00000, 8'h11, 16'h0301, 32'hDDDD_DDDD};    // R(3,1)
        // pedi_32 = 1; pedi_32 = {1'b1, 2'b00, 5'b00000, 8'h10, 16'h0302, 32'hEEEE_EEEE};    // R(3,2)
        // pedi_33 = 1; pedi_33 = {1'b0, 2'b00, 5'b00000, 8'h11, 16'h0303, 32'hFFFF_FFFF};    // R(3,3)

        #10
        pedi_00 = 0; pedi_01 = 0; pedi_02 = 0; pedi_03 = 0;
        pedi_10 = 0; pedi_11 = 0; pedi_12 = 0; pedi_13 = 0;
        pedi_20 = 0; pedi_21 = 0; pedi_23 = 0; 
        pedi_30 = 0; pedi_31 = 0; pedi_32 = 0; pedi_33 = 0;


        #100;
        $finish;
    end

endmodule
