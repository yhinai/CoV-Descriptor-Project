
module RAM(
    input ap_clk,
    input ap_rst,
    input signed [7:0] d_d0,
    input [31:0] d_address_read,
    input [31:0] d_address_write,
    input d_we0,
    input d_ce0,

    output reg [47:0] d_q0
    );
    
    parameter row = 10;
    parameter col = 10;
    reg signed [7:0] mem [0:row-1][0:col-1][0:1];
    
    reg signed [7:0] test [0:row-1][0:col-1] =
                                       {{8'd5  , 8'd13 ,  8'd1 , 8'd56 , 8'd54 , 8'd43 , 8'd13 , 8'd28 , 8'd37 , 8'd26},
                                        {8'd35 , 8'd42 , 8'd16 , 8'd7  , 8'd25 , 8'd47 , 8'd23 , 8'd12 , 8'd35 , 8'd40},
                                        {8'd47 , 8'd29 , 8'd15 , 8'd47 , 8'd38 , 8'd10 , 8'd28 , 8'd57 , 8'd61 , 8'd17},
                                        {8'd52 , 8'd61 , 8'd24 , 8'd18 , 8'd55 , 8'd4  , 8'd61 , 8'd43 , 8'd38 , 8'd27},
                                        {8'd50 , 8'd24 , 8'd47 , 8'd8  , 8'd34 , 8'd54 , 8'd7  , 8'd3  , 8'd16 , 8'd17},
                                        {8'd20 , 8'd54 , 8'd12 , 8'd61 , 8'd23 , 8'd7  , 8'd21 , 8'd14 , 8'd36 , 8'd4 },
                                        {8'd58 , 8'd42 , 8'd41 , 8'd56 , 8'd10 , 8'd61 , 8'd47 , 8'd56 , 8'd14 , 8'd35},
                                        {8'd19 , 8'd16 , 8'd35 , 8'd23 , 8'd24 , 8'd51 , 8'd7  , 8'd63 , 8'd10 , 8'd17},
                                        {8'd0  , 8'd16 , 8'd2  , 8'd3  , 8'd50 , 8'd19 , 8'd14 , 8'd17 , 8'd55 , 8'd54},
                                        {8'd21 , 8'd50 , 8'd58 , 8'd26 , 8'd12 , 8'd27 , 8'd13 , 8'd10 , 8'd15 , 8'd8}};
    integer i, j;
    initial begin
        for (i = 0; i < row; i = i+1) begin
            for (j = 0; j < col; j = j+1) begin
                mem[i][j][0] <= test[i][j];
                mem[i][j][1] <= 0;
            end
        end
    end
    
    
    wire [7:0] c1,c2,c3,c7,c8,c9;
    assign c1 = (d_address_read/col == 0       || d_address_read%col == 0      )? 0 : mem[(d_address_read/col)-1][(d_address_read%col)-1][0];
    assign c2 = (d_address_read/col == 0                                       )? 0 : mem[(d_address_read/col)-1][(d_address_read%col)]  [0];
    assign c3 = (d_address_read/col == 0       || d_address_read%col == (col-1))? 0 : mem[(d_address_read/col)-1][(d_address_read%col)+1][0];
    
    assign c7 = (d_address_read/col == (row-1) || d_address_read%col == 0      )? 0 : mem[(d_address_read/col)+1][(d_address_read%col)-1][0];
    assign c8 = (d_address_read/col == (row-1)                                 )? 0 : mem[(d_address_read/col)+1][(d_address_read%col)]  [0];
    assign c9 = (d_address_read/col == (row-1) || d_address_read%col == (col-1))? 0 : mem[(d_address_read/col)+1][(d_address_read%col)+1][0];

    always @ (posedge ap_clk) begin
        if (d_ce0) begin
            d_q0 <= {c1,c2,c3,c7,c8,c9};
        end
        
    end


    always @ (posedge ap_clk) begin
        if (d_we0) begin
            mem[d_address_write/col][d_address_write%col][1] <= d_d0;
        end
    end
    
    
endmodule
