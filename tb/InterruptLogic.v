// Copyright (c) 2014 Takashi Toyoshima <toyoshim@gmail.com>.
// All rights reserved.  Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

`timescale 100ps/100ps

module InterruptLogicTest;
  reg         clk;
  reg         rst_x;
  reg         r_irq_x;
  reg         r_nmi_x;

  wire [ 7:0] w_mc2il_data;
  wire [15:0] w_il2mc_addr;
  wire        w_il2mc_read;
  wire [ 7:0] w_il2rf_data;
  wire        w_il2rf_set_pcl;
  wire        w_il2rf_set_pch;
  wire        w_il2rf_pushed;

  MC6502InterruptLogic dut(
    .clk          (clk            ),
    .rst_x        (rst_x          ),
    .i_irq_x      (r_irq_x        ),
    .i_nmi_x      (r_nmi_x        ),
    .mc2il_data   (w_mc2il_data   ),
    .mc2il_brk    (1'b0           ),
    .il2mc_addr   (w_il2mc_addr   ),
    .il2mc_read   (w_il2mc_read   ),
    .rf2il_s      (8'h00          ),
    .rf2il_psr    (8'h00          ),
    .rf2il_pc     (16'h0000       ),
    .il2rf_data   (w_il2rf_data   ),
    .il2rf_set_pcl(w_il2rf_set_pcl),
    .il2rf_set_pch(w_il2rf_set_pch),
    .il2rf_pushed (w_il2rf_pushed ));

  always #1 clk = !clk;

  assign w_mc2il_data = 8'h89;

  always @ (posedge clk) begin
    if (rst_x & w_il2mc_read & w_il2rf_set_pcl) begin
      $display("load pcl: $%04x", w_il2mc_addr);
    end
    if (rst_x & w_il2rf_set_pcl) begin
      $display("set pcl: $%02x", w_il2rf_data);
    end
    if (rst_x & w_il2mc_read & w_il2rf_set_pch) begin
      $display("load pch: $%04x", w_il2mc_addr);
    end
    if (rst_x & w_il2rf_set_pch) begin
      $display("set pch: $%02x", w_il2rf_data);
    end
  end

  initial begin
    $dumpfile("InterruptLogic.vcd");
    $dumpvars(0, dut);
    clk     <= 1'b0;
    rst_x   <= 1'b0;
    r_irq_x <= 1'b1;
    r_nmi_x <= 1'b1;
    #2
    rst_x   <= 1'b1;
    #10
    // IRQ and NMI implementation is not correct, but just check the outgoing
    // addresses for now.
    r_irq_x <= 1'b0;
    #2
    r_irq_x <= 1'b1;
    #10
    r_nmi_x <= 1'b0;
    #2
    r_nmi_x <= 1'b1;
    #10
    $finish;
  end
endmodule  // InterruptLogicTest
