

module Top #(parameter row = 10, parameter col = 10)
    (
//    input ap_clk,
//    input ap_rst,
//    output signed [7:0] memOut [0:9],

//    output ap_start,
//    output ap_idle,
//    output ap_done
    input [7:0]sw,
    input btn0,
    input btn1,
    input clk,
    output TxD,
    output TxD_debug,
    output transmit_debug,
    output button_debug, 
    output clk_debug
    );
    
    
    wire [71:0] d_q0;
    wire [31:0] d_address_read;
    wire [31:0] d_address_write;

    wire signed [7:0] d_d0_H;
    wire signed [7:0] d_d0_V;
    wire [7:0] sqrt_Gx_Gy;
    wire signed [7:0] atan_Gx_Gy;
        
    wire d_we0;
    wire d_ce0;

    SobelAccelerator #(.row(row), .col(col) ) SA (
//        .ap_clk (ap_clk), 
//        .ap_rst (ap_rst), 
        .ap_clk (clk),
        .ap_rst (btn0),
        .d_q0 (d_q0), 
        .d_d0_V (d_d0_V),
        .d_d0_H (d_d0_H),
        .sqrt_Gx_Gy (sqrt_Gx_Gy),
        .atan_Gx_Gy (atan_Gx_Gy),
        .d_address_read (d_address_read),
        .d_address_write (d_address_write),
        .d_we0 (d_we0),
        .d_ce0 (d_ce0),
        .ap_start (ap_start),
        .ap_idle (ap_idle),
        .ap_done (ap_done)
        );
                    
                    
    RAM  #(.row(row), .col(col) ) R0 (
//        .ap_clk (ap_clk),
//        .ap_rst (ap_rst),
        .ap_clk (clk),
        .ap_rst (btn0),
        
        //serial communication
        .transmit(transmit),
        .TxD(TxD),
        .data(sw),
        //
        
        .d_d0_V (d_d0_V),
        .d_d0_H (d_d0_H),
        .sqrt_Gx_Gy (sqrt_Gx_Gy),
        .atan_Gx_Gy (atan_Gx_Gy),
        .d_address_read (d_address_read),
        .d_address_write (d_address_write),
        .d_we0 (d_we0),
        .d_ce0 (d_ce0),
//        .memOut (memOut),
        .d_q0 (d_q0)
        );


// serial communication

    transmit_debouncing D0 (.clk(clk), .btn1(btn1), .transmit(transmit));
//



endmodule
