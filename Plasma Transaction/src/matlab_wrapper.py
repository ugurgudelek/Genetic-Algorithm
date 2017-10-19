import matlab.engine
import io


class MatlabWrapper:
    def __init__(self):
        self.eng = matlab.engine.start_matlab()
        self.out = io.StringIO()
        self.err = io.StringIO()

    def fem_function(self, input_arr):
        return self.eng.wrapper(input_arr, stdout=self.out, stderr=self.err)[0]
