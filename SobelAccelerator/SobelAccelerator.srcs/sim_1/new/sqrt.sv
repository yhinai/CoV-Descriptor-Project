`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2020 05:31:18 PM
// Design Name: 
// Module Name: sqrt
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


module sqrt#(parameter DATA_IN_WIDTH = 8)
    (
    input   wire    signed  [ DATA_IN_WIDTH-1:  0 ] x1,
    input   wire    signed  [ DATA_IN_WIDTH-1:  0 ] x2,
    output  wire            [ DATA_IN_WIDTH-1:  0 ] y
    );

localparam DATA_WIDTH_SQUARING = (2*DATA_IN_WIDTH) - 1;

wire    [ DATA_WIDTH_SQUARING-1 :  0 ] x1_2 = x1*x1;
wire    [ DATA_WIDTH_SQUARING-1 :  0 ] x2_2 = x2*x2;

wire    [ DATA_WIDTH_SQUARING :  0 ] x = x1_2 + x2_2;

assign y[DATA_IN_WIDTH-1] = x[(DATA_WIDTH_SQUARING)-:2] == 2'b00 ? 1'b0 : 1'b1;
genvar k;
generate
    for(k = DATA_IN_WIDTH-2; k >= 0; k = k - 1)
    begin: gen
        assign y[k] = x[(DATA_WIDTH_SQUARING)-:(2*(DATA_IN_WIDTH-k))] < 
        {y[DATA_IN_WIDTH-1:k+1],1'b1}*{y[DATA_IN_WIDTH-1:k+1],1'b1} ? 1'b0 : 1'b1;
    end
endgenerate
endmodule
