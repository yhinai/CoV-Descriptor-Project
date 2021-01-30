
module RAM #(parameter row = 10, parameter col = 10)
    (
    input ap_clk,
    input ap_rst,
    //
    input transmit, //btn signal to trigger the UART communication
    input [7:0] data, // data transmitted
    output reg TxD, // Transmitter serial output. TxD will be held high during reset, or when no transmissions aretaking place. 

    //
    input signed [7:0] d_d0_V,
    input signed [7:0] d_d0_H,
    input        [7:0] sqrt_Gx_Gy,
    input signed [7:0] atan_Gx_Gy,
    
    input [31:0] d_address_read,
    input [31:0] d_address_write,
    input d_we0,
    input d_ce0,
    
//    output signed [7:0] memOut [0:9],
    output reg [71:0] d_q0
    );


    
    reg signed [0:7] mem [0:row-1][0:col-1][0:9];
    
    //For testing 
    reg [0:7] testArr [0:24][0:24] =
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
                mem[i][j] <= '{testArr[i][j], 0, 0, 0, 0, 0, 0, 0, 0, 0};
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

    reg [7:0] TEST_1,TEST_2,TEST_3,TEST_4;

    always @ (posedge ap_clk) begin
        if (d_ce0) begin
            d_q0 <= {c1,c2,c3,c4,c5,c6,c7,c8,c9};
//            TEST_1 <= mem[(d_address_write/col)]  [(d_address_write%col)]  [0];
//            TEST_2 <= mem[(d_address_write/col)-1][(d_address_write%col)]  [0];
//            TEST_3 <= mem[(d_address_write/col)]  [(d_address_write%col)-1][0];
//            TEST_4 <= mem[(d_address_write/col)-1][(d_address_write%col)-1][0];
            
        end
        
    end

    wire [7:0] image_integrale;
    wire signed [7:0] d_d0_V_integrale;
    wire signed [7:0] d_d0_H_integrale;
    wire [7:0] sqrt_Gx_Gy_integrale;
    wire signed [7:0] atan_Gx_Gy_integrale;


    reg [31:0] d_address_write_TB;
    reg [31:0] d_address_write_TB2;
    reg [31:0] TEST001;



    unsigned_integrale #(.row(row), .col(col)) I0(mem[((d_address_write)/col)]  [((d_address_write)%col)]  [0], d_address_write,
                                                  mem[((d_address_write)/col)-1][((d_address_write)%col)]  [5], 
                                                  mem[((d_address_write)/col)]  [((d_address_write)%col)-1][5],
                                                  mem[((d_address_write)/col)-1][((d_address_write)%col)-1][5],
                                                  image_integrale);
    
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

    unsigned_integrale #(.row(row), .col(col)) I3(sqrt_Gx_Gy, d_address_write,
                                                mem[(d_address_write/col)-1][(d_address_write%col)][3], 
                                                mem[(d_address_write/col)][(d_address_write%col)-1][3], 
                                                mem[(d_address_write/col)-1][(d_address_write%col)-1][3],
                                                sqrt_Gx_Gy_integrale);                                                

    integrale #(.row(row), .col(col)) I4(atan_Gx_Gy, d_address_write,
                                                mem[(d_address_write/col)-1][(d_address_write%col)][4], 
                                                mem[(d_address_write/col)][(d_address_write%col)-1][4], 
                                                mem[(d_address_write/col)-1][(d_address_write%col)-1][4],
                                                atan_Gx_Gy_integrale);                                                

    
    //Send to TB for testing
//    assign memOut = mem[d_address_write_TB2/col][d_address_write_TB2%col];
    
    reg writeEnable = 0;
    reg [7:0] image_integrale2 = image_integrale;
    
    always @ (posedge ap_clk) begin
        if (d_we0) begin            
            d_address_write_TB <= d_address_write;
            image_integrale2 <= {image_integrale};
            //writeEnable <= 1;
        end
    end
    
    always @ (negedge ap_clk) begin
            d_address_write_TB2 <= d_address_write_TB;
            
            mem[d_address_write_TB/col][d_address_write_TB%col][1:5] <= {d_d0_V, d_d0_H, sqrt_Gx_Gy, atan_Gx_Gy, image_integrale2};
//            mem[d_address_write_TB/col][d_address_write_TB%col][5] <= {image_integrale};
//            mem[d_address_write_TB/col][d_address_write_TB%col][6] <= d_d0_V_integrale;
//            mem[d_address_write_TB/col][d_address_write_TB%col][7] <= d_d0_H_integrale;
//            mem[d_address_write_TB/col][d_address_write_TB%col][8] <= sqrt_Gx_Gy_integrale;
//            mem[d_address_write_TB/col][d_address_write_TB%col][9] <= atan_Gx_Gy_integrale;
            //writeEnable <= 0;


    end
    
///////////////////////////////////////////////////////////////////////////////////////////////////////////

//internal variables
reg [3:0] bitcounter; //4 bits counter to count up to 10
reg [13:0] counter; //14 bits counter to count the baud rate, counter = clock / baud rate
reg [16:0] num = 0; //14 bits counter to count the baud rate, counter = clock / baud rate
reg [1:0] state,nextstate; // initial & next state variable
// 10 bits data needed to be shifted out during transmission.
//The least significant bit is initialized with the binary value "0" (a start bit) A binary value "1" is introduced in the most significant bit 
reg [9:0] rightshiftreg; 
reg shift; //shift signal to start bit shifting in UART
reg load; //load signal to start loading the data into rightshift register and add start and stop bit
reg clear; //clear signal to start reset the bitcounter for UART transmission

//UART transmission logic
always @ (posedge ap_clk) 
begin 
    if (ap_rst) 
	   begin // reset is asserted (reset = 1)
        state <=0; // state is idle (state = 0)
        counter <=0; // counter for baud rate is reset to 0 
        bitcounter <=0; //counter for bit transmission is reset to 0
       end
    else begin
         counter <= counter + 1; //counter for baud rate generator start counting 
            if (counter >= 10416) //if count to 10416 (from 0 to 10415)
               begin 
                  state <= nextstate; //previous state change to next state
                  counter <=0; // reset couter to 0
            	  if (load) begin
            	       rightshiftreg <= {1'b1, mem[(num/col)][(num%col)][1], 1'b0}; //load the data if load is asserted
            	       num <= (num+1) % (625);
            	       end
		          if (clear) bitcounter <=0; // reset the bitcounter if clear is asserted
                  if (shift) 
                     begin // if shift is asserted
                        rightshiftreg <= rightshiftreg >> 1; //right shift the data as we transmit the data from lsb
                        bitcounter <= bitcounter + 1; //count the bitcounter
                     end
               end
         end
end 

//state machine

always @ (posedge ap_clk) //trigger by positive edge of clock, 
//always @ (state or bitcounter or transmit)
begin
    load <=0; // set load equal to 0 at the beginning
    shift <=0; // set shift equal to 0 at the beginning
    clear <=0; // set clear equal to 0 at the beginning
    TxD <=1; // set TxD equals to during no transmission
    case (state)
        0: begin // idle state
             if (transmit || num != 0) begin // assert transmit input
             nextstate <= 1; // Move to transmit state
             load <=1; // set load to 1 to prepare to load the data
             shift <=0; // set shift to 0 so no shift ready yet
             clear <=0; // set clear to 0 to avoid clear any counter
             end 
		else begin // if transmit not asserted
             nextstate <= 0; // next state is back to idle state
             TxD <= 1; 
             end
           end
        1: begin  // transmit state
             if (bitcounter >=10) begin // check if transmission is complete or not. If complete
             nextstate <= 0; // set nextstate back to 0 to idle state
             clear <=1; // set clear to 1 to clear all counters
             end 
		else begin // if transmisssion is not complete 
             nextstate <= 1; // set nextstate to 1 to stay in transmit state
             TxD <= rightshiftreg[0]; // shift the bit to output TxD
             shift <=1; // set shift to 1 to continue shifting the data
             end
           end
         default: nextstate <= 0;                      
    endcase
end


endmodule
