module input_interface #(
    parameter DATA_WIDTH = 64,  // Width of the data
    parameter CURRENT_ADDRESS = 16'b0000_0000_0000_0000, //current address in the mesh
    parameter DIRECTION = 5'b00001, //the direction of the intput: L:10000, R:01000, U:00100, D:00010, PE:00001
    parameter BUFFER_DEPTH = 1
)(
    input si,
    input clk, rst,
    input buf_clear_1, buf_clear_2, buf_clear_3, buf_clear_4,
    input [63:0] datai,
    output ri,
    output [4:0] reqL, reqR, reqU, reqD, reqPE,
    output [63:0] dataoL, dataoR, dataoU, dataoD, dataoPE
);
    wire req_sign_channel;
    wire [DATA_WIDTH-1:0] dataout_channel;

    //optimaize
    wire [4:0] reqR_middle_wire;
    wire [4:0] reqU_middle_wire;
    wire [DATA_WIDTH-1:0] reqU_middle_data;

    assign sig_buffer_clear = buf_clear_1 | buf_clear_2 | buf_clear_3 | buf_clear_4;

    input_ctrl #(
        .DATA_WIDTH(DATA_WIDTH),
        .BUFFER_DATA_WIDTH(DATA_WIDTH),
        .BUFFER_DEPTH(BUFFER_DEPTH)
    ) input_ctrl_uut (
        .sendI(si),
        .dataI(datai), 
        .clk(clk), 
        .rst(rst), 
        .sig_channel_clean(sig_buffer_clear), 
        .receiveI(ri),
        .inner_dataO(dataout_channel), 
        .sig_req_channel(req_sign_channel)
    );

    routing_algo #(
        .DATA_WIDTH(DATA_WIDTH), 
        .CURRENT_ADDRESS(CURRENT_ADDRESS), 
        .DIRECTION(DIRECTION)
    ) routing_algo_uut (
        .reqIn(req_sign_channel),
        .dataIn(dataout_channel),
        .reqOutL(reqL),
        .dataOutL(dataoL),
        .reqOutR(reqR_middle_wire),
        .dataOutR(dataoR),
        .reqOutU(reqU_middle_wire), 
        .dataOutU(reqU_middle_data), 
        .reqOutD(reqD), 
        .dataOutD(dataoD),
        .reqOutPE(reqPE), 
        .dataOutPE(dataoPE)
    );
    
    //optimise part
    reg [4:0] opt_reqU_wire;
    reg [DATA_WIDTH-1:0] opt_reqU_data;

    assign reqR = reqR_middle_wire;
    assign reqU = reqU_middle_wire | opt_reqU_wire;
    assign dataoU = (opt_reqU_wire == 1) ? opt_reqU_data : reqU_middle_data;
    always@(*)begin
        opt_reqU_wire = 0;
        opt_reqU_data = {DATA_WIDTH{1'b0}};
        if (DIRECTION==5'b00001 || DIRECTION==5'b00010) begin
            if(buf_clear_1 == 0 && reqR_middle_wire == 1) begin
                opt_reqU_wire = 1;
                if(DIRECTION == 5'b00001)begin
                    if(routing_algo_uut.dataOutL[61] == 1)begin
                        opt_reqU_data = {routing_algo_uut.dataOutR[63:56], {routing_algo_uut.dataOutR[55:48] - 1}, routing_algo_uut.dataOutR[47:0]};
                    end else begin 
                        opt_reqU_data = {routing_algo_uut.dataOutR[63:56], {routing_algo_uut.dataOutR[55:48] + 1}, routing_algo_uut.dataOutR[47:0]};
                    end
                end else begin
                    if(routing_algo_uut.dataOutL[61] == 1)begin
                        opt_reqU_data = {routing_algo_uut.dataOutR[63:56], {routing_algo_uut.dataOutR[55:48] - 1}, routing_algo_uut.dataOutR[47:0]};
                    end else begin 
                        opt_reqU_data = {routing_algo_uut.dataOutR[63:56], {routing_algo_uut.dataOutR[55:48] + 1}, routing_algo_uut.dataOutR[47:0]};
                    end
                end
                //opt_reqU_data = (DIRECTION == 5'b00001) ? routing_algo_uut.dataOutL : routing_algo_uut.dataOutPE;
            end
        end
    end

endmodule