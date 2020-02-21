WORKDIR=work
STOPTIME=1ms

%.wave : hdl/common.vhd hdl/%.vhd sim/%_tb.vhd	
	mkdir -p work
	ghdl -a --workdir=$(WORKDIR) $^
	ghdl -r --workdir=$(WORKDIR) $*_tb --stop-time=$(STOPTIME) --vcd=$@ --assert-level=warning

clean : 
	rm -rf work
	rm *.wave

