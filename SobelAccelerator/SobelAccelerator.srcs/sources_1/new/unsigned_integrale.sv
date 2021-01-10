`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/09/2021 08:12:42 AM
// Design Name: 
// Module Name: unsigned_integrale
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module unsigned_integrale #(parameter row = 10, parameter col = 10)
(
    input [7:0] target,
    input [31:0] d_address_write,
    input [7:0] target_1_0,
    input [7:0] target_0_1,
    input [7:0] target_1_1,
    output [7:0] out
    );
    
    wire [7:0] lat  = (d_address_write/col == 0)? 0 : target_1_0;
    wire [7:0] hori = (d_address_write%(col) == 0)? 0 : target_0_1;
    wire [7:0] inc  = (d_address_write/col == 0 || d_address_write%(col) == 0)? 0 : target_1_1;
    wire [9:0] passOn = ((lat + hori - inc + target) >>> 2);
    
    assign out = passOn;
    
    
    
    
endmodule
