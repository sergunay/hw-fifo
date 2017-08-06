import numpy as np
import random
import tvgen
import fifo
#-------------------------------------------------------------------------------
TV_FILE_NAME = "./out/tv.txt"
NB_TVECS = 1000
NB_SEQ = 1
FIFO_SIZE = 5
#-------------------------------------------------------------------------------
TV_FILE = open(TV_FILE_NAME, "w")
#-------------------------------------------------------------------------------
buf = fifo.Fifo(FIFO_SIZE)
#-------------------------------------------------------------------------------
op_id = [0, 1, 2]                   # 0: push, 1:pop, 2:push&pop
op_repeat = np.arange(1, FIFO_SIZE) # nb of consequtive op     
input_arr = [op_id, op_repeat]
tv = tvgen.TestVector(input_arr, 1, NB_TVECS)
#-------------------------------------------------------------------------------
for op in tv.testvecs:
    print("op = %d " % op[0], "repeat = %d" % op[1])
    for rpt_idx in np.arange(op[1]):
        pop_data = -1
        push_data = random.randrange(255)
        print("push data = ", push_data)
        if op[0] == 0:  # 0: push
            print("Pushing data", push_data)
            buf.push(push_data)
        elif op[0] == 1:  # 1: pop
            pop_data = buf.pop()
            print("Pop data = ", pop_data)
            push_data = -1
        elif op[0] == 2:  # 2: push&pop
            pop_data = buf.push_pop(push_data)
        buf.printFifoState()
        TV_FILE.write("%d " % op[0])
        TV_FILE.write("%d " % push_data)
        TV_FILE.write("%d " % pop_data)
        TV_FILE.write("%d " % buf.empty)
        TV_FILE.write("%d \n" % buf.full)
#-------------------------------------------------------------------------------
TV_FILE.close()
#-------------------------------------------------------------------------------
#---------------------------------EOF-------------------------------------------
#-------------------------------------------------------------------------------
