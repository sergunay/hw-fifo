'''
Example usage:

row_num = np.arange(1, 481)
col_num = np.arange(1, 641)
width = [2, 3, 4, 6, 9, 12, 16]

input_arr = [row_num, col_num, width]

tv = tvgen.TestVector(input_arr, 1, 100)
'''
#-------------------------------------------------------------------------------
import random
import numpy as np
#-------------------------------------------------------------------------------
class TestVector:
#-------------------------------------------------------------------------------
    def __init__(self, input_arr, nb_seq, nb_vecs):
        self.nb_vecs = nb_vecs
        self.nb_seq = nb_seq
        self.vecsize = len(input_arr)
        self.testvecs = []
        for vector_idx in np.arange(nb_vecs):
            vecline = []
            for seq_idx in np.arange(nb_seq):
                for input_element in input_arr:
                    element_idx = random.randrange(len(input_element))
                    vecline.append(input_element[element_idx])
            self.testvecs.append(vecline)
#-------------------------------------------------------------------------------
    def print_tv(self, out_file):
        for vecline in self.testvecs:
            for element in vecline:
                out_file.write("%d " % element)
            out_file.write("\n")
#-------------------------------------------------------------------------------
