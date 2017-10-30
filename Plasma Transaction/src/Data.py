import pandas as pd
from utils import convert_norm_to_actual, normalize
class IterationStorage:
    """To store each iteration"""
    def __init__(self):
        #store data of each iteration
        self.data = dict()
        self.iteration_num = 0

        self.current_generation = GenerationStorage(iteration_num=self.iteration_num)

        self.dataframe = pd.DataFrame()

    def find_individual(self, raw_genes):

        # first check current generation
        individual = self.current_generation.find_individual(raw_genes)
        if individual is not None:
            return individual

        # if individual could not find in current generation then look for history
        for (iteration_num, generation) in self.data.items():  # for every iteration/generation
            individual =  generation.find_individual(raw_genes)
            if individual is not None:
                return individual
        return None


    def to_dataframe(self):

        self.dataframe = pd.DataFrame()
        for (iteration_num,generation) in self.data.items(): # for every iteration/generation
                self.dataframe = self.dataframe.append(generation.to_dataframe(), ignore_index=True)

        return self.dataframe

    def add_individual_to_current_generation(self, individual):
        self.current_generation.population.append(individual)

    def store_generation(self):
        self.data[self.iteration_num] = self.current_generation

    def be_prepared_for_next_generation(self, iteration_num):
        self.iteration_num = iteration_num
        self.current_generation = GenerationStorage(iteration_num=iteration_num)



class GenerationStorage:
    """To store each generation"""
    def __init__(self, iteration_num):
        self.iteration_num = iteration_num
        self.population = []



    def find_individual(self, raw_genes):

        for individual in self.population:
            if individual.is_same_with(raw_genes):
                return individual
        return None

    def to_dataframe(self):
        dataframe = pd.DataFrame()
        for individual in self.population:  # for every individual
            dataframe = dataframe.append(individual.to_series(), ignore_index=True)

        dataframe['iteration_num'] = len(self.population) * [self.iteration_num]
        return dataframe

def parse_output(id, fem_output, raw_genes):
    individual = Individual(id, fem_output[0], fem_output[1], fem_output[2],
                            fem_output[3], fem_output[4], fem_output[5], fem_output[6], raw_genes)
    return individual

class Individual:
    """individual signature of FEM model"""
    def __init__(self, id, f_armature, j, mass, energy, Lprime, acc_max, velocity, raw_genes):
        self.id = id
        self.f_armature = f_armature
        self.j = j
        self.mass = mass
        self.energy = energy
        self.Lprime = Lprime
        self.acc_max = acc_max
        self.velocity = velocity

        J_CRITICAL, J_MAX, J_MIN = 4.6e9, 1.24e10, 0
        E_MAX, E_MIN = 1.4e7, 0
        def calculate_inner_attributes(j, energy):
            J_norm = normalize(j, J_MAX, J_MIN)
            J_crit_norm = normalize(J_CRITICAL, J_MAX, J_MIN)
            E_norm = normalize(energy, E_MAX, E_MIN)
            fitness = energy - max(0, (J_norm - J_crit_norm))

            return J_norm, J_crit_norm, E_norm, fitness

        self.J_norm, self.J_crit_norm, self.E_norm, self.fitness = calculate_inner_attributes(self.j, self.energy)
        self.raw_genes = raw_genes
        self.genes = convert_norm_to_actual(raw_genes)



    def is_same_with(self,raw_genes):
        if self.raw_genes == raw_genes:
            return True
        return False


    def to_series(self):
        df = pd.Series()

        df['id'] = self.id
        for (idx,genom) in enumerate(self.raw_genes):
            df['genom_'+str(idx)] = genom

        df['x1'] = self.genes[0]
        df['x2'] = self.genes[1]
        df['x3'] = 12.5 - self.genes[0] - self.genes[1]
        df['x4'] = self.genes[2]
        df['x5'] = self.genes[3]
        df['x6'] = self.genes[4]

        df['f_armature'] = self.f_armature
        df['j'] = self.j
        df['mass'] = self.mass
        df['energy'] = self.energy
        df['Lprime'] = self.Lprime
        df['acc_max'] = self.acc_max
        df['velocity'] = self.velocity

        df['J_norm'],df['J_crit_norm'],df['E_norm'],df['fitness']= self.J_norm, self.J_crit_norm, self.E_norm, self.fitness



        return df

    def __str__(self):
        return str(self.to_series())
