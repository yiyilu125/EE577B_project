/*
in this routing algo: I will use the dir, source_address, current_address and hop value to decide which direction should
my package goes: pseudo code:
    if dir.x == 1: //goes right or stay at this x
        if (source_address.x + hop.x == current_address.x): //arrive at correct x 
            if(dir.y == 1): //goes up or stay at this y
                if (source_address.y + hop.y == current_address.y): //stay
                    reqOutPE= 1;
                else: //goes up
                    reqOutU = 1;
            else: //goes down or stay at this y
                if (current_address.y + hop.y == source_address.y): //stay
                    reqOutPE = 1;
                else: //goes down
                    reqOutD = 1;
        else: //still need to go right
            reqOutR = 1;
    else: //goes left
        if (current_address.x + hop.x == source_address.x): //arrive at correct x 
            if(dir.y == 1): //goes up or stay at this y
                if (source_address.y + hop.y == current_address.y): //stay
                    reqOutPE= 1;
                else: //goes up
                    reqOutU = 1;
            else: //goes down or stay at this y
                if (current_address.y + hop.y == source_address.y): //stay
                    reqOutPE = 1;
                else: //goes down
                    reqOutD = 1;
        else: //still need to go left
            reqOutL = 1;
*/

module routing_algo#(
    parameter DATA_WIDTH = 64,  // Width of the data
    parameter CURRENT_ADDRESS = 16'b0000_0000_0000_0000,
    parameter DIRECTION = 5'b00001
)(reqIn, dataIn, reqOutL, dataOutL, reqOutR, dataOutR, reqOutU, dataOutU, reqOutD, dataOutD, reqOutPE, dataOutPE);
    input reqIn;
    input [DATA_WIDTH-1:0] dataIn;
    output reg [4:0] reqOutL, reqOutR, reqOutU, reqOutD, reqOutPE;
    output reg [DATA_WIDTH-1:0] dataOutL, dataOutR, dataOutU, dataOutD, dataOutPE;

    parameter hop_x_msb = 55;
    parameter hop_x_lsb = 52;
    parameter hop_y_msb = 51;
    parameter hop_y_lsb = 48;

    parameter current_x_msb = 15;
    parameter current_x_lsb = 8;
    parameter current_y_msb = 7;
    parameter current_y_lsb = 0;

    parameter source_x_msb = 47;
    parameter source_x_lsb = 40;
    parameter source_y_msb = 39;
    parameter source_y_lsb = 32;

    parameter dir_x = 62;
    parameter dir_y = 61;

    //routing algo
    always@(*)begin
        //default:
        reqOutL=0;
        reqOutR=0;
        reqOutU=0;
        reqOutD=0;
        reqOutPE=0;

        dataOutU = 64'b0;
        dataOutD = 64'b0;
        dataOutL = 64'b0;
        dataOutR = 64'b0;
        dataOutPE = 64'b0;

        if (dataIn[dir_x] == 1) begin
            if (dataIn[source_x_msb:source_x_lsb] + dataIn[hop_x_msb:hop_x_lsb] == CURRENT_ADDRESS[current_x_msb:current_x_lsb]) begin
                if(dataIn[dir_y] == 1) begin
                    if(dataIn[source_y_msb:source_y_lsb] + dataIn[hop_y_msb:hop_y_lsb] == CURRENT_ADDRESS[current_y_msb:current_y_lsb])begin
                        reqOutPE= DIRECTION;
                        dataOutPE = dataIn;
                    end else begin
                        reqOutU = DIRECTION;
                        dataOutU = dataIn;
                    end
                end else begin
                    if(CURRENT_ADDRESS[current_y_msb:current_y_lsb] + dataIn[hop_y_msb:hop_y_lsb] == dataIn[source_y_msb:source_y_lsb])begin
                        reqOutPE= DIRECTION;
                        dataOutPE = dataIn;
                    end else begin
                        reqOutD = DIRECTION;
                        dataOutD = dataIn;
                    end
                end 
            end else begin
                reqOutR = DIRECTION;
                dataOutR = dataIn;
            end
        end else begin
            if (dataIn[source_x_msb:source_x_lsb] + dataIn[hop_x_msb:hop_x_lsb] == CURRENT_ADDRESS[current_x_msb:current_x_lsb]) begin
                if(dataIn[dir_y] == 1) begin
                    if(dataIn[source_y_msb:source_y_lsb] + dataIn[hop_y_msb:hop_y_lsb] == CURRENT_ADDRESS[current_y_msb:current_y_lsb])begin
                        reqOutPE= DIRECTION;
                        dataOutPE = dataIn;
                    end else begin
                        reqOutU = DIRECTION;
                        dataOutU = dataIn;
                    end
                end else begin
                    if(CURRENT_ADDRESS[current_y_msb:current_y_lsb] + dataIn[hop_y_msb:hop_y_lsb] == dataIn[source_y_msb:source_y_lsb])begin
                        reqOutPE= DIRECTION;
                        dataOutPE = dataIn;
                    end else begin
                        reqOutD = DIRECTION;
                        dataOutD = dataIn;
                    end
                end 
            end else begin
                reqOutL = DIRECTION;
                dataOutL = dataIn;
            end
        end
    end
endmodule