# SuperComputer

This is a VHDL implementation of a simple processor built as a class project.

## Generating a Vivado project

To create a Vivado project, open Vivado, and run

```
source SuperComputer.tcl
```

in the TCL command prompt.

## Building and using GHDL

To install GHDL on Ubuntu/whatever, you need an Ada compiler.

```
apt install gnat
```

Now clone, build, and install GHDL.

```
git clone https://github.com/ghdl/ghdl
cd ghdl
mkdir build
./configure
make
make install
```

Install GTKWave for viewing wave outputs.

```
apt install gtkwave
```

To run a module's testbench, say the ALU, use

```
make alu.wave
```

This elaborates and runs `alu.vhd`, `alu_tb.vhd`, and any common library files.
Waves are output to `alu.vhd`. We can view them by running

```
gtkwave alu.wave
```
