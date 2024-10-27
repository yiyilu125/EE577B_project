
module nic(
    input  clk,        
    input  reset,  
	
    input  nicEn,         // enable
    input  nicWrEN,       // write enable
	input  net_polarity,  // count of number of clocks
  
	input  net_si,        // channel data is a valid packet
    input  net_ro,        // indicates the router has space for a new packet. 
	input  [1:0] addr,    // address to indicate register in NIC
    input  [63:0] net_di, // packet from router
	input  [63:0] d_in,   // packet from PE
	
	
	
	
    output reg [63:0] d_out,   // packet to PE
	output reg net_ri,         // when the network input channel buffer is empty. 
    output reg net_so,         // when the channel buffer has packet to send 
    output reg [63:0] net_do  // packet to router
  
);

  
    reg [63:0] input_channel_buffer;  // input_channel_buffer
    reg [63:0] output_channel_buffer; // output_channel_buffer
	
	reg input_status;
    reg output_status;

  
    always @(posedge clk) 
	begin
        if (reset) 
		begin
            input_status <= 1'b0;     
            output_status <= 1'b0; 
			input_channel_buffer<=64'h0;
			output_channel_buffer<=64'h0;
            d_out <= 64'h0;          
            net_so <= 1'b0; 
			net_ri<=1'b1;
			net_do<=1'b0;	
        end 
		
		else 
		begin
            // 
            if (net_si && !input_status  ) // router send data to NIC
			begin
                input_channel_buffer <= net_di;   // put packet on input channel
                input_status <= 1'b1;             // input buffer is full
				net_ri <= 1'b0;                   // tell Router input buffer is full
            end
			
			
			
			if (nicEn && !nicWrEN && addr == 2'b00 && input_status ) // PE read input data
			begin
                d_out <= input_channel_buffer;  // Provide the buffer data to the processor
                input_status <= 1'b0;           // Clear the input buffer
                net_ri <= 1'b1;                 // tell input buffer is empty, ready for new data
            end
           
		   
		   if (nicEn && !nicWrEN && addr == 2'b00 && !input_status ) // PE read input data
			begin
				//$display("ERROR! you are tying to read empty input buffer");  //debug only not for syn
				d_out=0;
            end
		   
		   
            if (nicEn && nicWrEN && addr == 2'b10 && !output_status)   //  PE put processed result to output buffer
			begin
                output_channel_buffer <= d_in;                         // put packet on output channel
                output_status <= 1'b1;                                 // set buffer is full
			
            end
			
			if (nicEn && nicWrEN && addr == 2'b10 && output_status)   //PE put processed result to output buffer
			begin
               // $display("ERROR! you are tring to write full output buffer");  //debug only not for syn
            end
			
			 if (output_status    &&    net_ro   &&   net_polarity==output_channel_buffer[63])  // NIC send packet back to router
			begin
                output_status <= 1'b0;            
            end 
			
			
			
         
			
			
			if (nicEn    &&    !nicWrEN   &&   addr==2'b01)  // PE read buffer status
			begin                                            // When nicEn is high and nicWrEN is low, it's a read operation           
                d_out <= {63'b0, input_status};              // Read input channel status, place input_status in d_out[63]
			end
			
			
			
			if (nicEn    &&    !nicWrEN   &&   addr==2'b11)  // PE read buffer status
			begin                                            // When nicEn is high and nicWrEN is low, it's a read operation           
                d_out <= {63'b0, output_status};             // Read output channel status, place input_status in d_out[63]
			end

         
        end
		
    end
	
	
	
	
	always@(*)
	begin
	 if (output_status    &&    net_ro   &&   net_polarity==output_channel_buffer[63])  // NIC send packet back to router
		begin
            net_do = output_channel_buffer;  
            net_so = 1'b1;                       
        end 
	if(!net_ro)
		begin
			net_do=0;
			net_so=0;
		end
	end

endmodule
