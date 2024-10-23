module input_interface #(
    parameter DATA_WIDTH = 64,  // Width of the data
    parameter CURRENT_ADDRESS = 16'b0000_0000_0000_0000; //current address in the mesh
    parameter DIRECTION = 5'b00001; //the direction of the intput: L:10000, R:01000, U:00100, D:00010, PE:00001
    parameter BUFFER_DEPTH = 1;
)(
    input si,
    input ri,
    input clk, rst,
    input buf_clear_1, buf_clear_2, buf_clear_3, buf_clear_4;
    input [63:0] datai,
    output [4:0] reqL, reqR, reqU, reqD, reqPE,
    output [63:0] dataoL, dataoR, dataoU, dataoD, dataoPE
);
    wire req_sign_channel;
    wire [DATA_WIDTH-1:0] dataout_channel;

    assign sig_buffer_clear = buf_clear_1 | buf_clear_2 | buf_clear_3 | buf_clear_4;

    input_ctrl input_ctrl_uut #(.DATA_WIDTH(DATA_WIDTH), .BUFFER_DATA_WIDTH(DATA_WIDTH), .BUFFER_DEPTH(BUFFER_DEPTH))(
        .sendI(si),
        .dataI(datai), 
        .clk(clk), 
        .rst(rst), 
        .sig_channel_clean(sig_buffer_clear), 
        .receiveI(ri),
        .inner_dataO(dataout_channel), 
        .sig_req_channel(req_sign_channel)
    );

    routing_algo routing_algo #(.DATA_WIDTH(DATA_WIDTH), .CURRENT_ADDRESS(CURRENT_ADDRESS), .DIRECTION(DIRECTION))(
        .reqIn(req_sign_channel),
        .dataIn(dataout_channel),
        .reqOutL(reqL),
        .dataOutL(dataoL),
        .reqOutR(reqR),
        .dataOutR(dataoR),
        .reqOutU(reqU), 
        .dataOutU(dataoU), 
        .reqOutD(reqD), 
        .dataOutD(dataoD),
        .reqOutPE(reqPE), 
        .dataOutPE(dataoPE)
    );

endmodule