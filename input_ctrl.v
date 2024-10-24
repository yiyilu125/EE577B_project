module input_ctrl #(
    parameter DATA_WIDTH = 64,  // Width of the data
    parameter BUFFER_DATA_WIDTH = 64,
    parameter BUFFER_DEPTH = 1
)(
    input sendI, //a signal indicates the data is sent from other node, need to catch it at this clock edge
    input [DATA_WIDTH-1:0] dataI, 
    input clk, 
    input rst, 
    // input polarity, 
    input sig_channel_clean, //a router internal input signal tells if the target output buffer can be access
    output reg receiveI,    //a signal indicates has a free channel and ready to receive data
    output [DATA_WIDTH-1:0] inner_dataO, 
    output sig_req_channel //a router internal output signal send to the output channel to see if there is a available channel                
);
    //state
    parameter IDLE = 3'b001,
              ODD_POLARITY = 3'b010,
              EVEN_POLARITY = 3'b100;

    //virtual channel buffer
    //virtual buffer wire
    wire even_buffer_full, even_buffer_empty, even_buffer_wr_en, even_buffer_rd_en;
    wire odd_buffer_full, odd_buffer_empty, odd_buffer_wr_en, odd_buffer_rd_en;
    wire [BUFFER_DATA_WIDTH-1:0] even_buffer_data, odd_buffer_data;

    buffer #(
        .DATA_WIDTH(BUFFER_DATA_WIDTH),
        .DEPTH(BUFFER_DEPTH)
    ) even_buffer (
        .clk(clk),
        .rst(rst),
        .wr_en(even_buffer_wr_en),
        .rd_en(even_buffer_rd_en),
        .data_in(dataI),
        .data_out(even_buffer_data), //muxed with polarity  
        .full(even_buffer_full),
        .empty(even_buffer_empty)
    );

    buffer #(
        .DATA_WIDTH(BUFFER_DATA_WIDTH),
        .DEPTH(BUFFER_DEPTH)
    ) odd_buffer (
        .clk(clk),
        .rst(rst),
        .wr_en(odd_buffer_wr_en),
        .rd_en(odd_buffer_rd_en),
        .data_in(dataI),
        .data_out(odd_buffer_data), //muxed with polarity  
        .full(odd_buffer_full),
        .empty(odd_buffer_empty)
    );

    //state
    reg [2:0] cur_stat, next_state;

    //state memory
    always@(posedge clk)begin
        if(rst)begin
            cur_stat <= IDLE;
        end else begin  
            cur_stat <= next_state;
        end
    end

    //next state logic
    always @(posedge clk) begin
        case (cur_stat)
            IDLE: next_state <= ODD_POLARITY; 
            ODD_POLARITY: next_state <= EVEN_POLARITY;
            EVEN_POLARITY: next_state <= ODD_POLARITY;
            default: next_state <= IDLE; // Adding a default case
        endcase
    end


    //output logic
    always@(*)begin
        receiveI = 0;
        case (cur_stat)
            ODD_POLARITY: begin
                receiveI = (even_buffer_empty == 1) ? 1 : 0;
            end
            EVEN_POLARITY: begin
                receiveI = (odd_buffer_empty == 1) ? 1 : 0;
            end
        endcase
    end

    //output continuous logic
    assign even_buffer_wr_en = (cur_stat == ODD_POLARITY) ? sendI : 0;
    assign odd_buffer_wr_en = (cur_stat == EVEN_POLARITY) ? sendI : 0;

    assign even_buffer_rd_en = (cur_stat == EVEN_POLARITY) ? sig_channel_clean : 0;
    assign odd_buffer_rd_en  = (cur_stat == ODD_POLARITY) ? sig_channel_clean : 0;

    assign sig_req_channel = (cur_stat == ODD_POLARITY) ? odd_buffer_full : even_buffer_full;
    assign inner_dataO = (cur_stat == ODD_POLARITY) ? odd_buffer_data : even_buffer_data;

endmodule