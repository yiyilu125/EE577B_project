/*
this is a 4x4 mesh with 16 routers with addresses from 16'h0000 - 16'h0303

*/
module mesh4x4 #(
    parameter DATA_WIDTH = 64,  // Width of the data
    parameter DEPTH = 1         // Depth of the buffer
)(
    input a;
    output b;
)
    //vertical wires for column 0: for r0 <--> r1 <--> r2 <--> r3
    wire weso_r0_r1, wero_r0_r1;
    wire weso_r1_r0, wero_r1_r0;
    //vertical wires for column 1: for r4 <--> r5 <--> r6 <--> r7
    //vertical wires for column 2: for r8 <--> r9 <--> r10 <--> r11
    //vertical wires for column 3: for r12 <--> r13 <--> r14 <--> r15

    //horizontal wires for row 0: for 16'h0000 <--> 16'h0001 <--> 16'h0002 <--> 16'h0003
    //horizontal wires for roq 1: for 16'h0100 <--> 16'h0101<--> 16'h0102 <--> 16'h0103
    //horizontal wires for roq 2: for 16'h0200 <--> 16'h0201 <--> 16'h0202 <--> 16'h0203
    //horizontal wires for roq 3: for 16'h0300 <--> 16'h0301 <--> 16'h0302 <--> 16'h0303

    router #(
        .DATA_WIDTH(DATA_WIDTH),
        .CURRENT_ADDRESS(16'b0000_0000_0000_0000), //current address in the mesh
        .BUFFER_DEPTH(DEPTH)
    ) r0 (
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
        .ewso(),
        .ewro(),
        .ewdo(),

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
        .pesi(),
        .pedi(),
        .peri(),
        .peso(),
        .pero(),
        .pedo()
    );
endmodule;
