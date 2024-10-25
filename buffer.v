module buffer #(
    parameter DATA_WIDTH = 64,  // Width of the data
    parameter DEPTH = 1         // Depth of the buffer
) (clk, rst, rd_en, wr_en, data_in, data_out, full, empty);
    input clk, rst, rd_en, wr_en;
    input [DATA_WIDTH-1:0] data_in;
    output [DATA_WIDTH-1:0] data_out;
    output reg full; // full flag
    output reg empty; // empty flag


    // Internal memory for buffer
    reg [DATA_WIDTH-1:0] buffer_mem [0:DEPTH-1];
    
    // Internal register for keeping track of data status
    reg buffer_full;
    reg buffer_empty;

    always @(posedge clk) begin
        if (rst) begin
            // Reset the buffer state
            buffer_full <= 0;
            buffer_empty <= 1;
            //data_out <= {DATA_WIDTH{1'b0}};
        end else begin
            if (wr_en && !buffer_full) begin
                // Write data to the buffer if it's not full
                buffer_mem[0] <= data_in;
                buffer_full <= 1;
                buffer_empty <= 0;
            end

            if (rd_en && !buffer_empty) begin
                // Read data from the buffer if it's not empty
                //data_out <= buffer_mem[0];
                buffer_full <= 0;
                buffer_empty <= 1;
            end
        end
    end

    // Set full and empty flags based on buffer state
    always @(*) begin
        full = buffer_full;
        empty = buffer_empty;
    end

    assign data_out = buffer_mem[0];
endmodule
