import pandas as pd

class IterationStorage:
    def __init__(self):
        #store data of each iteration
        self.data = dict()
        self.iteration_num = 0

        self.current_generation = GenerationStorage(iteration_num=self.iteration_num)

        self.dataframe = pd.DataFrame()

    def find_individual(self, genes):
        for (iteration_num, generation) in self.data.items():  # for every iteration/generation
            return generation.find_individual(genes)


    def to_dataframe(self):

        for (iteration_num,generation) in self.data.items(): # for every iteration/generation
            for individual in generation.population: # for every individual
                self.dataframe = self.dataframe.append(individual.to_series(), ignore_index=True)

        return self.dataframe

    def add_individual_to_current_generation(self, individual):
        self.current_generation.population.append(individual)

    def store_generation(self):
        self.data[self.iteration_num] = self.current_generation

    def be_prepared_for_next_generation(self, iteration_num):
        self.iteration_num = iteration_num
        self.current_generation = GenerationStorage(iteration_num=iteration_num)

class GenerationStorage:
    def __init__(self, iteration_num):
        self.iteration_num = iteration_num
        self.population = []

    def find_individual(self, genes):

        for individual in self.population:
            if individual.is_same_with(genes):
                return individual
        return None




class Individual:
    def __init__(self, id, f_armature, j, mass, energy, Lprime, acc_max, velocity, genes):
        self.id = id
        self.f_armature = f_armature
        self.j = j
        self.mass = mass
        self.energy = energy
        self.Lprime = Lprime
        self.acc_max = acc_max
        self.velocity = velocity


        self.genes = genes

    def is_same_with(self,genes):
        if self.genes == genes:
            return True
        print("self:",self.genes)
        print("new: ",genes)
        return False


    def to_series(self):
        df = pd.Series()

        df['id'] = self.id
        for (idx,genom) in enumerate(self.genes):
            df['genom_'+str(idx)] = genom

        df['f_armature'] = self.f_armature
        df['j'] = self.j
        df['mass'] = self.mass
        df['energy'] = self.energy
        df['Lprime'] = self.Lprime
        df['acc_max'] = self.acc_max
        df['velocity'] = self.velocity



        return df

    def __str__(self):
        return str(self.to_series())
