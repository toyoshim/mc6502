// Copyright (c) 2014 Takashi Toyoshima <toyoshim@gmail.com>.
// All rights reserved.  Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

`timescale 100ps/100ps

module RegisterFileTest;
  wire [15:0] w_rf2mc_pc;
  wire [ 7:0] w_rf2mc_a;
  wire [ 7:0] w_rf2mc_x;
  wire [ 7:0] w_rf2mc_y;
  wire [ 7:0] w_rf2mc_s;
  wire [ 7:0] w_rf2ec_a;
  wire        w_rf2ec_c;
  wire        w_rf2ec_d;
  wire        w_rf2ec_n;
  wire        w_rf2ec_v;
  wire        w_rf2ec_z;

  reg         clk;
  reg         rst_x;
  reg  [ 7:0] r_il2rf_data;
  reg         r_il2rf_set_pcl;
  reg         r_il2rf_set_pch;
  reg         r_mc2rf_fetched;

  MC6502RegisterFile dut(
    .clk          (clk            ),
    .rst_x        (rst_x          ),
    .il2rf_set_i  (1'b0           ),
    .il2rf_set_b  (1'b0           ),
    .il2rf_data   (r_il2rf_data   ),
    .il2rf_set_pcl(r_il2rf_set_pcl),
    .il2rf_set_pch(r_il2rf_set_pch),
    .il2rf_pushed (1'b0           ),
    .mc2rf_fetched(1'b1           ),
    .mc2rf_pushed (1'b0           ),
    .mc2rf_pull   (1'b0           ),
    .mc2rf_pc     (16'h0000       ),
    .mc2rf_set_pc (1'b0           ),
    .mc2rf_psr    (8'h00          ),
    .mc2rf_set_psr(1'b0           ),
    .rf2mc_pc     (w_rf2mc_pc     ),
    .rf2mc_a      (w_rf2mc_a      ),
    .rf2mc_x      (w_rf2mc_x      ),
    .rf2mc_y      (w_rf2mc_y      ),
    .rf2mc_s      (w_rf2mc_s      ),
    .ec2rf_c      (1'b0           ),
    .ec2rf_set_c  (1'b0           ),
    .ec2rf_i      (1'b0           ),
    .ec2rf_set_i  (1'b0           ),
    .ec2rf_v      (1'b0           ),
    .ec2rf_set_v  (1'b0           ),
    .ec2rf_d      (1'b0           ),
    .ec2rf_set_d  (1'b0           ),
    .ec2rf_n      (1'b0           ),
    .ec2rf_set_n  (1'b0           ),
    .ec2rf_z      (1'b0           ),
    .ec2rf_set_z  (1'b0           ),
    .ec2rf_data   (8'h00          ),
    .ec2rf_set_a  (1'b0           ),
    .ec2rf_set_x  (1'b0           ),
    .ec2rf_set_y  (1'b0           ),
    .ec2rf_set_s  (1'b0           ),
    .ec2rf_set_pcl(1'b0           ),
    .ec2rf_set_pch(1'b0           ),
    .rf2ec_a      (w_rf2ec_a      ),
    .rf2ec_c      (w_rf2ec_c      ),
    .rf2ec_d      (w_rf2ec_d      ),
    .rf2ec_n      (w_rf2ec_n      ),
    .rf2ec_v      (w_rf2ec_v      ),
    .rf2ec_z      (w_rf2ec_z      ));

  always #1 clk = !clk;

  always @ (posedge clk) begin
    if (rst_x) begin
      $display("pc = $%04x", w_rf2mc_pc);
    end
  end

  initial begin
    $dumpfile("RegisterFile.vcd");
    $dumpvars(0, dut);
    clk             <= 1'b0;
    rst_x           <= 1'b0;
    r_il2rf_data    <= 8'h00;
    r_il2rf_set_pcl <= 1'b0;
    r_il2rf_set_pch <= 1'b0;
    #2
    rst_x           <= 1'b1;
    #2
    r_il2rf_data    <= 8'hef;
    r_il2rf_set_pcl <= 1'b1;
    #2
    r_il2rf_data    <= 8'hbe;
    r_il2rf_set_pcl <= 1'b0;
    r_il2rf_set_pch <= 1'b1;
    #2
    r_il2rf_set_pch <= 1'b0;
    #4
    $finish;
  end
endmodule  // RegisterFileTest
