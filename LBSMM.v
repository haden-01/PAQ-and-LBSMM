`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yuanmiao Lin and Peng Zhang
// 
// Create Date: 2026/02/6 
// Design Name: 
// Module Name: LBSMM
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


module LBSMM(
    input  [3:0] A,         // signed 4-bit input (sign-magnitude format)
    input  [3:0] B,         // signed 4-bit input (sign-magnitude format)
    output [6:0] result     // signed 6-bit output
);

    reg [5:0] abs_result;
    wire sign = A[3] ^ B[3];


    // Look-up Table 3x3------Obtain the product of absolute values
    always @(*) 
        begin
            case ({A[2:0],B[2:0]})
                6'b000000: abs_result = 6'd0;   // 0*0
                6'b000001: abs_result = 6'd0;   // 0*1
                6'b000010: abs_result = 6'd0;   // 0*2
                6'b000011: abs_result = 6'd0;   // 0*3
                6'b000100: abs_result = 6'd0;   // 0*4
                6'b000101: abs_result = 6'd0;   // 0*5
                6'b000110: abs_result = 6'd0;   // 0*6
                6'b000111: abs_result = 6'd0;   // 0*7

                6'b001000: abs_result = 6'd0;   // 1*0
                6'b001001: abs_result = 6'd1;   // 1*1
                6'b001010: abs_result = 6'd2;   // 1*2
                6'b001011: abs_result = 6'd3;   // 1*3
                6'b001100: abs_result = 6'd4;   // 1*4
                6'b001101: abs_result = 6'd5;   // 1*5
                6'b001110: abs_result = 6'd6;   // 1*6
                6'b001111: abs_result = 6'd7;   // 1*7

                6'b010000: abs_result = 6'd0;   // 2*0
                6'b010001: abs_result = 6'd2;   // 2*1
                6'b010010: abs_result = 6'd4;   // 2*2
                6'b010011: abs_result = 6'd6;   // 2*3
                6'b010100: abs_result = 6'd8;   // 2*4
                6'b010101: abs_result = 6'd10;  // 2*5
                6'b010110: abs_result = 6'd12;  // 2*6
                6'b010111: abs_result = 6'd14;  // 2*7

                6'b011000: abs_result = 6'd0;   // 3*0
                6'b011001: abs_result = 6'd3;   // 3*1
                6'b011010: abs_result = 6'd6;   // 3*2
                6'b011011: abs_result = 6'd9;   // 3*3
                6'b011100: abs_result = 6'd12;  // 3*4
                6'b011101: abs_result = 6'd15;  // 3*5
                6'b011110: abs_result = 6'd18;  // 3*6
                6'b011111: abs_result = 6'd21;  // 3*7

                6'b100000: abs_result = 6'd0;   // 4*0
                6'b100001: abs_result = 6'd4;   // 4*1
                6'b100010: abs_result = 6'd8;   // 4*2
                6'b100011: abs_result = 6'd12;  // 4*3
                6'b100100: abs_result = 6'd16;  // 4*4
                6'b100101: abs_result = 6'd20;  // 4*5
                6'b100110: abs_result = 6'd24;  // 4*6
                6'b100111: abs_result = 6'd28;  // 4*7

                6'b101000: abs_result = 6'd0;   // 5*0
                6'b101001: abs_result = 6'd5;   // 5*1
                6'b101010: abs_result = 6'd10;  // 5*2
                6'b101011: abs_result = 6'd15;  // 5*3
                6'b101100: abs_result = 6'd20;  // 5*4
                6'b101101: abs_result = 6'd25;  // 5*5
                6'b101110: abs_result = 6'd30;  // 5*6
                6'b101111: abs_result = 6'd35;  // 5*7

                6'b110000: abs_result = 6'd0;   // 6*0
                6'b110001: abs_result = 6'd6;   // 6*1
                6'b110010: abs_result = 6'd12;  // 6*2
                6'b110011: abs_result = 6'd18;  // 6*3
                6'b110100: abs_result = 6'd24;  // 6*4
                6'b110101: abs_result = 6'd30;  // 6*5
                6'b110110: abs_result = 6'd36;  // 6*6
                6'b110111: abs_result = 6'd42;  // 6*7

                6'b111000: abs_result = 6'd0;   // 7*0
                6'b111001: abs_result = 6'd7;   // 7*1
                6'b111010: abs_result = 6'd14;  // 7*2
                6'b111011: abs_result = 6'd21;  // 7*3
                6'b111100: abs_result = 6'd28;  // 7*4
                6'b111101: abs_result = 6'd35;  // 7*5
                6'b111110: abs_result = 6'd42;  // 7*6
                6'b111111: abs_result = 6'd49;  // 7*7

                default: abs_result = 6'd0;
            endcase
        end

    wire [6:0] result_neg = ~{1'b0,abs_result};
	
	//Restore the sign bit
    assign result = sign ? result_neg+7'd1 : {1'b0,abs_result}; 

endmodule
