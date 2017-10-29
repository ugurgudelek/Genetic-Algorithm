import matlab.engine
import io


class MatlabWrapper:
    def __init__(self):
        shared_sessions = matlab.engine.find_matlab()
        if len(shared_sessions) == 0:
            raise Exception("Open matlab with comsol first!")
        self.eng = matlab.engine.connect_matlab(shared_sessions[0])
        self.out = io.StringIO()
        self.err = io.StringIO()

    def fem_function(self, input_arr):
        # calls wrapper.m file
        # r = self.eng.wrapper(input_arr, stdout=self.out, stderr=self.err)[0]
        r = self.eng.wrapper(input_arr)[0]
        r = list(map(float, r))
        return r
