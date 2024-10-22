# EE577b Project - Mesh

## ROUTER

### Input Control
```verilog

```

### Aribiter
```verilog
module round_robin_arbiter (
    input wire clk,
    input wire rst_n,              
    input wire [3:0] req0,         
    input wire [3:0] req1,
    input wire [3:0] req2,
    input wire [3:0] req3,
    output reg [3:0] grant        
);
```

### Output Control
```verilog
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
```

## NIC
```verilog
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
```
