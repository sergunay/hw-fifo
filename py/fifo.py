import numpy as np
#-------------------------------------------------------------------------------
class Fifo:
#-------------------------------------------------------------------------------
    def __init__(self, depth):
        self.depth = depth
        self.full = False
        self.empty = True
        self.nb_data = 0
        self.mem = np.zeros(depth, dtype=int)
        self.wr_addr = 0
        self.rd_addr = 0
#-------------------------------------------------------------------------------
    def push(self, in_data):
        if not self.full:
            self.mem[self.wr_addr] = in_data
            self.nb_data += 1
            if self.wr_addr == self.depth-1:
                self.wr_addr = 0
            else:
                self.wr_addr += 1
            if self.wr_addr == self.rd_addr:
                self.full = True
        self.empty = False
#-------------------------------------------------------------------------------
    def pop(self):

        self.full = False
        if not self.empty:
            out_data = self.mem[self.rd_addr]
            self.nb_data -= 1
            if self.rd_addr == self.depth-1:
                self.rd_addr = 0
            else:
                self.rd_addr += 1
            if self.rd_addr == self.wr_addr:
                self.empty = True
        else:
            out_data = -1
        return out_data
#-------------------------------------------------------------------------------
    def push_pop(self, in_data):
        if self.empty:
            out_data = -1
        else:
            out_data = self.mem[self.rd_addr]
            if self.rd_addr == self.depth-1:
                self.rd_addr = 0
            else:
                self.rd_addr += 1

        if not self.full:
            self.mem[self.wr_addr] = in_data
            if self.wr_addr == self.depth-1:
                self.wr_addr = 0
            else:
                self.wr_addr += 1

        self.empty = False
        self.full = False
        return out_data
#-------------------------------------------------------------------------------
    def printFifoState(self):
        print("=== FIFO information ===")
        print("depth = ", self.depth)
        print("full = ", self.full)
        print("empty = ", self.empty)
        print("mem = ", self.mem)
        print("rd addr = ", self.rd_addr)
        print("wr addr = ", self.wr_addr)
        print("nb data = ", self.nb_data)
        print("\n")
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------
