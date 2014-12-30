// Copyright (c) 2014 Takashi Toyoshima <toyoshim@gmail.com>.
// All rights reserved.  Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

`timescale 100ps/100ps

module ShifterTest;
  wire [7:0] w_data;
  wire       w_n;
  wire       w_z;
  wire       w_c;

  reg  [7:0] r_data;
  reg        r_rotate;
  reg        r_right;
  reg        r_c;

  reg        clk;

  MC6502Shifter dut(
    .i_data  (r_data  ),
    .i_rotate(r_rotate),
    .i_right (r_right ),
    .i_c     (r_c     ),
    .o_data  (w_data  ),
    .o_n     (w_n     ),
    .o_z     (w_z     ),
    .o_c     (w_c     ));

  always #1 clk = !clk;

  always @ (posedge clk) begin
    $display({ "result %04b_%04b, c=%b, rotate=%b, right=%b  => ",
               "%04b_%04b, n=%b, z=%b, c=%b" },
             r_data[7:4], r_data[3:0], r_c, r_rotate, r_right,
             w_data[7:4], w_data[3:0], w_n, w_z, w_c);
  end

  initial begin
    $dumpfile("Shifter.vcd");
    $dumpvars(0, dut);
    clk      <= 1'b0;
    r_data   <= 8'h00;
    r_rotate <= 1'b0;
    r_right  <= 1'b0;
    r_c      <= 1'b0;
    #2
    r_data   <= 8'h80;
    #2
    r_data   <= 8'h41;
    #2
    r_c      <= 1'b1;
    #2
    r_rotate <= 1'b1;
    #2
    r_data   <= 8'h80;
    #2
    r_right  <= 1'b1;
    #2
    r_c      <= 1'b0;
    #2
    r_rotate <= 1'b0;
    #2
    r_c      <= 1'b1;
    #2
    r_data   <= 8'h01;
    #2
    $finish;
  end
endmodule  // ShifterTest
