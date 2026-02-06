`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2026/02/06
// Design Name:
// Module Name: tb_LBSMM
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//   Testbench for clm_sm_kn.
//   It exhaustively drives all sign-magnitude (SM) encoded values from -7 to 7
//   for both A and B inputs. 
//
// Notes on SM encoding used here:
//   - 4-bit SM format: [3] is sign, [2:0] is magnitude.
//   - sign = 0 means positive or zero; sign = 1 means translate to 2's complement.
//   - magnitude ranges 0 to 7.
//////////////////////////////////////////////////////////////////////////////////

module tbLBSMM;

    // 4_bit × 4_bit SM inputs
    reg [3:0] A;
    reg [3:0] B;

    // 4_bit × 4_bit outputs 
    wire [6:0] result;

    // Instantiate 
    LBSMM dut (
        .A(A),
        .B(B),
        .result(result)
    );

    // Function: convert a signed integer in range [-7, 7] to 4-bit SM encoding.

    function [3:0] to_sm4;
        input  [3:0] val;
        reg  [3:0] mag;
        begin
            if (val[3] ==1'b 1) begin
                mag   = ~val+4'd1;
                to_sm4 = {1'b1, mag[2:0]};
            end else begin
                mag   = val;
                to_sm4 = {1'b0, mag[2:0]};
            end
        end
    endfunction


    integer a_i;
    integer b_i;

    initial begin
        // Initialize 
        A = 4'b0000;
        B = 4'b0000;

        #10;

        // run all possible signed values from -7 to 7 for A and B.
        for (a_i = -7; a_i <= 7; a_i = a_i + 1) begin
            for (b_i = -7; b_i <= 7; b_i = b_i + 1) begin
                // Drive SM-encoded inputs.
                A = to_sm4(a_i);
                B = to_sm4(b_i);

                //
                #10;
            end
        end

        // End 
        #10;
        $finish;
    end

endmodule
