module tb_mesh4x4;
    parameter CLOCK_PERIOD = 10; // Clock period in ns

    integer logfile[0:15];      // Array to hold file descriptors for 16 phases
    integer phase;              // Current phase number
    integer i;                  // loop variable
    reg [63:0] pedi [0:15];     // input data
    reg pesi [0:15];            // send input
    reg pero [0:15];
    reg [1:0] dir;              // direction
    reg [3:0] hop_x, hop_y;
    reg [7:0] src_x, src_y, des_x, des_y;

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

    initial begin
        for (phase = 0; phase < 16; phase = phase + 1) begin
            logfile[phase] = $fopen($sformatf("gather_phase%0d.res", phase), "w");
        end
    end


    // Task to print log
    task printlog;
        input integer phase;            // Current phase number (0-15)
        input integer file;             // File descriptor
        input [63:0] packet;            // 64-bit packet data

        reg [1:0] dir;                  // Direction field (2 bits)
        // reg [7:0] hop_x, hop_y;         // Hop values (8 bits)
        reg [15:0] source;              // Source (16 bits)
        reg [31:0] payload;             // Payload (32 bits)
        reg [7:0] des_x, des_y;         // Calculated destination coordinates
        reg [3:0] des;
        reg [15:0] hop;

        begin
            // Extract fields from the packet
            dir = packet[62:61];
            hop = packet[55:48];
            // hop_x = packet[55:52];      // hop[7:4] for x direction
            // hop_y = packet[51:48];      // hop[3:0] for y direction
            source = packet[47:32];
            payload = packet[31:0];

            // Calculate destination coordinates (des_x, des_y)
            des_x = (dir[1]) ? (source[15:8] + hop[7:4]) : (source[15:8] - hop[7:4]);
            des_y = (dir[0]) ? (source[7:0] + hop[3:0]) : (source[7:0] - hop[3:0]);        
            des = des_y * 4 + des_x;

            // Log the packet information in the specified format
            $fwrite(file, "Phase = %0d, Time = %0d, Destination = R%0d(%0d,%0d), Source = R%0d(%0d,%0d), HopValue = %0h, PacketValue = %016h\n", 
                    phase, $time, des, des_x, des_y, phase, source[15:8], source[7:0], hop, 64'(packet));
        end
    endtask


    // Output log printing module
    always @(posedge clk) begin
        if (!reset) begin
            if (peso_00) printlog(0,  logfile[0],  pedo_00);
            if (peso_01) printlog(1,  logfile[1],  pedo_01);
            if (peso_02) printlog(2,  logfile[2],  pedo_02);
            if (peso_03) printlog(3,  logfile[3],  pedo_03);
            if (peso_10) printlog(4,  logfile[4],  pedo_10);
            if (peso_11) printlog(5,  logfile[5],  pedo_11);
            if (peso_12) printlog(6,  logfile[6],  pedo_12);
            if (peso_13) printlog(7,  logfile[7],  pedo_13);
            if (peso_20) printlog(8,  logfile[8],  pedo_20);
            if (peso_21) printlog(9,  logfile[9],  pedo_21);
            if (peso_22) printlog(10, logfile[10], pedo_22);
            if (peso_23) printlog(11, logfile[11], pedo_23);
            if (peso_30) printlog(12, logfile[12], pedo_30);
            if (peso_31) printlog(13, logfile[13], pedo_31);
            if (peso_32) printlog(14, logfile[14], pedo_32);
            if (peso_33) printlog(15, logfile[15], pedo_33);
        end
    end


    // Stimulus generation
    initial begin
        // Initialize signals
        reset = 1;
        pesi_00 = 0; pesi_01 = 0; pesi_02 = 0; pesi_03 = 0;
        pesi_10 = 0; pesi_11 = 0; pesi_12 = 0; pesi_13 = 0;
        pesi_20 = 0; pesi_21 = 0; pesi_22 = 0; pesi_23 = 0;
        pesi_30 = 0; pesi_31 = 0; pesi_32 = 0; pesi_33 = 0;
        phase = 10;

        // phase 10 example 
        #10 reset = 0; pero_22 = 1;
        #10
        pesi_00 = 1; pedi_00 = {1'b0, 2'b11, 5'b00000, 8'h22, 16'h0000, 32'h0000_0000};    // R(0,0)
        pesi_01 = 1; pedi_01 = {1'b1, 2'b11, 5'b00000, 8'h21, 16'h0001, 32'h1111_1111};    // R(0,1)
        pesi_02 = 1; pedi_02 = {1'b0, 2'b10, 5'b00000, 8'h20, 16'h0002, 32'h2222_2222};    // R(0,2)
        pesi_03 = 1; pedi_03 = {1'b1, 2'b10, 5'b00000, 8'h21, 16'h0003, 32'h3333_3333};    // R(0,3)
        pesi_10 = 1; pedi_10 = {1'b0, 2'b11, 5'b00000, 8'h12, 16'h0100, 32'h4444_4444};    // R(1,0)
        pesi_11 = 1; pedi_11 = {1'b1, 2'b11, 5'b00000, 8'h11, 16'h0101, 32'h5555_5555};    // R(1,1)
        pesi_12 = 1; pedi_12 = {1'b0, 2'b10, 5'b00000, 8'h10, 16'h0102, 32'h6666_6666};    // R(1,2)
        pesi_13 = 1; pedi_13 = {1'b1, 2'b10, 5'b00000, 8'h11, 16'h0103, 32'h7777_7777};    // R(1,3)
        pesi_20 = 1; pedi_20 = {1'b0, 2'b01, 5'b00000, 8'h02, 16'h0200, 32'h8888_8888};    // R(2,0)
        pesi_21 = 1; pedi_21 = {1'b1, 2'b01, 5'b00000, 8'h01, 16'h0201, 32'h9999_9999};    // R(2,1)
        // this line is R(2,2) itself
        pesi_23 = 1; pedi_23 = {1'b0, 2'b00, 5'b00000, 8'h01, 16'h0203, 32'hBBBB_BBBB};    // R(2,3)
        pesi_30 = 1; pedi_30 = {1'b1, 2'b01, 5'b00000, 8'h12, 16'h0300, 32'hCCCC_CCCC};    // R(3,0)
        pesi_31 = 1; pedi_31 = {1'b0, 2'b01, 5'b00000, 8'h11, 16'h0301, 32'hDDDD_DDDD};    // R(3,1)
        pesi_32 = 1; pedi_32 = {1'b1, 2'b00, 5'b00000, 8'h10, 16'h0302, 32'hEEEE_EEEE};    // R(3,2)
        pesi_33 = 1; pedi_33 = {1'b0, 2'b00, 5'b00000, 8'h11, 16'h0303, 32'hFFFF_FFFF};    // R(3,3)

        #10
        pesi_00 = 0; pesi_01 = 0; pesi_02 = 0; pesi_03 = 0;
        pesi_10 = 0; pesi_11 = 0; pesi_12 = 0; pesi_13 = 0;
        pesi_20 = 0; pesi_21 = 0; pesi_23 = 0; 
        pesi_30 = 0; pesi_31 = 0; pesi_32 = 0; pesi_33 = 0;

        #270 
        


        // ***************************
        //  i - current src,  phase - current des
        // src_x = i % 4;
        // src_y = i / 4;
        // des_x = phase % 4
        // des_y = phase / 4;
        // hop_x = des_x - src_x;
        // hop_y = des_y - src_y;
        // 
        // ***************************

        for (phase = 0; phase < 16; phase = phase + 1) begin
            // Reset all pesi and pedi initially
            for (i = 0; i < 16; i = i + 1) begin
                pesi[i] = 1'b0; // Set pesi to 0 (no send) by default
                pedi[i] = 64'b0; // Clear pedi values
                pero[i] = 1'b0;
            end

            pero[phase] = 1;

            // Set up sending nodes for current phase
            for (i = 0; i < 16; i = i + 1) begin
                if (i != phase) begin
                    pesi[i] = 1'b1; // Set pesi to 1 for nodes sending data
                    
                    src_x = i % 4;
                    src_y = i / 4;
                    des_x = phase % 4;
                    des_y = phase / 4;
                    hop_x = (des_x > src_x) ? (des_x - src_x) : (src_x - des_x);
                    dir[1] = (des_x > src_x) ? 1 : 0;
                    hop_y = (des_y > src_y) ? (des_y - src_y) : (src_y - des_y);
                    dir[0] = (des_y > src_y) ? 1 : 0;

                    pedi[i] = {1'b0, dir, 5'b00000, hop_x, hop_y, src_x, src_y, 32'h1111_1111 * i};
                end
            end

            // Now apply pesi and pedi values to corresponding signals in your mesh.
            pero_00 = pero[0];  pesi_00 = pesi[0];  pedi_00 = pedi[0];
            pero_10 = pero[1];  pesi_10 = pesi[1];  pedi_10 = pedi[1];
            pero_20 = pero[2];  pesi_20 = pesi[2];  pedi_20 = pedi[2];
            pero_30 = pero[3];  pesi_30 = pesi[3];  pedi_30 = pedi[3];
            pero_01 = pero[4];  pesi_01 = pesi[4];  pedi_01 = pedi[4];
            pero_11 = pero[5];  pesi_11 = pesi[5];  pedi_11 = pedi[5];
            pero_21 = pero[6];  pesi_21 = pesi[6];  pedi_21 = pedi[6];
            pero_31 = pero[7];  pesi_31 = pesi[7];  pedi_31 = pedi[7];
            pero_02 = pero[8];  pesi_02 = pesi[8];  pedi_02 = pedi[8];
            pero_12 = pero[9];  pesi_12 = pesi[9];  pedi_12 = pedi[9];
            pero_22 = pero[10]; pesi_22 = pesi[10]; pedi_22 = pedi[10];
            pero_32 = pero[11]; pesi_32 = pesi[11]; pedi_32 = pedi[11];
            pero_03 = pero[12]; pesi_03 = pesi[12]; pedi_03 = pedi[12];
            pero_13 = pero[13]; pesi_13 = pesi[13]; pedi_13 = pedi[13];
            pero_23 = pero[14]; pesi_23 = pesi[14]; pedi_23 = pedi[14];
            pero_33 = pero[15]; pesi_33 = pesi[15]; pedi_33 = pedi[15];

            // Wait for a few clock cycles before moving to the next phase
            #300;
        end


        for (i = 0; i < 16; i = i + 1) begin
            $fclose(logfile[i]);
        end
        $finish;
    end

endmodule
