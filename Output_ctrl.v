module signal_selector (
    // input wire reg_empty,           // Indicates if the module has received any packets
    input wire [4:0] rec_clear,     // 5-bit one-hot signal for selecting one output
    output reg clear_pe,            // Output corresponding to rec_clear[0]
    output reg clear_s,             // Output corresponding to rec_clear[1]
    output reg clear_n,             // Output corresponding to rec_clear[2]
    output reg clear_e,             // Output corresponding to rec_clear[3]
    output reg clear_w              // Output corresponding to rec_clear[4]
);

always @(*) begin
    // if (reg_empty) begin
    //     // If reg_empty is 1, no packet is received, all outputs remain 0
    //     clear_pe = 0;
    //     clear_s = 0;
    //     clear_n = 0;
    //     clear_e = 0;
    //     clear_w = 0;
    // end else begin
        // If reg_empty is 0, select the output based on rec_clear
        clear_pe = rec_clear[0];
        clear_s = rec_clear[1];
        clear_n = rec_clear[2];
        clear_e = rec_clear[3];
        clear_w = rec_clear[4];
    // end
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
    output reg send_output,             // Indicates when data is valid and can be sent
    output reg empty,                   // Indicates when the current register is empty
    output reg clear_pe,                // Output clear signal for PE
    output reg clear_s,                 // Output clear signal for S
    output reg clear_n,                 // Output clear signal for N
    output reg clear_e,                 // Output clear signal for E
    output reg clear_w                  // Output clear signal for W
);

reg [63:0] mem_even;  // Storage for data when polarity = 0 (even clock cycles)
reg [63:0] mem_odd;   // Storage for data when polarity = 1 (odd clock cycles)
reg [4:0] clear;      // Indicates the direction from which the data is received
reg empty_even, empty_odd;

wire clear_pe_wire;  
wire clear_s_wire;
wire clear_n_wire;
wire clear_e_wire;
wire clear_w_wire;

always @(*) begin
    clear_pe = clear_pe_wire;
    clear_s = clear_s_wire;
    clear_n = clear_n_wire;
    clear_e = clear_e_wire;
    clear_w = clear_w_wire;
end

signal_selector uut (
    // .reg_empty(empty),           // Connect empty signal to reg_empty
    .rec_clear(clear),           // Connect grant to rec_clear
    .clear_pe(clear_pe_wire),    // Connect intermediate wires to clear signals
    .clear_s(clear_s_wire),
    .clear_n(clear_n_wire),
    .clear_e(clear_e_wire),
    .clear_w(clear_w_wire)
);

// State signal updates
always @(posedge clk) begin
    if (reset) begin
        empty <= 1;          // On reset, the module is empty and can receive data
        empty_even <= 1;
        empty_odd <= 1;
        data_out <= 0;
        mem_even <= 0;
        mem_odd <= 0;
        clear <= 0;
        send_output <= 0;
    end else begin
        // Update based on polarity
        if (polarity == 0) begin
            // Even clock cycle logic
            if (empty_even && grant != 5'b00000) begin
                case (grant)
                    5'b00001: mem_even <= data_in_pe;
                    5'b00010: mem_even <= data_in_s;
                    5'b00100: mem_even <= data_in_n;
                    5'b01000: mem_even <= data_in_e;
                    5'b10000: mem_even <= data_in_w;
                    default: begin
                        mem_even <= 0;
                        $display("ERROR: the grant signal is not one-hot!");
                    end
                endcase
                empty_even <= 0; // Set empty to low after receiving data
                clear <= grant; // Indicate which input to clear
            end else begin
                clear <= 0;
            end

            // Output logic for even memory
            if (receive_output) begin
                data_out <= mem_odd;
                send_output <= 1;
                mem_odd <= 0;
                empty_odd <= 1;
            end else begin
                send_output <= 0; // Blocked, so no output
            end
        end else begin
            // Odd clock cycle logic
            if (empty_odd && grant != 5'b00000) begin
                case (grant)
                    5'b00001: mem_odd <= data_in_pe;
                    5'b00010: mem_odd <= data_in_s;
                    5'b00100: mem_odd <= data_in_n;
                    5'b01000: mem_odd <= data_in_e;
                    5'b10000: mem_odd <= data_in_w;
                    default: begin
                        mem_odd <= 0;
                        $display("Arbiter output error: the grant signal is not one-hot!");
                    end
                endcase
                empty_odd <= 0; // Set empty to low after receiving data
                clear <= grant; // Indicate which input to clear
            end else begin
                clear <= 0;
            end

            // Output logic for odd memory
            if (receive_output) begin
                data_out <= mem_even;
                send_output <= 1;
                mem_even <= 0;
                empty_even <= 1;
            end else begin
                send_output <= 0; // Blocked, so no output
            end
        end
    end
end


// Update the empty signal based on the current polarity
always @(*) begin
    if (polarity == 0) begin
        empty = empty_even; // Check if even memory is empty
    end else begin
        empty = empty_odd; // Check if odd memory is empty
    end
end

endmodule
