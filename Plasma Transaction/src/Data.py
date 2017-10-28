

class DataHolder:
    def __init__(self):
        #hold data of each iteration
        self.data = dict()
        self.current_generation = Generation(0)


    def add_individual_to_current_generation(self, individual):
        self.current_generation.population.append(individual)

    def save_generation(self, iteration_num):
        self.data[iteration_num] = self.current_generation

class Generation:
    def __init__(self, iteration_num):
        self.iteration_num = iteration_num
        self.population = []


class Individual:
    def __init__(self, f_armature, j, mass, energy, Lprime, acc_max, velocity, genes):
        self.f_armature = f_armature
        self.j = j
        self.mass = mass
        self.energy = energy
        self.Lprime = Lprime
        self.acc_max = acc_max
        self.velocity = velocity


        self.genes = genes