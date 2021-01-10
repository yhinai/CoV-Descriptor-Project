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
    output [7:0] out
    );
    
    wire signed [7:0] preOut1, preOut2;
    wire signed [7:0] x_abs, y_abs, numerator, denominator;
    wire [40:0] AtanSeries;
    wire Q1, Q2, Q3, Q4;
    
    assign Q1 = (x >= 0 && y >= 0);
    assign Q4 = (x >= 0 && y < 0);
    assign Q3 = (x < 0 && y < 0);
    assign Q2 = (x < 0 && y >= 0);
        
    assign x_abs = (x < 0)? -x: x;   
    assign y_abs = (y < 0)? -y: y;  
     
    assign NumDen = (x_abs > y_abs);
    
    assign numerator   = (NumDen)? y_abs : x_abs;
    assign denominator = (NumDen)? x_abs : y_abs ;

    assign AtanSeries = (x_abs == y_abs)? 32 :
    (((2147483647*numerator/denominator))
    -((21474836*numerator/denominator)*(10*numerator/denominator)*(10*numerator/denominator))/3
    +((214748*numerator/denominator)*(10*numerator/denominator)*(10 *numerator/denominator)*(10*numerator/denominator)*(10*numerator/denominator))/5
    -((2147 *numerator/denominator)*(10*numerator/denominator)*(10 *numerator/denominator)*(10*numerator/denominator)*(10*numerator/denominator)*(10*numerator/denominator)*(10*numerator/denominator))/7
    +((21 *numerator/denominator)*(10*numerator/denominator)*(10 *numerator/denominator)*(10*numerator/denominator)*(10*numerator/denominator)*(10*numerator/denominator)*(10*numerator/denominator)*(10*numerator/denominator)*(10*numerator/denominator))/9
    -((21 *numerator/denominator)*(10*numerator/denominator)*(10 *numerator/denominator)*(10*numerator/denominator)*(10*numerator/denominator)*(10*numerator/denominator)*(10*numerator/denominator)*(10*numerator/denominator)*(10*numerator/denominator))/11
     ) / 52707178;
        
    assign preOut1 = (NumDen)? (AtanSeries) : 63-(AtanSeries);
    assign preOut2 = (Q1)? preOut1 : (Q2)? 127-preOut1 : (Q3)? preOut1-128 : -preOut1;
    assign out = (x == 0 && y == 0)? 0 : (y == 0 && x > 0)? 0 : (y == 0 && x < 0)? 127 : (y > 0 && x == 0)? 64 : (y < 0 && x == 0)? -64 : preOut2;

    
    
endmodule
