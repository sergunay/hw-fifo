FIFO implementation with Empty and Full control signals.

## Steps to test the design:

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

## HDL design documentation:
1. Run `doxygen` in `doc/hdl` directory
2. Open `doc/hdl/html/index.html`
