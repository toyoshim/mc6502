// Copyright (c) 2014 Takashi Toyoshima <toyoshim@gmail.com>.
// All rights reserved.  Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

`timescale 1ns/100ps

module InstructionTest;
  reg         clk_50mhz;
  reg         clk_1mhz;
  reg         rst_x;

  reg         r_init;
  reg         r_rdy;
  reg         r_irq_x;
  reg         r_nmi_x;
  reg  [15:0] r_cycle;
  reg  [15:0] r_decode_cycle;
  reg  [15:0] r_decode_pc;

  wire        w_2ram_write_x;
  wire [15:0] w_2ram_addr;
  wire [ 7:0] w_2ram_data;
  wire [ 7:0] w_ram2_data;

  wire [ 7:0] w_dut_db;
  wire        w_dut2_clk1;
  wire        w_dut2_clk2;
  wire        w_dut2_sync;

  wire [15:0] w_dut2_addr;
  wire        w_dut2_write_x;

  integer     i_addr;
  integer     i_data;

  RAM_64Kx8 ram(
      .i_addr    (w_2ram_addr    ),
      .i_enable_x(1'b0           ),
      .i_write_x (w_2ram_write_x ),
      .i_data    (w_2ram_data    ),
      .o_data    (w_ram2_data    ));

  MC6502 dut(
      .clk       (clk_1mhz       ),
      .rst_x     (rst_x          ),
      .i_rdy     (r_rdy          ),
      .i_irq_x   (r_irq_x        ),
      .i_nmi_x   (r_nmi_x        ),
      .io_db     (w_dut_db       ),
      .o_clk1    (w_dut2_clk1    ),
      .o_clk2    (w_dut2_clk2    ),
      .o_sync    (w_dut2_sync    ),
      .o_rw      (w_dut2_write_x ),
      .o_ab      (w_dut2_addr    ));

  assign w_2ram_addr    = r_init ? i_addr[15:0] : w_dut2_addr;
  assign w_2ram_data    = r_init ? i_data[7:0] : w_dut_db;
  assign w_2ram_write_x = r_init ? 1'b0 : w_dut2_write_x;
  assign w_dut_db       = w_dut2_write_x ? w_ram2_data : 8'hzz;

  always #10 clk_50mhz = !clk_50mhz;  // 20ns cycle
  always #500 clk_1mhz = !clk_1mhz;  // 1ms cycle

  always @ (posedge clk_1mhz or negedge rst_x) begin
    if (!rst_x) begin
      r_cycle        <= 16'h0000;
      r_decode_cycle <= 16'h0000;
      r_decode_pc    <= 16'h0000;
    end else begin
      if (!r_init) begin
        r_cycle        <= r_cycle + 16'h0001;
      end
      if (w_dut2_sync) begin
        r_decode_cycle <= r_cycle;
        r_decode_pc    <= { dut.rf.r_pch, dut.rf.r_pcl };
      end
    end
  end

  always @ (posedge clk_1mhz) begin
    if (!r_init) begin
      if (w_dut2_sync) begin
        $display("[%04x]: +%1dt", r_cycle, r_cycle - r_decode_cycle);
        $display({ "[%04x]: *** dump *** PC=$%04x A=$%02x X=$%02x Y=$%02x ",
                   "SP=$%02x NPC=$%04x NV-B_DIZC=%04b_%04b" }, r_cycle,
                   r_decode_pc, dut.rf.r_a, dut.rf.r_x, dut.rf.r_y,
                   dut.rf.r_sp, { dut.rf.r_pch, dut.rf.r_pcl },
                   dut.rf.w_psr[7:4], dut.rf.w_psr[3:0]);
        if (w_ram2_data == 8'hff) begin
          $finish;
        end
      end  // if (w_dut2_sync)

      if (w_2ram_write_x) begin
        $display("[%04x]: $%04x => $%02x", r_cycle, w_dut2_addr, w_ram2_data);
      end else begin
        $display("[%04x]: $%04x <= $%02x", r_cycle, w_dut2_addr, w_2ram_data);
      end  // if (w_2ram_write_x)

      if (w_dut2_sync) begin
        $display("[%04x]: decode: $%02x (%04b_%04b)", r_cycle, w_ram2_data,
                 w_ram2_data[7:4], w_ram2_data[3:0]);
        if (dut.id.w_unknown_instruction) begin
          $display("[%04x]: unknown instruction", r_cycle);
          $finish;
        end
        if ((r_decode_pc != 16'h0000) & (r_decode_pc == dut.w_rf2mc_pc)) begin
          $display("[%04x]: infinite loop", r_cycle);
          $finish;
        end
      end  // if (w_dut2_sync)
    end
  end

  initial begin
    clk_50mhz <= 1'b0;
    clk_1mhz  <= 1'b0;
  end

  initial $readmemb(`TEST, ram.ram.r_ram);

  initial begin
    // Set RESET vector to 16'h0000
    i_addr <= 16'hfffc;
    i_data <= 8'h00;
    #1000
    i_addr <= 16'hfffd;
    i_data <= 8'h00;
    #1000
    r_init <= 1'b0;
  end

  initial begin
    $dumpfile({`TEST, ".vcd"});
    $dumpvars(0, clk_50mhz);
    $dumpvars(0, clk_1mhz);
    $dumpvars(0, r_init);
    $dumpvars(0, ram);
    $dumpvars(0, dut);
    r_rdy   <= 1'b1;
    r_irq_x <= 1'b1;
    r_nmi_x <= 1'b1;
    rst_x   <= 1'b0;
    r_init  <= 1'b1;
    #1000
    while (r_init != 1'b0) begin
      #1000
      rst_x   <= 1'b0;
    end
    rst_x   <= 1'b1;
    #100000
    $finish;
  end
endmodule  // InstructionTest
