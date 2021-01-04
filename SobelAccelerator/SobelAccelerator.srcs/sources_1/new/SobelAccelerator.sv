

module SobelAccelerator #(parameter row = 10, parameter col = 10)
    (
    input ap_clk, 
    input ap_rst, 
    input [71:0] d_q0, 
    output reg signed [7:0] d_d0_V,
    output reg signed [7:0] d_d0_H,
    output reg        [7:0] sqrt_Gx_Gy,
    output reg signed [7:0] atan_Gx_Gy,
    output reg [31:0] d_address_read,
    output reg [31:0] d_address_write,
    output reg d_we0, d_ce0,
    output reg ap_start,
    output reg ap_idle,
    output reg ap_done
    );


    localparam  [2:0] IDLE = 0;
    localparam  [2:0] START = 1;
    localparam  [2:0] PROCESS = 2;    
    localparam  [2:0] LAST = 3;
    localparam  [2:0] DONE = 4;
    reg [2:0] STATE = IDLE;
    
    reg [31:0] addrWrite = 0;
    
    
    
    wire signed [7:0] V_sobel;
    wire signed [7:0] H_sobel;
    wire        [7:0] sqrt_GxGy;
    wire signed [7:0] atan_GxGy;
    
    
    sobelAlg#(row, col) SA0(d_q0, d_address_write, V_sobel, H_sobel);
    
    sqrt S0(V_sobel, H_sobel, sqrt_GxGy);
    
    atan A0(V_sobel, H_sobel, atan_GxGy);
    
    integer i=0, j=0;
    
    initial begin
        addrWrite <= 0;
        d_ce0 <= 0;
        d_we0 <= 0;
        i <= 0;
        j <= 0;
        ap_idle <= 1;
        ap_done <= 0;
    end
    
    //scan ever cell in the array
    always @ (posedge ap_clk) begin
        if (ap_rst)begin 
            ap_start <= 1;
            ap_idle <= 1;
            ap_done <= 0;
            i <= 0;
            j <= 0;
            
            STATE <= START;
        end        
        else case(STATE)
            IDLE: begin
                addrWrite <= 0;
                d_ce0 <= 0;
                d_we0 <= 0;
                i <= 0;
                j <= 0;
                ap_idle <= 1;

            end
            
            START: begin
                d_address_read <= (i*row)+j;
                addrWrite <= (i*row)+j;
                d_address_write <= addrWrite;
                ap_start <= 0;
                ap_idle <= 0;
                d_ce0 <= 1;
                d_we0 <= 0;
                j <= (j+1)%col;
                
                STATE <= PROCESS;
            end
            
            PROCESS: begin
                d_address_read <= (i*row)+j;
                addrWrite <= (i*row)+j;
                d_address_write <= addrWrite;
                
                d_d0_V <= V_sobel;
                d_d0_H <= H_sobel;
                sqrt_Gx_Gy <= sqrt_GxGy;
                atan_Gx_Gy <= atan_GxGy;
                
                d_ce0 <= 1;
                d_we0 <= 1;
                
                j <= (j+1)%col; 
                i <= ((j+1) >= col)? (i+1)%row : i ;
                if ((i+1)%row == 0 && (j+1)%col == 0) STATE <= LAST;
            end   
            
            LAST: begin
                d_d0_V <= V_sobel;
                d_d0_H <= H_sobel;
                sqrt_Gx_Gy <= sqrt_GxGy;
                atan_Gx_Gy <= atan_GxGy;

                d_ce0 <= 0;
                d_we0 <= 1;
                ap_done <= 1;
                STATE <= IDLE;
            end

        endcase        
    end
    
endmodule
