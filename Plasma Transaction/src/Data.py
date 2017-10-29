import pandas as pd

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

    def to_series(self):
        df = pd.Series()

        df['f_armature'] = self.f_armature
        df['j'] = self.j
        df['mass'] = self.mass
        df['energy'] = self.energy
        df['Lprime'] = self.Lprime
        df['acc_max'] = self.acc_max
        df['velocity'] = self.velocity

        for (idx,genom) in enumerate(self.genes):
            df['genom_'+str(idx)] = genom

        return df

    def __str__(self):
        return str(self.to_series())
