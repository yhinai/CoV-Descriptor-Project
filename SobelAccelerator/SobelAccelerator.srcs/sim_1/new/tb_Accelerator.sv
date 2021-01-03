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
    wire signed [7:0] d_d0_H;
    wire signed [7:0] d_d0_V;
    wire [7:0] sqrt_Gx_Gy;
    wire signed [7:0] atan_Gx_Gy;

    wire ap_start;
    wire ap_idle;
    wire ap_done;
    
    parameter row = 25;
    parameter col = 25;
    
    Top #(.row(row), .col(col)) U1
    (
    .ap_clk  (ap_clk),
    .ap_rst  (ap_rst),
    .d_d0_H  (d_d0_H),
    .d_d0_V  (d_d0_V),
    .sqrt_Gx_Gy  (sqrt_Gx_Gy),
    .atan_Gx_Gy  (atan_Gx_Gy),
    .ap_start(ap_start),
    .ap_idle (ap_idle),
    .ap_done (ap_done)
    );
    
    wire signed [15:0] Gy2 = d_d0_H*d_d0_H;
    wire signed [15:0] Gx2 = d_d0_V*d_d0_V;

    wire signed [15:0] Gy = d_d0_H;
    wire signed [15:0] Gx = d_d0_V;
    
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
        
        $finish;
        //$fclose(LogRes);
    end
    

    integer i;

    task operation;      
        reg signed [16:0] RES;
        begin 
            for (i = 0; i < col; i = i + 1) begin
                #10 RES = (Gy2+Gx2);
                $write ("(%d,%d,%d,%d)\t", d_d0_H, d_d0_V,sqrt_Gx_Gy, atan_Gx_Gy);
//                $write (LogRes, "%d ", RES);
            end
            
            $write("\n");
//            $write (LogRes, "\n", RES);

        end
    endtask



endmodule
