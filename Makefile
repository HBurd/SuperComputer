WORKDIR=work
STOPTIME=1ms

GHDL_FLAGS=--std=08

%.wave : hdl/common.vhd hdl/%.vhd sim/%_tb.vhd	
	mkdir -p work
	ghdl -a $(GHDL_FLAGS) --workdir=$(WORKDIR) $^
	ghdl -r $(GHDL_FLAGS) --workdir=$(WORKDIR) $*_tb --stop-time=$(STOPTIME) --vcd=$@ --assert-level=warning

clean : 
	rm -rf work
	rm *.wave

