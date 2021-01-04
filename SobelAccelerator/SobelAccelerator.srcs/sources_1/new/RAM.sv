
module RAM #(parameter row = 10, parameter col = 10)
    (
    input ap_clk,
    input ap_rst,
    input signed [7:0] d_d0_V,
    input signed [7:0] d_d0_H,
    input        [7:0] sqrt_Gx_Gy,
    input signed [7:0] atan_Gx_Gy,
    
    input [31:0] d_address_read,
    input [31:0] d_address_write,
    input d_we0,
    input d_ce0,

    output reg [71:0] d_q0
    );
    
    reg signed [31:0] mem [0:row-1][0:col-1][0:6];
    
    //For testing 
    reg [7:0] test [0:24][0:24] =
    '{'{8'd132, 8'd110, 8'd103, 8'd39, 8'd226, 8'd231, 8'd94, 8'd112, 8'd173, 8'd96, 8'd229, 8'd246, 8'd211, 8'd33, 8'd230, 8'd182, 8'd199, 8'd37, 8'd51, 8'd198, 8'd117, 8'd94, 8'd1, 8'd81, 8'd49},
    '{ 8'd135, 8'd92, 8'd248, 8'd132, 8'd192, 8'd54, 8'd104, 8'd5, 8'd157, 8'd204, 8'd203, 8'd225, 8'd232, 8'd225, 8'd42, 8'd182, 8'd229, 8'd226, 8'd192, 8'd40, 8'd57, 8'd233, 8'd246, 8'd210, 8'd15},
    '{ 8'd149, 8'd8, 8'd75, 8'd20, 8'd165, 8'd140, 8'd148, 8'd6, 8'd113, 8'd197, 8'd55, 8'd126, 8'd185, 8'd159, 8'd148, 8'd229, 8'd123, 8'd98, 8'd19, 8'd31, 8'd42, 8'd175, 8'd247, 8'd147, 8'd155},
    '{ 8'd55, 8'd75, 8'd178, 8'd73, 8'd34, 8'd234, 8'd83, 8'd53, 8'd196, 8'd158, 8'd177, 8'd51, 8'd37, 8'd142, 8'd49, 8'd165, 8'd235, 8'd230, 8'd211, 8'd20, 8'd95, 8'd202, 8'd147, 8'd94, 8'd190},
    '{ 8'd192, 8'd52, 8'd139, 8'd204, 8'd33, 8'd72, 8'd131, 8'd202, 8'd109, 8'd93, 8'd120, 8'd160, 8'd95, 8'd137, 8'd241, 8'd174, 8'd76, 8'd255, 8'd8, 8'd84, 8'd69, 8'd201, 8'd132, 8'd187, 8'd132},
    '{ 8'd251, 8'd175, 8'd183, 8'd176, 8'd16, 8'd93, 8'd1, 8'd205, 8'd108, 8'd42, 8'd127, 8'd200, 8'd32, 8'd30, 8'd18, 8'd229, 8'd251, 8'd98, 8'd63, 8'd131, 8'd96, 8'd203, 8'd128, 8'd66, 8'd229},
    '{ 8'd101, 8'd67, 8'd179, 8'd32, 8'd31, 8'd147, 8'd183, 8'd77, 8'd105, 8'd217, 8'd73, 8'd119, 8'd167, 8'd111, 8'd24, 8'd170, 8'd248, 8'd204, 8'd227, 8'd171, 8'd150, 8'd188, 8'd114, 8'd16, 8'd214},
    '{ 8'd182, 8'd102, 8'd59, 8'd250, 8'd202, 8'd199, 8'd78, 8'd183, 8'd128, 8'd56, 8'd24, 8'd56, 8'd206, 8'd98, 8'd90, 8'd250, 8'd60, 8'd151, 8'd183, 8'd209, 8'd64, 8'd234, 8'd34, 8'd22, 8'd238},
    '{ 8'd1, 8'd96, 8'd19, 8'd111, 8'd102, 8'd255, 8'd127, 8'd17, 8'd194, 8'd188, 8'd40, 8'd165, 8'd236, 8'd23, 8'd110, 8'd85, 8'd100, 8'd235, 8'd119, 8'd171, 8'd234, 8'd137, 8'd36, 8'd50, 8'd225},
    '{ 8'd151, 8'd89, 8'd102, 8'd252, 8'd73, 8'd91, 8'd68, 8'd44, 8'd233, 8'd82, 8'd48, 8'd120, 8'd153, 8'd214, 8'd0, 8'd93, 8'd93, 8'd128, 8'd31, 8'd27, 8'd7, 8'd116, 8'd87, 8'd193, 8'd236},
    '{ 8'd132, 8'd110, 8'd103, 8'd39, 8'd226, 8'd231, 8'd94, 8'd112, 8'd173, 8'd96, 8'd229, 8'd246, 8'd211, 8'd33, 8'd230, 8'd182, 8'd199, 8'd37, 8'd51, 8'd198, 8'd117, 8'd94, 8'd1, 8'd81, 8'd49},
    '{ 8'd135, 8'd92, 8'd248, 8'd132, 8'd192, 8'd54, 8'd104, 8'd5, 8'd157, 8'd204, 8'd203, 8'd225, 8'd232, 8'd225, 8'd42, 8'd182, 8'd229, 8'd226, 8'd192, 8'd40, 8'd57, 8'd233, 8'd246, 8'd210, 8'd15},
    '{ 8'd149, 8'd8, 8'd75, 8'd20, 8'd165, 8'd140, 8'd148, 8'd6, 8'd113, 8'd197, 8'd55, 8'd126, 8'd185, 8'd159, 8'd148, 8'd229, 8'd123, 8'd98, 8'd19, 8'd31, 8'd42, 8'd175, 8'd247, 8'd147, 8'd155},
    '{ 8'd55, 8'd75, 8'd178, 8'd73, 8'd34, 8'd234, 8'd83, 8'd53, 8'd196, 8'd158, 8'd177, 8'd51, 8'd37, 8'd142, 8'd49, 8'd165, 8'd235, 8'd230, 8'd211, 8'd20, 8'd95, 8'd202, 8'd147, 8'd94, 8'd190},
    '{ 8'd192, 8'd52, 8'd139, 8'd204, 8'd33, 8'd72, 8'd131, 8'd202, 8'd109, 8'd93, 8'd120, 8'd160, 8'd95, 8'd137, 8'd241, 8'd174, 8'd76, 8'd255, 8'd8, 8'd84, 8'd69, 8'd201, 8'd132, 8'd187, 8'd132},
    '{ 8'd251, 8'd175, 8'd183, 8'd176, 8'd16, 8'd93, 8'd1, 8'd205, 8'd108, 8'd42, 8'd127, 8'd200, 8'd32, 8'd30, 8'd18, 8'd229, 8'd251, 8'd98, 8'd63, 8'd131, 8'd96, 8'd203, 8'd128, 8'd66, 8'd229},
    '{ 8'd101, 8'd67, 8'd179, 8'd32, 8'd31, 8'd147, 8'd183, 8'd77, 8'd105, 8'd217, 8'd73, 8'd119, 8'd167, 8'd111, 8'd24, 8'd170, 8'd248, 8'd204, 8'd227, 8'd171, 8'd150, 8'd188, 8'd114, 8'd16, 8'd214},
    '{ 8'd182, 8'd102, 8'd59, 8'd250, 8'd202, 8'd199, 8'd78, 8'd183, 8'd128, 8'd56, 8'd24, 8'd56, 8'd206, 8'd98, 8'd90, 8'd250, 8'd60, 8'd151, 8'd183, 8'd209, 8'd64, 8'd234, 8'd34, 8'd22, 8'd238},
    '{ 8'd1, 8'd96, 8'd19, 8'd111, 8'd102, 8'd255, 8'd127, 8'd17, 8'd194, 8'd188, 8'd40, 8'd165, 8'd236, 8'd23, 8'd110, 8'd85, 8'd100, 8'd235, 8'd119, 8'd171, 8'd234, 8'd137, 8'd36, 8'd50, 8'd225},
    '{ 8'd151, 8'd89, 8'd102, 8'd252, 8'd73, 8'd91, 8'd68, 8'd44, 8'd233, 8'd82, 8'd48, 8'd120, 8'd153, 8'd214, 8'd0, 8'd93, 8'd93, 8'd128, 8'd31, 8'd27, 8'd7, 8'd116, 8'd87, 8'd193, 8'd236},
    '{ 8'd132, 8'd110, 8'd103, 8'd39, 8'd226, 8'd231, 8'd94, 8'd112, 8'd173, 8'd96, 8'd229, 8'd246, 8'd211, 8'd33, 8'd230, 8'd182, 8'd199, 8'd37, 8'd51, 8'd198, 8'd117, 8'd94, 8'd1, 8'd81, 8'd49},
    '{ 8'd135, 8'd92, 8'd248, 8'd132, 8'd192, 8'd54, 8'd104, 8'd5, 8'd157, 8'd204, 8'd203, 8'd225, 8'd232, 8'd225, 8'd42, 8'd182, 8'd229, 8'd226, 8'd192, 8'd40, 8'd57, 8'd233, 8'd246, 8'd210, 8'd15},
    '{ 8'd149, 8'd8, 8'd75, 8'd20, 8'd165, 8'd140, 8'd148, 8'd6, 8'd113, 8'd197, 8'd55, 8'd126, 8'd185, 8'd159, 8'd148, 8'd229, 8'd123, 8'd98, 8'd19, 8'd31, 8'd42, 8'd175, 8'd247, 8'd147, 8'd155},
    '{ 8'd55, 8'd75, 8'd178, 8'd73, 8'd34, 8'd234, 8'd83, 8'd53, 8'd196, 8'd158, 8'd177, 8'd51, 8'd37, 8'd142, 8'd49, 8'd165, 8'd235, 8'd230, 8'd211, 8'd20, 8'd95, 8'd202, 8'd147, 8'd94, 8'd190},
    '{ 8'd192, 8'd52, 8'd139, 8'd204, 8'd33, 8'd72, 8'd131, 8'd202, 8'd109, 8'd93, 8'd120, 8'd160, 8'd95, 8'd137, 8'd241, 8'd174, 8'd76, 8'd255, 8'd8, 8'd84, 8'd69, 8'd201, 8'd132, 8'd187, 8'd132}};


    integer i, j;
    initial begin
        for (i = 0; i < row; i = i+1) begin
            for (j = 0; j < col; j = j+1) begin
                mem[i][j][0] <= test[i][j];
                mem[i][j][1] <= 0;
                mem[i][j][2] <= 0;
                mem[i][j][3] <= 0;
                mem[i][j][4] <= 0;
                mem[i][j][5] <= 0;
                mem[i][j][6] <= 0;
            end
        end
    end
    
        
    wire [7:0] c1,c2,c3,c4,c5,c6,c7,c8,c9;
    
    assign c1 = (d_address_read/col == 0       || d_address_read%col == 0      )? 0 : mem[(d_address_read/col)-1][(d_address_read%col)-1][0];
    assign c2 = (d_address_read/col == 0                                       )? 0 : mem[(d_address_read/col)-1][(d_address_read%col)]  [0];
    assign c3 = (d_address_read/col == 0       || d_address_read%col == (col-1))? 0 : mem[(d_address_read/col)-1][(d_address_read%col)+1][0];
    
    assign c4 = (d_address_read%col == 0                                       )? 0 : mem[(d_address_read/col)]  [(d_address_read%col)-1][0];
    assign c5 =                                                                       mem[(d_address_read/col)]  [(d_address_read%col)]  [0];
    assign c6 = (d_address_read%col == (col-1)                                 )? 0 : mem[(d_address_read/col)]  [(d_address_read%col)+1][0];

    assign c7 = (d_address_read/col == (row-1) || d_address_read%col == 0      )? 0 : mem[(d_address_read/col)+1][(d_address_read%col)-1][0];
    assign c8 = (d_address_read/col == (row-1)                                 )? 0 : mem[(d_address_read/col)+1][(d_address_read%col)]  [0];
    assign c9 = (d_address_read/col == (row-1) || d_address_read%col == (col-1))? 0 : mem[(d_address_read/col)+1][(d_address_read%col)+1][0];

    wire [7:0] d_d0_V_integrale;
    wire [7:0] d_d0_H_integrale;
    wire [7:0] sqrt_Gx_Gy_integrale;
    wire [7:0] atan_Gx_Gy_integrale;

    integrale #(.row(row), .col(col)) I1(d_d0_V, d_address_write,
                                                mem[(d_address_write/col)-1][(d_address_write%col)][1], 
                                                mem[(d_address_write/col)][(d_address_write%col)-1][1], 
                                                mem[(d_address_write/col)-1][(d_address_write%col)-1][1],
                                                d_d0_V_integrale);
                                                
    integrale #(.row(row), .col(col)) I2(d_d0_H, d_address_write,
                                                mem[(d_address_write/col)-1][(d_address_write%col)][2], 
                                                mem[(d_address_write/col)][(d_address_write%col)-1][2], 
                                                mem[(d_address_write/col)-1][(d_address_write%col)-1][2],
                                                d_d0_H_integrale);                                                

    integrale #(.row(row), .col(col)) I3(sqrt_Gx_Gy, d_address_write,
                                                mem[(d_address_write/col)-1][(d_address_write%col)][3], 
                                                mem[(d_address_write/col)][(d_address_write%col)-1][3], 
                                                mem[(d_address_write/col)-1][(d_address_write%col)-1][3],
                                                sqrt_Gx_Gy_integrale);                                                

    integrale #(.row(row), .col(col)) I4(atan_Gx_Gy, d_address_write,
                                                mem[(d_address_write/col)-1][(d_address_write%col)][4], 
                                                mem[(d_address_write/col)][(d_address_write%col)-1][4], 
                                                mem[(d_address_write/col)-1][(d_address_write%col)-1][4],
                                                atan_Gx_Gy_integrale);                                                
    
    always @ (posedge ap_clk) begin
        if (d_ce0) begin
            d_q0 <= {c1,c2,c3,c4,c5,c6,c7,c8,c9};
        end
        
    end


    always @ (posedge ap_clk) begin
        if (d_we0) begin
            mem[d_address_write/col][d_address_write%col][1] <= d_d0_V;
            mem[d_address_write/col][d_address_write%col][2] <= d_d0_H;
            mem[d_address_write/col][d_address_write%col][3] <= sqrt_Gx_Gy;
            mem[d_address_write/col][d_address_write%col][4] <= atan_Gx_Gy;
            mem[d_address_write/col][d_address_write%col][5] <= d_d0_V_integrale;
            mem[d_address_write/col][d_address_write%col][6] <= d_d0_H_integrale;
            mem[d_address_write/col][d_address_write%col][7] <= sqrt_Gx_Gy_integrale;
            mem[d_address_write/col][d_address_write%col][8] <= atan_Gx_Gy_integrale;
        end
    end
    
    
endmodule
