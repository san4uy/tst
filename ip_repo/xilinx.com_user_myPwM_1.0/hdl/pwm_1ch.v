`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.07.2020 15:17:46
// Design Name: 
// Module Name: pwm_1ch
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


module pwm_1ch #( parameter W=32 )
(
    input  wire         clk,
    input  wire         arst,
    input  wire [1:0]   ctrl,
    input  wire [W-1:0] pos_dn,
    input  wire [W-1:0] pos_end,
    output wire         pwm_out
);

reg [W-1:0]  pwm_cnt;

reg          r_pwm;
wire         en;
wire         invert;

assign en = ctrl[0];
assign invert = ctrl[1];



always @(posedge clk or posedge arst)
    if (arst)       pwm_cnt <= {W{1'b0}};
    else
        if ( (!en) || (pwm_cnt == pos_end))
                    pwm_cnt <= {W{1'b0}};
        else        pwm_cnt <= pwm_cnt + 1;

always @(posedge clk or posedge arst)
    if (arst)       r_pwm <= 1'b0;
    else
        if ( (!en) || (pwm_cnt == pos_dn))
                    r_pwm <= 1'b0;
        else if (pwm_cnt == {W{1'b0}}) r_pwm <= 1'b1;
        
assign pwm_out = r_pwm ^ invert;

endmodule
