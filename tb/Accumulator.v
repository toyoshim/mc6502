// Copyright (c) 2014 Takashi Toyoshima <toyoshim@gmail.com>.
// All rights reserved.  Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

`timescale 100ps/100ps

module AccumulatorTest;
  wire [7:0] w_a;
  wire       w_n;
  wire       w_z;
  wire       w_c;
  wire       w_v;

  reg  [7:0] r_a;
  reg  [7:0] r_m;
  reg        r_c;
  reg        r_d;
  reg        r_s;

  reg        clk;

  MC6502Accumulator dut(
    .i_a(r_a),
    .i_m(r_m),
    .i_c(r_c),
    .i_d(r_d),
    .i_s(r_s),
    .o_a(w_a),
    .o_n(w_n),
    .o_z(w_z),
    .o_c(w_c),
    .o_v(w_v));

  always #1 clk = !clk;

  always @ (posedge clk) begin
    $display("result = %04b_%04b, n=%b, z=%b, c=%b, v=%b",
             w_a[7:4], w_a[3:0], w_n, w_z, w_c, w_v);
  end

  initial begin
    $dumpfile("Accumulator.vcd");
    $dumpvars(0, dut);
    clk <= 1'b0;
    r_d <= 1'b0;
    r_s <= 1'b0;
    // From Example 2.1
    r_a <= 8'b00001101;
    r_m <= 8'b11010011;
    r_c <= 1'b1;
    #2
    // From Example 2.2
    r_a <= 8'b11111110;
    r_m <= 8'b00000110;
    r_c <= 1'b1;
    #2
    // From Example 2.6
    r_a <= 8'b00000101;
    r_m <= 8'b00000111;
    r_c <= 1'b0;
    #2
    // From Example 2.7
    r_a <= 8'b01111111;
    r_m <= 8'b00000010;
    r_c <= 1'b1;
    #2
    // From Example 2.8
    r_a <= 8'b00000101;
    r_m <= 8'b11111101;
    r_c <= 1'b0;
    #2
    // From Example 2.9
    r_a <= 8'b00000101;
    r_m <= 8'b11111001;
    r_c <= 1'b0;
    #2
    // From Example 2.10
    r_a <= 8'b11111011;
    r_m <= 8'b11111001;
    r_c <= 1'b0;
    #2
    // From Example 2.11
    r_a <= 8'b10111110;
    r_m <= 8'b10111111;
    r_c <= 1'b0;
    #2
    // From Example 2.12
    r_a <= 8'b01111001;
    r_m <= 8'b00010100;
    r_c <= 1'b0;
    r_d <= 1'b1;
    #2
    // From Example 2.13
    r_a <= 8'b00000101;
    r_m <= 8'b00000011;
    r_c <= 1'b1;
    r_d <= 1'b0;
    r_s <= 1'b1;
    #2
    // From example 2.14
    r_a <= 8'b00000101;
    r_m <= 8'b00000110;
    r_c <= 1'b1;
    #2
    // From example 2.18
    r_a <= 8'b01000100;
    r_m <= 8'b00101001;
    r_c <= 1'b1;
    r_d <= 1'b1;
    #2
    $finish;
  end
endmodule  // AccumulatorTest
