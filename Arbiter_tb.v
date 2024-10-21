`timescale 1ns / 1ps

module tb_round_robin_arbiter;

   
    reg clk;
    reg rst_n;
    reg [3:0] req0;
    reg [3:0] req1;
    reg [3:0] req2;
    reg [3:0] req3;

   
    wire [3:0] grant;

  
    round_robin_arbiter uut (
        .clk(clk),
        .rst_n(rst_n),
        .req0(req0),
        .req1(req1),
        .req2(req2),
        .req3(req3),
        .grant(grant)
    );

   
    always #5 clk = ~clk; 

    initial begin
      
        clk = 0;
        rst_n = 1; 

       
        #10
		rst_n = 0;
       
         req0 = 4'b0001; 
         req1 = 4'b0010; 
         req2 = 4'b0100;
         req3 = 4'b1000; 
		#50
        
         req0 = 4'b0000;  
         req1 = 4'b0010; 
         req2 = 4'b0000;  
         req3 = 4'b1000; 
		 
		 #50
		  req0 = 4'b0001;  
         req1 = 4'b0010; 
         req2 = 4'b0000;  
         req3 = 4'b1000; 
		 

        // 
        #100;
    end


endmodule

