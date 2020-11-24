`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2020 01:46:24 PM
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
    wire signed [7:0] d_d0;
    
    wire ap_start;
    wire ap_idle;
    wire ap_done;
    
    parameter row = 25;
    parameter col = 25;
    
    Top #(row, col) U1
    (
    .ap_clk (ap_clk),
    .ap_rst (ap_rst),
    .d_d0   (d_d0),
    .ap_start (ap_start),
    .ap_idle (ap_idle),
    .ap_done (ap_done)
    );
    
    
    always #5 ap_clk = ~ap_clk;
    
    integer LogRes;
    initial begin
        LogRes = $fopen("LogRes");
        ap_clk = 0;
        ap_rst = 1;
        #10 ap_rst = 0;
        #20
        repeat (row) begin 
            operation();
        end 
        
        //$fclose(LogRes);
    end
    
    
    integer i;

    task operation;      
        reg signed [7:0] RES;
        begin 
            for (i = 0; i < col; i = i + 1) begin
                #10 RES = d_d0;
                $write ("%d ", RES);
//                $write (LogRes, "%d ", RES);
            end
            
            $write("\n");
//            $write (LogRes, "\n", RES);

        end
    endtask



endmodule
