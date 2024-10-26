module round_robin_arbiter (
    input wire clk,
    input wire rst,              
    input wire [4:0] req0,         
    input wire [4:0] req1,
    input wire [4:0] req2,
    input wire [4:0] req3,
	input wire empty,
    output reg [4:0] grant        
);

    parameter state_req0 = 4'b0001;
    parameter state_req1 = 4'b0010;
    parameter state_req2 = 4'b0100;
    parameter state_req3 = 4'b1000;

    reg [3:0] state;

   
    always @(*)
	begin
        case (state)
            state_req0: 
			begin
                if (req0 != 0&&empty==1)
                    grant = req0;
                else if (req0 == 0 && req1 != 0 && empty==1)
                    grant = req1;
                else if (req1 == 0 && req2 != 0&&empty==1)
                    grant = req2;
                else if (req2 == 0 && req3 != 0&&empty==1)
                    grant = req3;
               
            end
            state_req1: 
			begin
                if (req1 != 0&&empty==1)
                    grant = req1;
                else if (req1 == 0 && req2 != 0&&empty==1)
                    grant = req2;
                else if (req2 == 0 && req3 != 0&&empty==1)
                    grant = req3;
                else if (req3 == 0 && req0 != 0&&empty==1)
                    grant = req0;
               
            end
            state_req2: 
			begin
                if (req2 != 0&&empty==1)
                    grant = req2;
                else if (req2 == 0 && req3 != 0&&empty==1)
                    grant = req3;
                else if (req3 == 0 && req0 != 0&&empty==1)
                    grant = req0;
                else if (req0 == 0 && req1 != 0&&empty==1)
                    grant = req1;
                
            end
            state_req3: 
			begin
                if (req3 != 0&&empty==1)
                    grant = req3;
                else if (req3 == 0 && req0 != 0&&empty==1)
                    grant = req0;
                else if (req0 == 0 && req1 != 0&&empty==1)
                    grant = req1;
                else if (req1 == 0 && req2 != 0&&empty==1)
                    grant = req2;
               
            end
        endcase
    end


    always @(posedge clk) 
	begin
        if (rst) 
		begin
            grant <= 0;
            state <= state_req0;
        end 
		else 
		begin
            case (state)
                state_req0: 
                    if (req0 != 0&&empty==1)
						begin 
							$display("test");
							state <= state_req1;
						end
                    else if (req0 == 0 && req1 != 0&&empty==1)
                        state <= state_req2;
                    else if (req1 == 0 && req2 != 0&&empty==1)
                        state <= state_req3;
                    else if (req2 == 0 && req3 != 0&&empty==1)
                        state <= state_req0;
                state_req1:
                    if (req1 != 0&&empty==1)
                        state <= state_req2;
                    else if (req1 == 0 && req2 != 0&&empty==1)
                        state <= state_req3;
                    else if (req2 == 0 && req3 != 0&&empty==1)
                        state <= state_req0;
                    else if (req3 == 0 && req0 != 0&&empty==1)
                        state <= state_req1;
                state_req2:
                    if (req2 != 0&&empty==1)
                        state <= state_req3;
                    else if (req2 == 0 && req3 != 0&&empty==1)
                        state <= state_req0;
                    else if (req3 == 0 && req0 != 0&&empty==1)
                        state <= state_req1;
                    else if (req0 == 0 && req1 != 0&&empty==1)
                        state <= state_req2;
                state_req3:
                    if (req3 != 0&&empty==1)
                        state <= state_req0;
                    else if (req3 == 0 && req0 != 0&&empty==1)
                        state <= state_req1;
                    else if (req0 == 0 && req1 != 0&&empty==1)
                        state <= state_req2;
                    else if (req1 == 0 && req2 != 0&&empty==1)
                        state <= state_req3;
            endcase
        end
    end
endmodule
