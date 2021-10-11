mc6502
======

Cycle accurate MC6502 compatible processor in Verilog.

This is an experimental project, and wasn't verified well.
There will be many bugs and it will not meet practical use requirements.

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
