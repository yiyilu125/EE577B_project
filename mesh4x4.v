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
                             pedo_r2, pedo_r3
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

    router #(
        .DATA_WIDTH(DATA_WIDTH),
        .CURRENT_ADDRESS(16'b0000_0011_0000_0000), //current address in the mesh
        .BUFFER_DEPTH(DEPTH)
    ) r4 (
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

    router #(
        .DATA_WIDTH(DATA_WIDTH),
        .CURRENT_ADDRESS(16'b0000_0011_0000_0000), //current address in the mesh
        .BUFFER_DEPTH(DEPTH)
    ) r5 (
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

    router #(
        .DATA_WIDTH(DATA_WIDTH),
        .CURRENT_ADDRESS(16'b0000_0011_0000_0000), //current address in the mesh
        .BUFFER_DEPTH(DEPTH)
    ) r6 (
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

    router #(
        .DATA_WIDTH(DATA_WIDTH),
        .CURRENT_ADDRESS(16'b0000_0011_0000_0000), //current address in the mesh
        .BUFFER_DEPTH(DEPTH)
    ) r7 (
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
endmodule
