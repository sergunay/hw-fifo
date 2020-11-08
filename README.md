Project name  : FIFO   
Release       : 0.0  
Date          : 2020-10-20

General Description
--------------------------------------------------------------------------

A simple FIFO hardware written in VHDL.  
Features:
* Full and Empty flags
* Single and dual clock versions

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

1. **PYTHON:**
  * Run `py/tvgen_fifo.py` to generate random test vectors.
    * Specify number of test vectors: `NB_TVECS = 100`
    * Specify the FIFO size: `FIFO_SIZE = 5`
    * Test vectors will be generated and saved into `TV_FILE`.
2. Copy python generated test vector files into `msim/in`
3. **MODELSIM:** 
  * Open `msim/FIFO.mpf`.
  * Open RTL simulation configuration.
  * `run -all`
4. **GHDL:** 
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
