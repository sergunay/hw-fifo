Project name  : FIFO   
Release       : 0.0  
Date          : 2020-10-20

General Description
--------------------------------------------------------------------------

A simple FIFO hardware written in VHDL.  
Features:
* Full and Empty flags
* Single and dual clock versions
* Synchronous reset
* Scalable data width, address width and FIFO depth with generics

Directory structure
--------------------------------------------------------------------------

* DOC
  - DOX_HDL : Auto-generated Doxygen documentation

* GHDL
  - Makefile for GHDL simulation

* HDL
  - RTL	: Synthesized RTL codes.
  - BHV	: Behavioral codes.
  - TB	: Testbenches.

* PYTHON
  - Python scripts

* VIVADO
  - BIN    : Binary files
  - CONSTR : Constraint files
  - IMPL   : Implementation files
  - SYNTH  : Synthesis files
  - TCL    : Vivado scripts
  - WORK   : Working directory for TCL based operations

Hardware
--------------------------------------------------------------------------

CMOD-A7 is used for verification. 
* FPGA: Xilinx Artix-7 (XC7A35T-1CPG236C)
* 12 MHz clock
   
Simulation
--------------------------------------------------------------------------

Firstly run `PYTHON/tvgen_fifo.py` to generate random test vectors. 

* Specify number of test vectors: `NB_TVECS = 100`
* Specify the FIFO size: `FIFO_SIZE = 5`
* Test vectors will be generated and saved into `TV_FILE`.

Each line in the generated file has 5 numbers: 
operation ID, push_data, pop_data, empty and full. 
op_id = 0, makes a write request with the 'push_data'. 
If op_id = 1, then it pulls a data and checks 
if it matches with the 'pull_data' in the tv file.
Push and pop operations can also be requested at the same time. 
op_id=2 tests this. 
After each operation, full and empty flags are checked 
if they match with the tv data.

For modelsim simulation:  

1. Copy python generated test vector files into `MSIM/IN`
2. Open `msim/FIFO.mpf`.
3. Open RTL simulation configuration.
4. `run -all`

For GHDL simulation, in GHDL directory:
  * `make`

* This module has a self-checking testbench. If there is no error, its functionality is correct.

Synthesis
--------------------------------------------------------------------------

Vivado in TCL mode:

	cd VIVADO/WORK
	vivado -mode tcl
	source ../TCL/build.tcl

Implementation results:

  - Area        :
  - Slack (MET) :

Programming the FPGA
--------------------------------------------------------------------------

Run program.tcl to program the FPGA:

	vivado -mode tcl
	source ../TCL/program.tcl

Run flash.tcl to program the configuration flash memory:
	
	source ../TCL/flash.tcl
