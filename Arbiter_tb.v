`timescale 1ns / 1ps

module tb_round_robin_arbiter;

    // Input signals
	 reg clk;
    reg rst;
    reg [4:0] req0;
    reg [4:0] req1;
    reg [4:0] req2;
    reg [4:0] req3;
	reg empty;

    // Output signal
    wire [4:0] grant;

    // Instantiate the Device Under Test (DUT)
    round_robin_arbiter uut (
		.clk(clk),
        .rst(rst),
		.empty(empty),
        .req0(req0),
        .req1(req1),
        .req2(req2),
        .req3(req3),
        .grant(grant)
    );
	 always #5 clk = ~clk; 
    // Initial signal setup and test sequences
    initial begin
        // Initialize all signals
		clk=0;
        rst = 1;    // Reset signal is active low
        req0 = 5'b00000;
        req1 = 5'b00000;
        req2 = 5'b00000;
        req3 = 5'b00000;
        #10 
		rst = 0;    

      
        #10 
		empty=1;
		req0 = 5'b00001;    // req0 sends a request
        req1 = 5'b00010;    // req1 sends a request
        req2 = 5'b00100;    // req2 sends a request
		req3 = 5'b01000; 
		#10;
		req0 = 5'b00000;
        req1 = 5'b00000;
        req2 = 5'b00000;
        req3 = 5'b00000;
		
		#10
		rst = 1;   
		#10
		rst = 0; 
		
	
		
		#10
		req1 = 5'b00010;   
        req2 = 5'b00100;    		
	
		#10
		
		//req2 =5'b00100;  
		req3=5'b01000;
		
		
		#10
		req0 = 5'b00001;    // req0 sends a request
		#10;
		
		
		empty=0;
		
		
		
   
    end

  

endmodule
