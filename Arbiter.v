module round_robin_arbiter (
    input wire clk,
    input wire rst_n,              
    input wire [3:0] req0,         
    input wire [3:0] req1,
    input wire [3:0] req2,
    input wire [3:0] req3,
    output reg [3:0] grant        
);

    reg [1:0] current_grant;      

    always @(posedge clk ) begin
        if (rst_n) begin
            grant <= 4'b0000;
            current_grant <= 2'b00;
        end else 
		begin
            case (current_grant)
                2'b00: begin
                    if (req0 == 4'b0001) 
					begin
                        grant <= req0;
                        current_grant <= 2'b01;  
                    end 
					else 
					begin
                        current_grant <= 2'b01; 
                    end
                end
                2'b01: 
				begin
                    if (req1 == 4'b0010) 
					begin
                        grant <= req1;
                        current_grant <= 2'b10;
                    end 
					else 
					begin
                        current_grant <= 2'b10;
                    end
                end
                2'b10: 
				begin
                    if (req2 == 4'b0100) 
					begin
                        grant <= req2;
                        current_grant <= 2'b11;
                    end 
					else 
					begin
                        current_grant <= 2'b11;
                    end
                end
                2'b11: 
				begin
                    if (req3 == 4'b1000) 
					begin
                        grant <= req3;
                        current_grant <= 2'b00;
                    end 
					else 
					begin
                        current_grant <= 2'b00;
                    end
                end
            endcase
        end
    end
endmodule

