import matlab.engine

shared_session = matlab.engine.find_matlab()[0]

connected = matlab.engine.connect_matlab(shared_session)

connected.fem_caller([1,1,10.5,1,1])