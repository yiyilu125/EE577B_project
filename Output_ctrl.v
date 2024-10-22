module signal_selector (
    input wire reg_empty,           // Indicates if the module has received any packets
    input wire [3:0] rec_clear,     // 4-bit one-hot signal for selecting one output
    output reg clear0,              // Output corresponding to rec_clear[0]
    output reg clear1,              // Output corresponding to rec_clear[1]
    output reg clear2,              // Output corresponding to rec_clear[2]
    output reg clear3               // Output corresponding to rec_clear[3]
);

always @(*) begin
    if (reg_empty) begin
        // If reg_empty is 1, no packet is received, all outputs remain 0
        clear0 = 0;
        clear1 = 0;
        clear2 = 0;
        clear3 = 0;
    end else begin
        // If reg_empty is 0, select the output based on rec_clear
        clear0 = rec_clear[0];
        clear1 = rec_clear[1];
        clear2 = rec_clear[2];
        clear3 = rec_clear[3];
    end
end

endmodule




module opctrl (
    input clk,
    input reset,                        
    input polarity,                     // Polarity bit (0 for even, 1 for odd clock cycles)
    input [3:0] grant,                  // 4-bit one-hot signal from the arbiter
    input [63:0] data_in0,    
    input [63:0] data_in1,    
    input [63:0] data_in2,    
    input [63:0] data_in3,    
    input receive_output,               // Indicates if the next level can receive data
    output reg [63:0] data_out,         // Selected data output
    output reg [3:0] clear,             // Clear signal indicating data was received
    output reg empty,                   // Indicates when opctrl is empty and ready to receive a package
    output reg send_output              // Indicates when data is valid and can be sent
    output reg clear0,              
    output reg clear1,              
    output reg clear2,              
    output reg clear3               
);

// Internal registers for even and odd data storage
reg [63:0] mem_even;  // Storage for data when polarity = 0 (even clock cycles)
reg [63:0] mem_odd;   // Storage for data when polarity = 1 (odd clock cycles)

signal_selector uut (
    .reg_empty(empty),           // Connect empty signal to reg_empty
    .rec_clear(grant),          // Connect grant to rec_clear
    .clear0(clear0),            // Connect outputs to clear signals
    .clear1(clear1),
    .clear2(clear2),
    .clear3(clear3)
);

// State signal updates
always @(posedge clk) begin
    if (reset) begin
        empty <= 1;             // On reset, opctrl is empty and can receive data
        data_out <= 0;
        clear <= 0;
        send_output <= 0;       // Initially, send_output is low
    end else begin
        // Check if there is a send request based on grant signal
        if (grant != 4'b0000) begin
            // Select data input based on the grant signal
            case (grant)
                4'b0001: begin
                    if (polarity == 0) mem_even <= data_in0;  // Store in even register when polarity = 0
                    else mem_odd <= data_in0;                 // Store in odd register when polarity = 1
                end
                4'b0010: begin
                    if (polarity == 0) mem_even <= data_in1;
                    else mem_odd <= data_in1;
                end
                4'b0100: begin
                    if (polarity == 0) mem_even <= data_in2;
                    else mem_odd <= data_in2;
                end
                4'b1000: begin
                    if (polarity == 0) mem_even <= data_in3;
                    else mem_odd <= data_in3;
                end
                default: begin
                    mem_even <= 0;
                    mem_odd <= 0;
                    $display("Arbiter output error: the grant signal is not one-hot!");                
                end
            endcase

            empty <= 0;            // After receiving data, set empty to low
            clear <= grant;        // Send a clear signal to the data source based on the grant signal

            // Update send_output based on whether receive_output is high and data is valid
            send_output <= receive_output;  // Set send_output high if there is space to receive data
        end else begin
            empty <= 1;            // If no data is received, keep empty high
            clear <= 0;            // Clear the clear signal
            send_output <= 0;       // No valid data to send
        end

        // Output the appropriate register content based on the polarity and receive_output
        if (receive_output) begin
            data_out <= (polarity == 0) ? mem_even : mem_odd; // Output data if there is space
        end else begin
            data_out <= 0;       // Output 0 if there is no space to receive
        end
    end
end

endmodule
