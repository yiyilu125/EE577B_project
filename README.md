# EE577b Project - Mesh

## ROUTER

### Direction One-hot Coding
|               |**N: 00100**   |               |
| :------------ | :------------ | :------------ |
|**W: 10000**   |               |**E: 01000**   |
|**PE: 00001**  |**S: 00010**   |               |

### Input Interface
```verilog
module input_interface #(
    parameter DATA_WIDTH = 64,  // Width of the data
    parameter CURRENT_ADDRESS = 16'h0000; //current address in the mesh
    parameter DIRECTION = 5'b00001; //the direction of the intput: L:10000, R:01000, U:00100, D:00010, PE:00001
    parameter BUFFER_DEPTH = 1;
)(
    input si,
    input ri,
    input clk, rst,
    input sig_buffer_clear,
    input [63:0] datai,
    output [4:0] reqL, reqR, reqU, reqD, reqPE,
    output [63:0] dataoL, dataoR, dataoU, dataoD, dataoPE
);
```

### Aribiter
```verilog
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
```

### Output Control
```verilog
module opctrl (
    input clk,
    input reset,                        
    input polarity,              
    input [4:0] grant,           // 5-bit one-hot signal from the arbiter
    input [63:0] data_in_pe,     // Data input from PE
    input [63:0] data_in_s,      // Data input from S
    input [63:0] data_in_n,      // Data input from N
    input [63:0] data_in_e,      // Data input from E
    input [63:0] data_in_w,      // Data input from W
    input receive_output,        // Indicates if the next level can receive data
    output reg [63:0] data_out,  // Selected data output
    output reg empty,            // Indicates when opctrl is empty and ready to receive a package
    output reg send_output,      // Indicates when data is valid and can be sent
    output reg clear_pe,         // Output clear signal for PE
    output reg clear_s,          // Output clear signal for S
    output reg clear_n,          // Output clear signal for N
    output reg clear_e,          // Output clear signal for E
    output reg clear_w           // Output clear signal for W
);
```


## Network Interface Component (NIC)
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
