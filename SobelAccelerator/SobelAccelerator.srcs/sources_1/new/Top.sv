

module Top #(parameter row = 10, parameter col = 10)
    (
    input ap_clk,
    input ap_rst,
    output wire signed [7:0] d_d0,
    output ap_start,
    output ap_idle,
    output ap_done
    );
    
    wire [47:0] d_q0;
    wire [31:0] d_address_read;
    wire [31:0] d_address_write;
    wire d_we0;
    wire d_ce0;
        
    SobelAccelerator #(.row(row), .col(col) ) SA (
        ap_clk, 
        ap_rst, 
        d_q0, 
        d_d0,
        d_address_read,
        d_address_write,
        d_we0,
        d_ce0,
        ap_start,
        ap_idle,
        ap_done
        );
                    
    RAM  #(.row(row), .col(col) ) R0 (
        ap_clk,
        ap_rst,
        d_d0,
        d_address_read,
        d_address_write,
        d_we0,
        d_ce0,
        d_q0
        );


endmodule
