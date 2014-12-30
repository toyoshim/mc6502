mc6502
======

Cycle accurate MC6502 compatible processor in Verilog.

Directories
-----------

`rtl/`
- MC6502 implementation

`tb/`
- Testbenches that can run with iverilog

`third_party/`
- git submodules, tvcl for simulation models

Run tests
---------

```
$ git submodule update --init
$ cd tb
$ make
```
