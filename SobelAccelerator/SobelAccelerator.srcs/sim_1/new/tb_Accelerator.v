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
    
    Top U1(
    .ap_clk (ap_clk),
    .ap_rst (ap_rst),
    .d_d0   (d_d0),
    .ap_start (ap_start),
    .ap_idle (ap_idle),
    .ap_done (ap_done)
    );
    
    integer Res;
    always #5 ap_clk = ~ap_clk;
    
    initial begin
        Res = $fopen("log_results.txt");
        ap_clk = 0;
        ap_rst = 1;
        #10 ap_rst = 0;
        #20
        operation();
        operation();
        operation();
        operation();
        operation();
        operation();
        operation();
        operation();
        operation();
        operation();
        
        $fclose(Res);
    end
    
    

    task operation;      
        reg signed [7:0] RES [0:9];
        begin 
            
            #10 RES[0] = d_d0;
            #10 RES[1] = d_d0;
            #10 RES[2] = d_d0;
            #10 RES[3] = d_d0;
            #10 RES[4] = d_d0;
            #10 RES[5] = d_d0;
            #10 RES[6] = d_d0;
            #10 RES[7] = d_d0;
            #10 RES[8] = d_d0;
            #10 RES[9] = d_d0;
            
            $display ("%d  %d  %d  %d  %d  %d  %d  %d  %d  %d", RES[0], RES[1], RES[2], RES[3], RES[4], RES[5], RES[6], RES[7], RES[8], RES[9]);
            $fdisplay(Res, "%d  %d  %d  %d  %d  %d  %d  %d  %d  %d", RES[0], RES[1], RES[2], RES[3], RES[4], RES[5], RES[6], RES[7], RES[8], RES[9]);

        end
    endtask



endmodule
