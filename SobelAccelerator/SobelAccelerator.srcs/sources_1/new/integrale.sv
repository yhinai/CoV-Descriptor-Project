`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/04/2021 12:44:21 PM
// Design Name: 
// Module Name: integrale
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


module integrale #(parameter row = 10, parameter col = 10)
(
    input signed [7:0] target,
    input [31:0] d_address_write,
    input signed [31:0] target_1_0,
    input signed [31:0] target_0_1,
    input signed [31:0] target_1_1,
    output signed [7:0] out
    );
    
    wire [31:0] lat  = (d_address_write/col == 0)? 0 : target_1_0;
    wire [31:0] hori = (d_address_write%col == 0)? 0 : target_0_1;
    wire [31:0] inc  = (d_address_write/col == 0 || d_address_write%col == 0)? 0 : target_1_1;
    
    assign out = (lat + hori - inc + target) >> 2;
    
    
    
    
endmodule
