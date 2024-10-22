module round_robin_arbiter (
    input wire rst_n,              
    input wire [3:0] req0,         
    input wire [3:0] req1,
    input wire [3:0] req2,
    input wire [3:0] req3,
    output reg [3:0] grant        
);

  
	parameter state_req0=4'b0001;
	parameter state_req1=4'b0010;
	parameter state_req2=4'b0100;
	parameter state_req3=4'b1000;
	
	
	reg [3:0]state;	
	
	
	
    always @(*) begin
        if (rst_n) begin
            grant = 4'b0000;
            state = state_req0;
        end 
		else 
		begin
            case (state)
                state_req0: 
				begin
                   if(req0==4'b0001)
				   begin
						grant=req0;
						state=state_req1;
				   end
				   else if(req0!=4'b0001&&req1==4'b0010)
				   begin
						grant=req1;
						state=state_req2;
				   end
				   else if (req1!=4'b0010&&req2==4'b0100)
				   begin
						grant=req2;
						state=state_req3;
				   end
				   else if (req2!=4'b0100&&req3==4'b1000)
				   begin
						grant=req3;
						state=state_req0;
				   end	
                end

				
                state_req1: 
				begin				 
				 if(req1==4'b0010)
				   begin
						grant=req1;
						state=state_req2;
				   end
				   else if(req1!=4'b0010&&req2==4'b0100)
				   begin
						grant=req2;
						state=state_req3;
				   end
				   else if (req2!=4'b0100&&req3==4'b1000)
				   begin
						grant=req3;
						state=state_req0;
				   end
				   else if (req3!=4'b1000&&req0==4'b0001)
				   begin
						grant=req0;
						state=state_req1;
				   end	 
                end
				

                state_req2: 
				begin
				 if(req2==4'b0100)
				   begin
						grant=req2;
						state=state_req3;
				   end
				   else if(req2!=4'b0100&&req3==4'b1000)
				   begin
						grant=req3;
						state=state_req0;
				   end
				   else if (req3!=4'b1000&&req0==4'b0001)
				   begin
						grant=req0;
						state=state_req1;
				   end
				   else if (req0!=4'b0001&&req1==4'b0010)
				   begin
						grant=req1;
						state=state_req2;
				   end	 
                end
				
				
				
                state_req3: 
				begin
				 if(req3==4'b1000)
				   begin
						grant=req3;
						state=state_req0;
				   end
				   else if(req3!=4'b0100&&req0==4'b0001)
				   begin
						grant=req0;
						state=state_req1;
				   end
				   else if (req0!=4'b0001&&req1==4'b0010)
				   begin
						grant=req1;
						state=state_req2;
				   end
				   else if (req1!=4'b0010&&req2==4'b0100)
				   begin
						grant=req2;
						state=state_req3;
				   end	 
				end
				
				
            endcase
        end
    end
endmodule

