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


    wire signed [7:0] abs_x;
    wire signed [7:0] abs_y;
    wire signed [7:0] out2;
    wire signed [7:0] xBy;
    wire signed [7:0] yBx;
    wire signed [7:0] RES;

    assign out = (x == 0 && y ==0)? 0: (x == 0 && y>=0)? 64: (x == 0 && y<0)? -64: out2;
    
    assign abs_x = (x >= 0)? x : -x;
    assign abs_y = (y >= 0)? y : -y; 
    assign RES = y/x;
    assign out2 = (abs_x < abs_y)? xBy: yBx;
    assign xBy = (x >= 0)? ((128*RES) / (0.28086*(RES)*(RES))): (y >= 0)? (((128*(RES)) / (0.28086*(RES)*(RES))) + 127): (((128*(RES)) / (0.28086*(RES)*(RES))) - 127);
    assign yBx = (y >= 0)? (64 - ((128*(x/y)) / (0.28086*(x/y)*(x/y)))): (- 64 - ((128*(x/y)) / (0.28086*(x/y)*(x/y))));
    
    
    
endmodule
