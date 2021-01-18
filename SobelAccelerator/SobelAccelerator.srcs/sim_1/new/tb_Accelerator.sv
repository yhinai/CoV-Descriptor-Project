`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2020 05:08:07 PM
// Design Name: 
// Module Name: tb_Accelerator
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


module tb_Accelerator();

    reg  ap_clk = 0;
    reg  ap_rst = 0;
    wire signed [7:0] memOut [0:9];

    wire ap_start;
    wire ap_idle;
    wire ap_done;
    
    parameter row = 25;
    parameter col = 25;
    
    Top #(.row(row), .col(col)) U1
    (
    .ap_clk  (ap_clk),
    .ap_rst  (ap_rst),
    .memOut  (memOut),
    .ap_start(ap_start),
    .ap_idle (ap_idle),
    .ap_done (ap_done)
    );
    
    
    always #5 ap_clk = ~ap_clk;
    
    integer LogRes;
    initial begin
        LogRes = $fopen("LogRes.txt");
        ap_clk = 0;
        ap_rst = 1;
        #10 ap_rst = 0;
        #30

        operation();
        
        #50

        $fclose(LogRes);
        $finish;
        
    end
    

    reg [5:0] i, j;

    task operation;

        $write (         "index (pixel, Gx, Gy, sqrt, atan, pixel_Integrale)\n");
        $fwrite (LogRes, "index (pixel, Gx, Gy, sqrt, atan, pixel_Integrale)\n");

        begin 
            for (i = 0; i < row; i = i + 1) begin
                for (j = 0; j < col; j = j + 1) begin
                    #10
                    $write (         "[%d][%d] (%d,%d,%d,%d,%d,%d)\n", i, j, $unsigned(memOut[0]), memOut[1], memOut[2], memOut[3], memOut[4], $unsigned(memOut[5])/*, memOut[6], memOut[7], memOut[8], memOut[9]*/);
                    $fwrite (LogRes, "[%d][%d] (%d,%d,%d,%d,%d,%d)\n", i, j, $unsigned(memOut[0]), memOut[1], memOut[2], memOut[3], memOut[4], $unsigned(memOut[5])/*, memOut[6], memOut[7], memOut[8], memOut[9]*/);
    
                end
            
                $write("\n");
                $fwrite (LogRes, "\n");
            end
        end
    endtask



endmodule
