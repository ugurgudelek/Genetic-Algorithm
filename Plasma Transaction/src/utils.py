from Data import Individual

class IdGenerator:
    def __init__(self):
        self.current_id = 0

    def __next__(self):
        self.current_id += 1
        return self.current_id - 1



def convert_norm_to_actual(arr):
    r = list(arr)
    r[0] = arr[0] * 11.0
    r[1] = arr[1] * 11.0
    r[2] = arr[2] * 48.0
    r[3] = arr[3] * 48.0
    r[4] = arr[4] * 48.0
    return r

def convert_actual_to_norm(arr):
    r = list(arr)
    r[0] = arr[0] / 11.0
    r[1] = arr[1] / 11.0
    r[2] = arr[2] / 48.0
    r[3] = arr[3] / 48.0
    r[4] = arr[4] / 48.0
    return r

def parse_output(id,fem_output, genes):
    individual = Individual(id, fem_output[0],fem_output[1], fem_output[2],
                            fem_output[3],fem_output[4],fem_output[5],fem_output[6], genes)
    return individual

def normalize(value, maximum, minimum):
    return (value - minimum)/(maximum - minimum)