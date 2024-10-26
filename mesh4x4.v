/*
this is a 4x4 mesh with 16 routers with addresses from 16'h0000 - 16'h0303

*/
module mesh4x4 #(
    parameter DATA_WIDTH = 64,  // Width of the data
    parameter DEPTH = 1         // Depth of the buffer
)(
    //row: r0-r3
    input pesi_r0, pero_r0, pesi_r1, pero_r1, 
          pesi_r2, pero_r2, pesi_r3, pero_r3,
    input [DATA_WIDTH-1:0] pedi_r0, pedi_r1, 
                            pedi_r2, pedi_r3,
    output peri_r0, peso_r0, peri_r1, peso_r1, 
           peri_r2, peso_r2, peri_r3, peso_r3,
    output [DATA_WIDTH-1:0] pedo_r0, pedo_r1, 
                             pedo_r2, pedo_r3,

    //row: r4-r7
    input pesi_r4, pero_r4, pesi_r5, pero_r5, 
          pesi_r6, pero_r6, pesi_r7, pero_r7,
    input [DATA_WIDTH-1:0] pedi_r4, pedi_r5, 
                            pedi_r6, pedi_r7,
    output peri_r4, peso_r4, peri_r5, peso_r5, 
           peri_r6, peso_r6, peri_r7, peso_r7,
    output [DATA_WIDTH-1:0] pedo_r4, pedo_r5, 
                             pedo_r6, pedo_r7,

    //row: r8-r11
    input pesi_r8, pero_r8, pesi_r9, pero_r9, 
          pesi_r10, pero_r10, pesi_r11, pero_r11,
    input [DATA_WIDTH-1:0] pedi_r8, pedi_r9, 
                            pedi_r10, pedi_r11,
    output peri_r8, peso_r8, peri_r9, peso_r9, 
           peri_r10, peso_r10, peri_r11, peso_r11,
    output [DATA_WIDTH-1:0] pedo_r8, pedo_r9, 
                             pedo_r10, pedo_r11,
    //row: r12-r15
    input pesi_r12, pero_r12, pesi_r13, pero_r13, 
          pesi_r14, pero_r14, pesi_r15, pero_r15,
    input [DATA_WIDTH-1:0] pedi_r12, pedi_r13, 
                            pedi_r14, pedi_r15,
    output peri_r12, peso_r12, peri_r13, peso_r13, 
           peri_r14, peso_r14, peri_r15, peso_r15,
    output [DATA_WIDTH-1:0] pedo_r12, pedo_r13, 
                             pedo_r14, pedo_r15
);
    //vertical wires for column 0: for r0 <--> r1 <--> r2 <--> r3 and PE
    wire wes_r0_r1, wer_r0_r1;
    wire ews_r1_r0, ewr_r1_r0;
    wire [DATA_WIDTH-1:0] wed_r0_r1, ewd_r1_r0;
    wire wes_r1_r2, wer_r1_r2;
    wire wes_r2_r1, wer_r2_r1;
    wire [DATA_WIDTH-1:0] wed_r1_r2, ewd_r2_r1;
    wire wes_r2_r3, wer_r2_r3;
    wire ews_r3_r2, ewr_r3_r2;
    wire [DATA_WIDTH-1:0] wed_r2_r3, ewd_r3_r2;
    
    //vertical wires for column 1: for r4 <--> r5 <--> r6 <--> r7 and PE
    wire wes_r4_r5, wer_r4_r5;
    wire ews_r5_r4, ewr_r5_r4;
    wire [DATA_WIDTH-1:0] wed_r4_r5, ewd_r5_r4;
    wire wes_r5_r6, wer_r5_r6;
    wire wes_r6_r5, wer_r6_r5;
    wire [DATA_WIDTH-1:0] wed_r5_r6, ewd_r6_r5;
    wire wes_r6_r7, wer_r6_r7;
    wire ews_r7_r6, ewr_r7_r6;
    wire [DATA_WIDTH-1:0] wed_r6_r7, ewd_r7_r6;
    //vertical wires for column 2: for r8 <--> r9 <--> r10 <--> r11
    wire wes_r8_r9, wer_r8_r9;
    wire ews_r9_r8, ewr_r9_r8;
    wire [DATA_WIDTH-1:0] wed_r8_r9, ewd_r9_r8;
    wire wes_r9_r10, wer_r9_r10;
    wire wes_r10_r9, wer_r10_r9;
    wire [DATA_WIDTH-1:0] wed_r9_r10, ewd_r10_r9;
    wire wes_r10_r11, wer_r10_r11;
    wire ews_r11_r10, ewr_r11_r10;
    wire [DATA_WIDTH-1:0] wed_r10_r11, ewd_r11_r10;
    //vertical wires for column 3: for r12 <--> r13 <--> r14 <--> r15
    wire wes_r12_r13, wer_r12_r13;
    wire ews_r13_r12, ewr_r13_r12;
    wire [DATA_WIDTH-1:0] wed_r12_r13, ewd_r13_r12;
    wire wes_r13_r14, wer_r13_r14;
    wire wes_r14_r13, wer_r14_r13;
    wire [DATA_WIDTH-1:0] wed_r13_r14, ewd_r14_r13;
    wire wes_r14_r15, wer_r14_r15;
    wire ews_r15_r14, ewr_r15_r14;
    wire [DATA_WIDTH-1:0] wed_r14_r15, ewd_r15_r14;

    //horizontal wires for row 0: for r0 <--> r4 <--> r8 <--> r12
    wire sns_r0_r4, snr_r0_r4;
    wire nss_r4_r0, snr_r4_r0;
    wire [DATA_WIDTH-1:0] snd_r0_r4, nsd_r4_r0;
    wire sns_r4_r8, snr_r4_r8;
    wire nss_r8_r4, snr_r8_r4;
    wire [DATA_WIDTH-1:0] snd_r4_r8, nsd_r8_r4;
    wire sns_r8_r12, snr_r8_r12;
    wire nss_r12_r8, snr_r12_r8;
    wire [DATA_WIDTH-1:0] snd_r8_r12, nsd_r12_r8;
    //horizontal wires for roq 1: for r1 <--> r5 <--> r9 <--> r13
    wire sns_r1_r5, snr_r1_r5;
    wire nss_r5_r1, snr_r5_r1;
    wire [DATA_WIDTH-1:0] snd_r1_r5, nsd_r5_r1;
    wire sns_r5_r9, snr_r5_r9;
    wire nss_r9_r5, snr_r9_r5;
    wire [DATA_WIDTH-1:0] snd_r5_r9, nsd_r9_r5;
    wire sns_r9_r13, snr_r9_r13;
    wire nss_r13_r9, snr_r13_r9;
    wire [DATA_WIDTH-1:0] snd_r9_r13, nsd_r13_r9;

    //horizontal wires for roq 2: for r2 <--> r6 <--> r10 <--> r14
    wire sns_r2_r6, snr_r2_r6;
    wire nss_r6_r2, snr_r6_r2;
    wire [DATA_WIDTH-1:0] snd_r2_r6, nsd_r6_r2;
    wire sns_r6_r10, snr_r6_r10;
    wire nss_r10_r6, snr_r10_r6;
    wire [DATA_WIDTH-1:0] snd_r6_r10, nsd_r10_r6;
    wire sns_r10_r14, snr_r10_r14;
    wire nss_r14_r10, snr_r14_r10;
    wire [DATA_WIDTH-1:0] snd_r10_r14, nsd_r14_r10;

    //horizontal wires for roq 3: for r3 <--> r7 <--> r11 <--> r15
    wire sns_r3_r7, snr_r3_r7;
    wire nss_r7_r3, snr_r7_r3;
    wire [DATA_WIDTH-1:0] snd_r3_r7, nsd_r7_r3;
    wire sns_r7_r11, snr_r7_r11;
    wire nss_r11_r7, snr_r11_r7;
    wire [DATA_WIDTH-1:0] snd_r7_r11, nsd_r11_r7;
    wire sns_r11_r15, snr_r11_r15;
    wire nss_r15_r11, snr_r15_r11;
    wire [DATA_WIDTH-1:0] snd_r11_r15, nsd_r15_r11;

    //r0 <--> r1 <--> r2 <--> r3
    router #(
        .DATA_WIDTH(DATA_WIDTH),
        .CURRENT_ADDRESS(16'b0000_0000_0000_0000), //current address in the mesh
        .BUFFER_DEPTH(DEPTH)
    ) r0 (
        .clk(clk),
        .reset(reset),
        .polarity(polarity),

        // West to East interface (connects to r1)
        .wesi(),
        .wedi(),
        .weri(),
        .weso(wes_r0_r1),
        .wero(wer_r0_r1),
        .wedo(wed_r0_r1),

        // East to West interface (no connection to the left)
        .ewsi(ews_r1_r0),
        .ewdi(ewd_r1_r0),
        .ewri(ewr_r1_r0),
        .ewso(),
        .ewro(),
        .ewdo(),

        // North to South interface (connects to r3)
        .nssi(nss_r4_r0),
        .nsdi(nsd_r4_r0),
        .nsri(nsr_r4_r0),
        .nsso(),
        .nsro(),
        .nsdo(),

        // South to North interface (no connection below)
        .snsi(),
        .sndi(),
        .snri(),
        .snso(sns_r0_r4),
        .snro(snr_r0_r4),
        .sndo(snd_r0_r4),

        // NIC & PE interface (external input/output)
        .pesi(pesi_r0),
        .pedi(pedi_r0),
        .peri(peri_r0),
        .peso(peso_r0),
        .pero(pero_r0),
        .pedo(pedo_r0)
    );

    router #(
        .DATA_WIDTH(DATA_WIDTH),
        .CURRENT_ADDRESS(16'b0000_0001_0000_0000), //current address in the mesh
        .BUFFER_DEPTH(DEPTH)
    ) r1 (
        .clk(clk),
        .reset(reset),
        .polarity(polarity),

        // West to East interface (connects to r2)
        .wesi(wes_r0_r1),
        .wedi(wed_r0_r1),
        .weri(wer_r0_r1),
        .weso(wes_r1_r2),
        .wero(wer_r1_r2),
        .wedo(wed_r1_r2),

        // East to West interface (no connection to the left)
        .ewsi(ews_r2_r1),
        .ewdi(ewd_r2_r1),
        .ewri(ewr_r2_r1),
        .ewso(ews_r1_r0),
        .ewro(ewr_r1_r0),
        .ewdo(ewd_r1_r0),

        // North to South interface (connects to r3)
        .nssi(nss_r5_r1),
        .nsdi(nsd_r5_r1),
        .nsri(nsr_r5_r1),
        .nsso(),
        .nsro(),
        .nsdo(),

        // South to North interface (no connection below)
        .snsi(),
        .sndi(),
        .snri(),
        .snso(sns_r1_r5),
        .snro(snr_r1_r5),
        .sndo(snd_r1_r5),

        // NIC & PE interface (external input/output)
        .pesi(pesi_r1),
        .pedi(pedi_r1),
        .peri(peri_r1),
        .peso(peso_r1),
        .pero(pero_r1),
        .pedo(pedo_r1)
    );

    router #(
        .DATA_WIDTH(DATA_WIDTH),
        .CURRENT_ADDRESS(16'b0000_0010_0000_0000), //current address in the mesh
        .BUFFER_DEPTH(DEPTH)
    ) r2 (
        .clk(clk),
        .reset(reset),
        .polarity(polarity),

        // West to East interface (connects to r2)
        .wesi(wes_r1_r2),
        .wedi(wed_r1_r2),
        .weri(wer_r1_r2),
        .weso(wes_r2_r3),
        .wero(wer_r2_r3),
        .wedo(wed_r2_r3),

        // East to West interface (no connection to the left)
        .ewsi(ews_r3_r2),
        .ewdi(ewd_r3_r2),
        .ewri(ewr_r3_r2),
        .ewso(ews_r2_r1),
        .ewro(ewr_r2_r1),
        .ewdo(ewd_r2_r1),

        // North to South interface (connects to r3)
        .nssi(nss_r6_r2),
        .nsdi(nsd_r6_r2),
        .nsri(nsr_r6_r2),
        .nsso(),
        .nsro(),
        .nsdo(),

        // South to North interface (no connection below)
        .snsi(),
        .sndi(),
        .snri(),
        .snso(sns_r2_r6),
        .snro(snr_r2_r6),
        .sndo(snd_r2_r6),

        // NIC & PE interface (external input/output)
        .pesi(pesi_r2),
        .pedi(pedi_r2),
        .peri(peri_r2),
        .peso(peso_r2),
        .pero(pero_r2),
        .pedo(pedo_r2)
    );

    router #(
        .DATA_WIDTH(DATA_WIDTH),
        .CURRENT_ADDRESS(16'b0000_0011_0000_0000), //current address in the mesh
        .BUFFER_DEPTH(DEPTH)
    ) r3 (
        .clk(clk),
        .reset(reset),
        .polarity(polarity),

        // West to East interface (connects to r2)
        .wesi(wes_r2_r3),
        .wedi(wed_r2_r3),
        .weri(wer_r2_r3),
        .weso(),
        .wero(),
        .wedo(),

        // East to West interface (no connection to the left)
        .ewsi(),
        .ewdi(),
        .ewri(),
        .ewso(ews_r3_r2),
        .ewro(ewr_r3_r2),
        .ewdo(ewd_r3_r2),

        // North to South interface (connects to r3)
        .nssi(nss_r7_r3),
        .nsdi(nsd_r7_r3),
        .nsri(nsr_r7_r3),
        .nsso(),
        .nsro(),
        .nsdo(),

        // South to North interface (no connection below)
        .snsi(),
        .sndi(),
        .snri(),
        .snso(sns_r3_r7),
        .snro(snr_r3_r7),
        .sndo(snd_r3_r7),

        // NIC & PE interface (external input/output)
        .pesi(pesi_r3),
        .pedi(pedi_r3),
        .peri(peri_r3),
        .peso(peso_r3),
        .pero(pero_r3),
        .pedo(pedo_r3)
    );

    //r4 <--> r5 <--> r6 <--> r7
    router #(
        .DATA_WIDTH(DATA_WIDTH),
        .CURRENT_ADDRESS(16'b0000_0000_0000_0001), //current address in the mesh
        .BUFFER_DEPTH(DEPTH)
    ) r4 (
        .clk(clk),
        .reset(reset),
        .polarity(polarity),

        // West to East interface (connects to r1)
        .wesi(),
        .wedi(),
        .weri(),
        .weso(wes_r4_r5),
        .wero(wer_r4_r5),
        .wedo(wed_r4_r5),

        // East to West interface (no connection to the left)
        .ewsi(ews_r5_r4),
        .ewdi(ewd_r5_r4),
        .ewri(ewr_r5_r4),
        .ewso(),
        .ewro(),
        .ewdo(),

        // North to South interface (connects to r3)
        .nssi(nss_r8_r4),
        .nsdi(nsd_r8_r4),
        .nsri(nsr_r8_r4),
        .nsso(nss_r4_r0),
        .nsro(nsr_r4_r0),
        .nsdo(nsd_r4_r0),

        // South to North interface (no connection below)
        .snsi(sns_r0_r4),
        .sndi(snd_r0_r4),
        .snri(snr_r0_r4),
        .snso(sns_r4_r8),
        .snro(snr_r4_r8),
        .sndo(snd_r4_r8),

        // NIC & PE interface (external input/output)
        .pesi(pesi_r4),
        .pedi(pedi_r4),
        .peri(peri_r4),
        .peso(peso_r4),
        .pero(pero_r4),
        .pedo(pedo_r4)
    );

    router #(
        .DATA_WIDTH(DATA_WIDTH),
        .CURRENT_ADDRESS(16'b0000_0001_0000_0001), //current address in the mesh
        .BUFFER_DEPTH(DEPTH)
    ) r5 (
        .clk(clk),
        .reset(reset),
        .polarity(polarity),

        // West to East interface (connects to r2)
        .wesi(wes_r4_r5),
        .wedi(wed_r4_r5),
        .weri(wer_r4_r5),
        .weso(wes_r5_r6),
        .wero(wer_r5_r6),
        .wedo(wed_r5_r6),

        // East to West interface (no connection to the left)
        .ewsi(ews_r6_r5),
        .ewdi(ewd_r6_r5),
        .ewri(ewr_r6_r5),
        .ewso(ews_r5_r4),
        .ewro(ewr_r5_r4),
        .ewdo(ewd_r5_r4),

        // North to South interface (connects to r3)
        .nssi(nss_r9_r5),
        .nsdi(nsd_r9_r5),
        .nsri(nsr_r9_r5),
        .nsso(nss_r5_r1),
        .nsro(nsr_r5_r1),
        .nsdo(nsd_r5_r1),

        // South to North interface (no connection below)
        .snsi(sns_r1_r5),
        .sndi(snd_r1_r5),
        .snri(snr_r1_r5),
        .snso(sns_r5_r9),
        .snro(snr_r5_r9),
        .sndo(snd_r5_r9),

        // NIC & PE interface (external input/output)
        .pesi(pesi_r5),
        .pedi(pedi_r5),
        .peri(peri_r5),
        .peso(peso_r5),
        .pero(pero_r5),
        .pedo(pedo_r5)
    );

    router #(
        .DATA_WIDTH(DATA_WIDTH),
        .CURRENT_ADDRESS(16'b0000_0010_0000_0001), //current address in the mesh
        .BUFFER_DEPTH(DEPTH)
    ) r6 (
        .clk(clk),
        .reset(reset),
        .polarity(polarity),

        // West to East interface (connects to r2)
        .wesi(wes_r5_r6),
        .wedi(wed_r5_r6),
        .weri(wer_r5_r6),
        .weso(wes_r6_r7),
        .wero(wer_r6_r7),
        .wedo(wed_r6_r7),

        // East to West interface (no connection to the left)
        .ewsi(ews_r7_r6),
        .ewdi(ewd_r7_r6),
        .ewri(ewr_r7_r6),
        .ewso(ews_r6_r5),
        .ewro(ewr_r6_r5),
        .ewdo(ewd_r6_r5),

        // North to South interface (connects to r3)
        .nssi(nss_r10_r6),
        .nsdi(nsd_r10_r6),
        .nsri(nsr_r10_r6),
        .nsso(nss_r6_r2),
        .nsro(nsr_r6_r2),
        .nsdo(nsd_r6_r2),

        // South to North interface (no connection below)
        .snsi(sns_r2_r6),
        .sndi(snd_r2_r6),
        .snri(snr_r2_r6),
        .snso(sns_r6_r10),
        .snro(snr_r6_r10),
        .sndo(snd_r6_r10),

        // NIC & PE interface (external input/output)
        .pesi(pesi_r6),
        .pedi(pedi_r6),
        .peri(peri_r6),
        .peso(peso_r6),
        .pero(pero_r6),
        .pedo(pedo_r6)
    );

    router #(
        .DATA_WIDTH(DATA_WIDTH),
        .CURRENT_ADDRESS(16'b0000_0011_0000_0001), //current address in the mesh
        .BUFFER_DEPTH(DEPTH)
    ) r7 (
        .clk(clk),
        .reset(reset),
        .polarity(polarity),

        // West to East interface (connects to r2)
        .wesi(wes_r6_r7),
        .wedi(wed_r6_r7),
        .weri(wer_r6_r7),
        .weso(),
        .wero(),
        .wedo(),

        // East to West interface (no connection to the left)
        .ewsi(),
        .ewdi(),
        .ewri(),
        .ewso(ews_r7_r6),
        .ewro(ewr_r7_r6),
        .ewdo(ewd_r7_r6),

        // North to South interface (connects to r3)
        .nssi(nss_r11_r7),
        .nsdi(nsd_r11_r7),
        .nsri(nsr_r11_r7),
        .nsso(nss_r7_r3),
        .nsro(nsr_r7_r3),
        .nsdo(nsd_r7_r3),

        // South to North interface (no connection below)
        .snsi(sns_r3_r7),
        .sndi(sns_r3_r7),
        .snri(sns_r3_r7),
        .snso(sns_r7_r11),
        .snro(snr_r7_r11),
        .sndo(snd_r7_r11),

        // NIC & PE interface (external input/output)
        .pesi(pesi_r7),
        .pedi(pedi_r7),
        .peri(peri_r7),
        .peso(peso_r7),
        .pero(pero_r7),
        .pedo(pedo_r7)
    );

       //r8 <--> r9 <--> r10 <--> r11
    router #(
        .DATA_WIDTH(DATA_WIDTH),
        .CURRENT_ADDRESS(16'b0000_0000_0000_0010), //current address in the mesh
        .BUFFER_DEPTH(DEPTH)
    ) r8 (
        .clk(clk),
        .reset(reset),
        .polarity(polarity),

        // West to East interface (connects to r1)
        .wesi(),
        .wedi(),
        .weri(),
        .weso(wes_r8_r9),
        .wero(wer_r8_r9),
        .wedo(wed_r8_r9),

        // East to West interface (no connection to the left)
        .ewsi(ews_r9_r8),
        .ewdi(ewd_r9_r8),
        .ewri(ewr_r9_r8),
        .ewso(),
        .ewro(),
        .ewdo(),

        // North to South interface (connects to r3)
        .nssi(nss_r12_r8),
        .nsdi(nsd_r12_r8),
        .nsri(nsr_r12_r8),
        .nsso(nss_r8_r4),
        .nsro(nsr_r8_r4),
        .nsdo(nsd_r8_r4),

        // South to North interface (no connection below)
        .snsi(sns_r4_r8),
        .sndi(snd_r4_r8),
        .snri(snr_r4_r8),
        .snso(sns_r8_r12),
        .snro(snr_r8_r12),
        .sndo(snd_r8_r12),

        // NIC & PE interface (external input/output)
        .pesi(pesi_r8),
        .pedi(pedi_r8),
        .peri(peri_r8),
        .peso(peso_r8),
        .pero(pero_r8),
        .pedo(pedo_r8)
    );

    router #(
        .DATA_WIDTH(DATA_WIDTH),
        .CURRENT_ADDRESS(16'b0000_0001_0000_0010), //current address in the mesh
        .BUFFER_DEPTH(DEPTH)
    ) r9 (
        .clk(clk),
        .reset(reset),
        .polarity(polarity),

        // West to East interface (connects to r2)
        .wesi(wes_r8_r9),
        .wedi(wed_r8_r9),
        .weri(wer_r8_r9),
        .weso(wes_r9_r10),
        .wero(wer_r9_r10),
        .wedo(wed_r9_r10),

        // East to West interface (no connection to the left)
        .ewsi(ews_r10_r9),
        .ewdi(ewd_r10_r9),
        .ewri(ewr_r10_r9),
        .ewso(ews_r9_r8),
        .ewro(ewr_r9_r8),
        .ewdo(ewd_r9_r8),

        // North to South interface (connects to r3)
        .nssi(nss_r13_r9),
        .nsdi(nsd_r13_r9),
        .nsri(nsr_r13_r9),
        .nsso(nss_r9_r5),
        .nsro(nsr_r9_r5),
        .nsdo(nsd_r9_r5),

        // South to North interface (no connection below)
        .snsi(sns_r5_r9),
        .sndi(snd_r5_r9),
        .snri(snr_r5_r9),
        .snso(sns_r9_r13),
        .snro(snr_r9_r13),
        .sndo(snd_r9_r13),

        // NIC & PE interface (external input/output)
        .pesi(pesi_r9),
        .pedi(pedi_r9),
        .peri(peri_r9),
        .peso(peso_r9),
        .pero(pero_r9),
        .pedo(pedo_r9)
    );

    router #(
        .DATA_WIDTH(DATA_WIDTH),
        .CURRENT_ADDRESS(16'b0000_0010_0000_0010), //current address in the mesh
        .BUFFER_DEPTH(DEPTH)
    ) r10 (
        .clk(clk),
        .reset(reset),
        .polarity(polarity),

        // West to East interface (connects to r2)
        .wesi(wes_r9_r10),
        .wedi(wed_r9_r10),
        .weri(wer_r9_r10),
        .weso(wes_r10_r11),
        .wero(wer_r10_r11),
        .wedo(wed_r10_r11),

        // East to West interface (no connection to the left)
        .ewsi(ews_r11_r10),
        .ewdi(ewd_r11_r10),
        .ewri(ewr_r11_r10),
        .ewso(ews_r10_r9),
        .ewro(ewr_r10_r9),
        .ewdo(ewd_r10_r9),

        // North to South interface (connects to r3)
        .nssi(nss_r14_r10),
        .nsdi(nsd_r14_r10),
        .nsri(nsr_r14_r10),
        .nsso(nss_r10_r6),
        .nsro(nsr_r10_r6),
        .nsdo(nsd_r10_r6),

        // South to North interface (no connection below)
        .snsi(sns_r6_r10),
        .sndi(snd_r6_r10),
        .snri(snr_r6_r10),
        .snso(sns_r10_r14),
        .snro(snr_r10_r14),
        .sndo(snd_r10_r14),

        // NIC & PE interface (external input/output)
        .pesi(pesi_r10),
        .pedi(pedi_r10),
        .peri(peri_r10),
        .peso(peso_r10),
        .pero(pero_r10),
        .pedo(pedo_r10)
    );

    router #(
        .DATA_WIDTH(DATA_WIDTH),
        .CURRENT_ADDRESS(16'b0000_0011_0000_0010), //current address in the mesh
        .BUFFER_DEPTH(DEPTH)
    ) r11 (
        .clk(clk),
        .reset(reset),
        .polarity(polarity),

        // West to East interface (connects to r2)
        .wesi(wes_r10_r11),
        .wedi(wed_r10_r11),
        .weri(wer_r10_r11),
        .weso(),
        .wero(),
        .wedo(),

        // East to West interface (no connection to the left)
        .ewsi(),
        .ewdi(),
        .ewri(),
        .ewso(ews_r11_r10),
        .ewro(ewr_r11_r10),
        .ewdo(ewd_r11_r10),

        // North to South interface (connects to r3)
        .nssi(nss_r15_r11),
        .nsdi(nsd_r15_r11),
        .nsri(nsr_r15_r11),
        .nsso(nss_r11_r7),
        .nsro(nsr_r11_r7),
        .nsdo(nsd_r11_r7),

        // South to North interface (no connection below)
        .snsi(sns_r7_r11),
        .sndi(sns_r7_r11),
        .snri(sns_r7_r11),
        .snso(sns_r11_r15),
        .snro(snr_r11_r15),
        .sndo(snd_r11_r15),

        // NIC & PE interface (external input/output)
        .pesi(pesi_r11),
        .pedi(pedi_r11),
        .peri(peri_r11),
        .peso(peso_r11),
        .pero(pero_r11),
        .pedo(pedo_r11)
    );

//r12 <--> r13 <--> r14 <--> r15
    router #(
        .DATA_WIDTH(DATA_WIDTH),
        .CURRENT_ADDRESS(16'b0000_0000_0000_0011), //current address in the mesh
        .BUFFER_DEPTH(DEPTH)
    ) r12 (
        .clk(clk),
        .reset(reset),
        .polarity(polarity),

        // West to East interface (connects to r1)
        .wesi(),
        .wedi(),
        .weri(),
        .weso(wes_r12_r13),
        .wero(wer_r12_r13),
        .wedo(wed_r12_r13),

        // East to West interface (no connection to the left)
        .ewsi(ews_r13_r12),
        .ewdi(ewd_r13_r12),
        .ewri(ewr_r13_r12),
        .ewso(),
        .ewro(),
        .ewdo(),

        // North to South interface (connects to r3)
        .nssi(),
        .nsdi(),
        .nsri(),
        .nsso(nss_r12_r8),
        .nsro(nsr_r12_r8),
        .nsdo(nsd_r12_r8),

        // South to North interface (no connection below)
        .snsi(sns_r8_r12),
        .sndi(snd_r8_r12),
        .snri(snr_r8_r12),
        .snso(),
        .snro(),
        .sndo(),

        // NIC & PE interface (external input/output)
        .pesi(pesi_r12),
        .pedi(pedi_r12),
        .peri(peri_r12),
        .peso(peso_r12),
        .pero(pero_r12),
        .pedo(pedo_r12)
    );

    router #(
        .DATA_WIDTH(DATA_WIDTH),
        .CURRENT_ADDRESS(16'b0000_0001_0000_0011), //current address in the mesh
        .BUFFER_DEPTH(DEPTH)
    ) r13 (
        .clk(clk),
        .reset(reset),
        .polarity(polarity),

        // West to East interface (connects to r2)
        .wesi(wes_r12_r13),
        .wedi(wed_r12_r13),
        .weri(wer_r12_r13),
        .weso(wes_r13_r14),
        .wero(wer_r13_r14),
        .wedo(wed_r13_r14),

        // East to West interface (no connection to the left)
        .ewsi(ews_r14_r13),
        .ewdi(ewd_r14_r13),
        .ewri(ewr_r14_r13),
        .ewso(ews_r13_r12),
        .ewro(ewr_r13_r12),
        .ewdo(ewd_r13_r12),

        // North to South interface (connects to r3)
        .nssi(),
        .nsdi(),
        .nsri(),
        .nsso(nss_r13_r9),
        .nsro(nsr_r13_r9),
        .nsdo(nsd_r13_r9),

        // South to North interface (no connection below)
        .snsi(sns_r9_r13),
        .sndi(snd_r9_r13),
        .snri(snr_r9_r13),
        .snso(),
        .snro(),
        .sndo(),

        // NIC & PE interface (external input/output)
        .pesi(pesi_r13),
        .pedi(pedi_r13),
        .peri(peri_r13),
        .peso(peso_r13),
        .pero(pero_r13),
        .pedo(pedo_r13)
    );

    router #(
        .DATA_WIDTH(DATA_WIDTH),
        .CURRENT_ADDRESS(16'b0000_0010_0000_0011), //current address in the mesh
        .BUFFER_DEPTH(DEPTH)
    ) r14 (
        .clk(clk),
        .reset(reset),
        .polarity(polarity),

        // West to East interface (connects to r2)
        .wesi(wes_r13_r14),
        .wedi(wed_r13_r14),
        .weri(wer_r13_r14),
        .weso(wes_r14_r15),
        .wero(wer_r14_r15),
        .wedo(wed_r14_r15),

        // East to West interface (no connection to the left)
        .ewsi(ews_r15_r14),
        .ewdi(ewd_r15_r14),
        .ewri(ewr_r15_r14),
        .ewso(ews_r14_r13),
        .ewro(ewr_r14_r13),
        .ewdo(ewd_r14_r13),

        // North to South interface (connects to r3)
        .nssi(),
        .nsdi(),
        .nsri(),
        .nsso(nss_r14_r10),
        .nsro(nsr_r14_r10),
        .nsdo(nsd_r14_r10),

        // South to North interface (no connection below)
        .snsi(sns_r10_r14),
        .sndi(snd_r10_r14),
        .snri(snr_r10_r14),
        .snso(),
        .snro(),
        .sndo(),

        // NIC & PE interface (external input/output)
        .pesi(pesi_r14),
        .pedi(pedi_r14),
        .peri(peri_r14),
        .peso(peso_r14),
        .pero(pero_r14),
        .pedo(pedo_r14)
    );

    router #(
        .DATA_WIDTH(DATA_WIDTH),
        .CURRENT_ADDRESS(16'b0000_0011_0000_0011), //current address in the mesh
        .BUFFER_DEPTH(DEPTH)
    ) r15 (
        .clk(clk),
        .reset(reset),
        .polarity(polarity),

        // West to East interface (connects to r2)
        .wesi(wes_r14_r15),
        .wedi(wed_r14_r15),
        .weri(wer_r14_r15),
        .weso(),
        .wero(),
        .wedo(),

        // East to West interface (no connection to the left)
        .ewsi(),
        .ewdi(),
        .ewri(),
        .ewso(ews_r15_r14),
        .ewro(ewr_r15_r14),
        .ewdo(ewd_r15_r14),

        // North to South interface (connects to r3)
        .nssi(),
        .nsdi(),
        .nsri(),
        .nsso(nss_r15_r11),
        .nsro(nsr_r15_r11),
        .nsdo(nsd_r15_r11),

        // South to North interface (no connection below)
        .snsi(sns_r11_r15),
        .sndi(sns_r11_r15),
        .snri(sns_r11_r15),
        .snso(),
        .snro(),
        .sndo(),

        // NIC & PE interface (external input/output)
        .pesi(pesi_r15),
        .pedi(pedi_r15),
        .peri(peri_r15),
        .peso(peso_r15),
        .pero(pero_r15),
        .pedo(pedo_r15)
    );
endmodule
