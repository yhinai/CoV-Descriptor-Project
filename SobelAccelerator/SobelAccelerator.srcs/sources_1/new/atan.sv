`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2020 10:00:12 AM
// Design Name: 
// Module Name: atan
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


module atan(
    input signed [7:0] x,
    input signed [7:0] y,
    output signed [7:0] out
    );

    assign out = (x+y)/2;     
    
    
endmodule
