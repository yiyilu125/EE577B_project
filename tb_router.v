module tb_router();

    reg pesi_r1, pedi_r1;
    wire weso_r1_r2;
    reg wero_r1_r2;
    wire [63:0] wedo_r1_r2
    wire peri_r1;

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
endmodule
