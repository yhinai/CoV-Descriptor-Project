`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/24/2020 11:25:16 AM
// Design Name: 
// Module Name: Vsobel
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


module sobelAlg#(parameter row = 10, parameter col = 10)
(
    
    input [71:0] d_q0,
    input [31:0] d_address_write,
    output signed [7:0] V_sobel,
    output signed [7:0] H_sobel

    );


    wire [7:0] c1,c2,c3,c4,c5,c6,c7,c8,c9;

    assign c1 = d_q0[71:64];
    assign c2 = d_q0[63:56];
    assign c3 = d_q0[55:48];

    assign c4 = d_q0[47:40];
    assign c5 = d_q0[39:32];
    assign c6 = d_q0[31:24];
    
    assign c7 = d_q0[23:16];
    assign c8 = d_q0[15:8 ];
    assign c9 = d_q0[7 :0 ];
    
    assign V_sobel = (d_address_write/col != 0 && d_address_write%col != 0 && d_address_write/col != (row-1) && d_address_write%col != (col-1))? (-c1-2*c4-c7+c3+2*c6+c9)>>>3 : 0;    
    assign H_sobel = (d_address_write/col != 0 && d_address_write%col != 0 && d_address_write/col != (row-1) && d_address_write%col != (col-1))? (-c1-2*c2-c3+c7+2*c8+c9)>>>3 : 0;

endmodule