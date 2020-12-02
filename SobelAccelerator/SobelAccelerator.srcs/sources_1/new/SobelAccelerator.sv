

module SobelAccelerator #(parameter row = 5, parameter col = 5)
    (
    input ap_clk, 
    input ap_rst, 
    input [71:0] d_q0, 
    output reg signed [7:0] d_d0_H,
    output reg signed [7:0] d_d0_V,
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
    
    integer i=0, j=0;
    
    wire signed [7:0] H_sobel;
    wire signed [7:0] V_sobel;

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
    
    assign H_sobel = (d_address_write/col != 0 && d_address_write%col != 0 && d_address_write/col != (row-1) && d_address_write%col != (col-1))? (-c1-2*c2-c3+c7+2*c8+c9)>>3 : 0;
    assign V_sobel = (d_address_write/col != 0 && d_address_write%col != 0 && d_address_write/col != (row-1) && d_address_write%col != (col-1))? (-c1-2*c4-c7+c3+2*c6+c9)>>3 : 0;    
    
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
                ap_done <= 0;

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
                d_d0_H <= H_sobel;
                d_d0_V <= V_sobel;
                d_ce0 <= 1;
                d_we0 <= 1;
                
                j <= (j+1)%col; 
                i <= ((j+1) >= col)? (i+1)%row : i ;
                if ((i+1)%row == 0 && (j+1)%col == 0) STATE <= LAST;
            end   
            
            LAST: begin
                d_d0_H <= H_sobel;
                d_d0_V <= V_sobel;

                d_ce0 <= 0;
                d_we0 <= 1;
                ap_done <= 1;
                STATE <= IDLE;
            end
 
        endcase        
    end
    
    
endmodule
