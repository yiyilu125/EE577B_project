module tb_hotpot;
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
    // reg [3:0] count;
    // reg [31:0] data_mem [0:15];

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

    
    // Open Logfiles
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
        reg [15:0] source;              // Source (16 bits)
        reg [31:0] payload;             // Payload (32 bits)
        reg [7:0] des_x, des_y;         // Calculated destination coordinates
        reg [3:0] des;
        reg [15:0] hop;

        begin
            // Extract fields from the packet
            dir = packet[62:61];
            hop = packet[55:48];
            source = packet[47:32];
            payload = packet[31:0];

            // Calculate destination coordinates (des_x, des_y)
            des_x = (dir[1]) ? (source[15:8] + hop[7:4]) : (source[15:8] - hop[7:4]);
            des_y = (dir[0]) ? (source[7:0] + hop[3:0]) : (source[7:0] - hop[3:0]);        
            des = des_y * 4 + des_x;

            // Log the packet information in the specified format
            $fwrite(file, "Phase = %0d, Time = %0d, Destination = R%0d(%0d,%0d), Source = R%0d(%0d,%0d), HopValue = %02h, PacketValue = %016h\n", 
                    phase, $time, des, des_x, des_y, phase, source[15:8], source[7:0], hop, 64'(packet));
        end
    endtask


    // Output log printing module
    always @(posedge clk) begin
        if (!reset) begin
            if (peso_00) printlog(0,  logfile[0],  pedo_00);
            if (peso_10) printlog(1,  logfile[1],  pedo_10);
            if (peso_20) printlog(2,  logfile[2],  pedo_20);
            if (peso_30) printlog(3,  logfile[3],  pedo_30);
            if (peso_01) printlog(4,  logfile[4],  pedo_01);
            if (peso_11) printlog(5,  logfile[5],  pedo_11);
            if (peso_21) printlog(6,  logfile[6],  pedo_21);
            if (peso_31) printlog(7,  logfile[7],  pedo_31);
            if (peso_02) printlog(8,  logfile[8],  pedo_02);
            if (peso_12) printlog(9,  logfile[9],  pedo_12);
            if (peso_22) printlog(10, logfile[10], pedo_22);
            if (peso_32) printlog(11, logfile[11], pedo_32);
            if (peso_03) printlog(12, logfile[12], pedo_03);
            if (peso_13) printlog(13, logfile[13], pedo_13);
            if (peso_23) printlog(14, logfile[14], pedo_23);
            if (peso_33) printlog(15, logfile[15], pedo_33);
        end
    end


    function [63:0] packet_gen;
        input integer src;
        input integer des;

        reg [1:0] dir;
        reg [7:0] src_x, src_y, des_x, des_y;
        reg [3:0] hop_x, hop_y;

        begin
            src_x = src % 4;
            src_y = src / 4;
            des_x = des % 4;
            des_y = des / 4;
            hop_x = (des_x > src_x) ? (des_x - src_x) : (src_x - des_x);
            dir[1] = (des_x > src_x) ? 1 : 0;
            hop_y = (des_y > src_y) ? (des_y - src_y) : (src_y - des_y);
            dir[0] = (des_y > src_y) ? 1 : 0;

            packet_gen = {1'b0, dir, 5'b00000, hop_x, hop_y, src_x, src_y, 32'h1111_0000 * src};
        end
    endfunction


    // Stimulus generation
    initial begin
        // Initialize signals
        reset = 1;
        pesi_00 = 0; pesi_01 = 0; pesi_02 = 0; pesi_03 = 0;
        pesi_10 = 0; pesi_11 = 0; pesi_12 = 0; pesi_13 = 0;
        pesi_20 = 0; pesi_21 = 0; pesi_22 = 0; pesi_23 = 0;
        pesi_30 = 0; pesi_31 = 0; pesi_32 = 0; pesi_33 = 0;

        pero_00 = 1; pero_01 = 1; pero_02 = 1; pero_03 = 1;
        pero_10 = 1; pero_11 = 1; pero_12 = 1; pero_13 = 1;
        pero_20 = 1; pero_21 = 1; pero_22 = 1; pero_23 = 1;
        pero_30 = 1; pero_31 = 1; pero_32 = 1; pero_33 = 1;

        #10 reset = 0;

        #50
        pesi_02 = 1; 

        repeat (5) begin
            pedi_02 = packet_gen(8,9)  + ($time / 10);   
            #10;
        end

        pedi_02 = packet_gen(8,10); 
        
        #10 pesi_02 = 0;


        #300

        for (i = 0; i < 16; i = i + 1) begin
            $fclose(logfile[i]);
        end
        $finish;
    end


always @(negedge clk) begin 
    if (!reset) begin 
        if($time / 10 < 50) begin
            // busy node 9(1,2)
            pesi_13 = 1; pedi_13 = packet_gen(13,9) + ($time / 10);
            pesi_22 = 1; pedi_22 = packet_gen(10,9) + ($time / 10);
            pesi_11 = 1; pedi_11 = packet_gen(5, 9) + ($time / 10);

            // // busy node 10(2,2)
            // pesi_23 = 1; pedi_23 = packet_gen(14,10) + ($time / 10);
            // pesi_32 = 1; pedi_32 = packet_gen(11,10) + ($time / 10);
            // pesi_21 = 1; pedi_21 = packet_gen(6, 10) + ($time / 10);

        end else begin 
            pesi_13 = 0; pedi_13 = 0;
            pesi_22 = 0; pedi_22 = 0;
            pesi_11 = 0; pedi_11 = 0;
            // pesi_23 = 0; pedi_23 = 0;
            // pesi_32 = 0; pedi_32 = 0;
            // pesi_21 = 0; pedi_21 = 0;
        end
    end
end
 

endmodule
