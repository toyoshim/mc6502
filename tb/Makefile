TESTS	= Accumulator InterruptLogic RegisterFile Shifter \
	Instruction.flags Instruction.ldx Instruction.ldy Instruction.ld \
	Instruction.t Instruction.lda Instruction.ops Instruction.sta \
	Instruction.b Instruction.inc Instruction.dec Instruction.inde \
	Instruction.asl Instruction.shift Instruction.bit Instruction.st \
	Instruction.cp Instruction.stack Instruction.jmp Instruction.brk \
	Instruction.jsr
RESULTS	= $(addsuffix .result, $(TESTS))
FILTER	= grep -v '^VCD info: dumpfile .*\.vcd opened for output\.$$' | \
	grep -v '^WARNING: .*: Not enough words in the file'
FULLSET	= ../rtl/MC6502.v \
	../rtl/MC6502InterruptLogic.v \
	../rtl/MC6502RegisterFile.v \
	../rtl/MC6502ProcessorStatusRegister.v \
	../rtl/MC6502InstructionDecode.v \
	../rtl/MC6502MemoryController.v \
	../rtl/MC6502ExecutionController.v \
	../rtl/MC6502Accumulator.v \
	../rtl/MC6502Shifter.v \
	../third_party/tvcl/ram/simulation/RAM_64Kx8.v \
	../third_party/tvcl/ram/simulation/RAM.v

all: $(RESULTS)

func: Functional.result

clean:
	rm -rf *.result *.diff *.vcd iver

%.result:
	@iverilog -Wall -Wno-timescale -I../rtl -DTEST=\"$*\" -o iver $^ && \
	  ./iver | $(FILTER) > $@
	@diff -c $*.expected $@ > $*.diff; \
	if [ $$? -eq 0 ]; then \
		echo "[ PASS ] $*"; \
	else \
		echo "[ FAIL ] $*"; \
		cat $*.diff; \
	fi \


Accumulator.result: Accumulator.v ../rtl/MC6502Accumulator.v
Shifter.result: Shifter.v ../rtl/MC6502Shifter.v
InterruptLogic.result: InterruptLogic.v ../rtl/MC6502InterruptLogic.v
RegisterFile.result: RegisterFile.v ../rtl/MC6502RegisterFile.v \
		../rtl/MC6502ProcessorStatusRegister.v
Functional.result: Functional.v $(FULLSET)
Instruction.flags.result: Instruction.v $(FULLSET)
Instruction.ldx.result: Instruction.v $(FULLSET)
Instruction.ldy.result: Instruction.v $(FULLSET)
Instruction.ld.result: Instruction.v $(FULLSET)
Instruction.t.result: Instruction.v $(FULLSET)
Instruction.lda.result: Instruction.v $(FULLSET)
Instruction.ops.result: Instruction.v $(FULLSET)
Instruction.sta.result: Instruction.v $(FULLSET)
Instruction.b.result: Instruction.v $(FULLSET)
Instruction.inc.result: Instruction.v $(FULLSET)
Instruction.dec.result: Instruction.v $(FULLSET)
Instruction.inde.result: Instruction.v $(FULLSET)
Instruction.asl.result: Instruction.v $(FULLSET)
Instruction.shift.result: Instruction.v $(FULLSET)
Instruction.bit.result: Instruction.v $(FULLSET)
Instruction.st.result: Instruction.v $(FULLSET)
Instruction.cp.result: Instruction.v $(FULLSET)
Instruction.stack.result: Instruction.v $(FULLSET)
Instruction.jmp.result: Instruction.v $(FULLSET)
Instruction.brk.result: Instruction.v $(FULLSET)
Instruction.jsr.result: Instruction.v $(FULLSET)
