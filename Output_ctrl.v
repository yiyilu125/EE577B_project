module signal_selector (
    input wire reg_empty,           // Indicates if the module has received any packets
    input wire [4:0] rec_clear,     // 5-bit one-hot signal for selecting one output
    output reg clear_pe,            // Output corresponding to rec_clear[0]
    output reg clear_s,             // Output corresponding to rec_clear[1]
    output reg clear_n,             // Output corresponding to rec_clear[2]
    output reg clear_e,             // Output corresponding to rec_clear[3]
    output reg clear_w              // Output corresponding to rec_clear[4]
);

always @(*) begin
    if (reg_empty) begin
        // If reg_empty is 1, no packet is received, all outputs remain 0
        clear_pe = 0;
        clear_s = 0;
        clear_n = 0;
        clear_e = 0;
        clear_w = 0;
    end else begin
        // If reg_empty is 0, select the output based on rec_clear
        clear_pe = rec_clear[0];
        clear_s = rec_clear[1];
        clear_n = rec_clear[2];
        clear_e = rec_clear[3];
        clear_w = rec_clear[4];
    end
end

endmodule




module opctrl (
    input clk,
    input reset,                        
    input polarity,                     // Polarity bit (0 for even, 1 for odd clock cycles)
    input [4:0] grant,                  // 5-bit one-hot signal from the arbiter
    input [63:0] data_in_pe,            // Data input from PE
    input [63:0] data_in_s,             // Data input from S
    input [63:0] data_in_n,             // Data input from N
    input [63:0] data_in_e,             // Data input from E
    input [63:0] data_in_w,             // Data input from W
    input receive_output,               // Indicates if the next level can receive data
    output reg [63:0] data_out,         // Selected data output
    output reg empty,                   // Indicates when opctrl is empty and ready to receive a package
    output reg send_output,             // Indicates when data is valid and can be sent
    output reg clear_pe,                // Output clear signal for PE
    output reg clear_s,                 // Output clear signal for S
    output reg clear_n,                 // Output clear signal for N
    output reg clear_e,                 // Output clear signal for E
    output reg clear_w                  // Output clear signal for W
);

output reg [4:0] clear;             // Clear signal indicating data was received

// Internal registers for even and odd data storage
reg [63:0] mem_even;  // Storage for data when polarity = 0 (even clock cycles)
reg [63:0] mem_odd;   // Storage for data when polarity = 1 (odd clock cycles)

signal_selector uut (
    .reg_empty(empty),           // Connect empty signal to reg_empty
    .rec_clear(clear),           // Connect grant to rec_clear
    .clear_pe(clear_pe),         // Connect outputs to clear signals
    .clear_s(clear_s),
    .clear_n(clear_n),
    .clear_e(clear_e),
    .clear_w(clear_w)
);

// State signal updates
always @(posedge clk) begin
    if (reset) begin
        empty <= 1;             // On reset, opctrl is empty and can receive data
        data_out <= 0;
        clear <= 0;
        send_output <= 0;       // Initially, send_output is low
    end else if (receive_output) begin
        // Only process if the next stage can receive data
        if (grant != 5'b00000) begin
            // Select data input based on the grant signal
            case (grant)
                5'b00001: begin
                    if (polarity == 0) mem_even <= data_in_pe;  // Store in even register when polarity = 0
                    else mem_odd <= data_in_pe;                 // Store in odd register when polarity = 1
                end
                5'b00010: begin
                    if (polarity == 0) mem_even <= data_in_s;
                    else mem_odd <= data_in_s;
                end
                5'b00100: begin
                    if (polarity == 0) mem_even <= data_in_n;
                    else mem_odd <= data_in_n;
                end
                5'b01000: begin
                    if (polarity == 0) mem_even <= data_in_e;
                    else mem_odd <= data_in_e;
                end
                5'b10000: begin
                    if (polarity == 0) mem_even <= data_in_w;
                    else mem_odd <= data_in_w;
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
            send_output <= 0;      // No valid data to send
        end

        // Output the appropriate register content based on the polarity
        data_out <= (polarity == 0) ? mem_even : mem_odd; // Output data if there is space
    end else begin
        // If receive_output is 0, hold the current values and do not send a clear signal.
        send_output <= 0;          // No data is sent if the next stage is full.
        clear <= 0;                // Clear signals remain 0 when the stage is blocked.
    end
end

endmodule
