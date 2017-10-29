import random
class MatlabWrapper:
    def __init__(self):
        pass

    def fem_function(self, input_arr):
        # calls wrapper.m file
        r = [random.random() for _ in range(7)]
        return r