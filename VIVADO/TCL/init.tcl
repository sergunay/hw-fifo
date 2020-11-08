# User variable
set TOP_MODULE fifo_dclk
#-------------------------------------------------------------------------------
set TESTBENCH ${TOP_MODULE}_tb
set TB_GATE_FILE ${TOP_MODULE}_gate_tb.vhd

set RTL_DIR ../../HDL/RTL
set TB_DIR ../../HDL/TB
set BHV_DIR ../../HDL/BHV

set TCL_DIR ../TCL

set PRE_SYNTH_DIR ../PRE_SYNTH
set SYNTH_DIR ../SYNTH
set IMPL_DIR ../IMPL
set CONSTR_DIR ../CONSTR

set VIVADO_PATH /opt/Xilinx/Vivado/2017.2
