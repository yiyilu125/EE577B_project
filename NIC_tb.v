module tb();

    // Declare inputs as regs and outputs as wires
    reg clk;
    reg reset;
    reg nicEn;
    reg nicWrEN;
    reg net_si;
    reg net_ro;
	reg net_polarity;
    reg [1:0] addr;
    reg [63:0] net_di;  // packet from router
    reg [63:0] d_in;    // packet from processor
	
	
	
	
	
    wire [63:0] d_out;   // packet to processor
    wire net_ri;         // input buffer ready signal
    wire net_so;         // output buffer has packet to send signal
    wire [63:0] net_do;  // packet to router

    // Instantiate the NIC module
    nic uut (
        .clk(clk),
        .reset(reset),
        .nicEn(nicEn),
        .nicWrEN(nicWrEN),
		.net_polarity(net_polarity),
        .net_si(net_si),
        .net_ro(net_ro),
        .addr(addr),
        .net_di(net_di),
        .d_in(d_in),
        .d_out(d_out),
        .net_ri(net_ri),
        .net_so(net_so),
        .net_do(net_do)
    );

    // Clock generation
    always #5 clk = ~clk;
	always @(posedge clk) 
	if (reset) 
	 begin
          net_polarity <= 1'b0; 
	 end
	else	
     begin
            net_polarity <= ~net_polarity;
     end
	

	
	
	
	
	
	
	
    initial begin
        // Initialize signals
		net_polarity=0;
        clk = 0;
        reset = 1;
        nicEn = 0;
        nicWrEN = 0;
        net_si = 0;
        net_ro = 0;
        addr = 2'b00;
        net_di = 64'h0;
        d_in = 64'h0;
		

        // Apply reset
        #10 reset = 0;
//uncomment this part to check Router to PE operation of NIC		
	//Router ----> PE //mnually simulate PE signal and Router signal
// Scenario 1.0:  Scenario 1.0: Attempting to read from empty input buffer before input buffer has DATA      ---------------------------------------------------------------------------------------------------	
		//net_polarity=1; 
		
		
		nicEn = 1;
        nicWrEN = 0;   //   PE Read operation
		addr = 2'b01;  //   PE read input channel buffer status
        #10;     	
				
		nicEn = 1;	   
        nicWrEN = 0;   // PE Read operation
		addr = 2'b00;  // PE Read of input channel buffer when there is nothing in input channel buffer, so NIC will output ERROR.
        #10; 


		nicEn = 0;	   
        nicWrEN = 0;   
        #10; 
			
		
//Scenario 1.1:   Scenario 1.1: Receiving packet from network to processor    ---------------------------------------------------------------------------------------------------
		
        net_si = 1;  // Router indicates a valid packet
        net_di = 64'h0EDCBA9876543210;  // Packet arrived from Router
        #10;
        net_si = 0;  // Assumming that NIC received Packet
		
		/*#10
		net_si = 1;  // uncommnet this to try that when there is a packet is already in input buffer and we still try to inject packet
        net_di = 64'hFFFFBA9876543210; 
        #10;*/
		
		
		#10
       	nicEn = 1;
        nicWrEN = 0;   //   PE Read operation
		addr = 2'b01;  //   PE read input channel buffer status
        #10;     
	    
		#10
		nicEn = 1;
        nicWrEN = 0;   //   PE Read operation
		addr = 2'b00;  //   PE read input channel buffer DATA
        #10;     	
       
	
				
// Scenario 1.2:  read input buffer status ---------------------------------------------------------------------------------------------------	

		nicEn = 1;
        nicWrEN = 0;   //   PE Read operation
		addr = 2'b01;  //   PE read input channel buffer status
        #10;     





	

/*
	//PE----->Router
//Scenario 2: Scenario 2.0: Sending packet from processor to network" ---------------------------------------------------------------------------------------------------   

		nicEn = 1;
        nicWrEN = 0;   //   PE Read operation
		addr = 2'b11;  //   PE read input channel buffer status
        #10;     
		
     
        nicEn = 1;
        nicWrEN = 1;  // Write enable
		d_in = 64'h0BCD1234567890FF;  // Processor sends packet and it is even
        addr = 2'b10;  // Address for output channel buffer
		
		#10
		
		nicEn = 0;
        nicWrEN = 0;  // Write enable
		
		
		
		
        // Wait for the clock edge to write to the buffer
        #10;
        net_ro = 1;// Wait for router to be ready to receive the packet 
		#10
		//net_polarity=0; // wait for correct polarity bit
		#10;
		net_ro=0; // router is no space for new packet
		
		
		
		
//Scenario 2.1:"Scenario 2.1:try to write full buffer" ---------------------------------------------------------------------------------------------------		
		
		// ask again if the buffer is empty.
		nicEn = 1;
        nicWrEN = 0;   //   PE Read operation
		addr = 2'b11;  //   PE read input channel buffer status
        #10;     

        d_in = 64'hDEADBEEF12345678;  // Processor tries to send another packet
        nicEn = 1;
        nicWrEN = 1;
        addr = 2'b10;  // Address for output channel buffer
        #10;
			
		nicEn = 0;
        nicWrEN = 0;  
		
		#10
		
	    nicEn = 1;
        nicWrEN = 0;   //   PE Read operation
		addr = 2'b11;  //   PE read input channel buffer status
        #10;     

        d_in = 64'h0AAA12345678;  // Processor tries to send another packet
        nicEn = 1;
        nicWrEN = 1;
        addr = 2'b10;  // Address for output channel buffer
        #10;
		
		
		
//Scenario 2.3: router have a space!!	---------------------------------------------------------------------------------------------------		
		net_ro = 1;// Wait for router to be ready to receive the packet 
		#50
		net_ro=0;
		nicEn = 0;
        nicWrEN = 0;  
//Scenario 2.4: router have space again	---------------------------------------------------------------------------------------------------				
		*/
		
		$finish;
	end
endmodule



