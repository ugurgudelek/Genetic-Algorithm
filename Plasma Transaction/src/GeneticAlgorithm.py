import random
import copy
from operator import attrgetter


class GeneticAlgorithm:
    def __init__(self,
                 genom_size=4,
                 population_size=50,
                 generation_size=50,
                 crossover_probability=0.8,
                 mutation_probability=0.2,
                 maximise_fitness=True):
        self.genom_size = genom_size
        self.population_size = population_size
        self.generation_size = generation_size
        self.crossover_probability = crossover_probability
        self.mutation_probability = mutation_probability
        self.maximise_fitness = maximise_fitness

        self.current_generation = []

        self.fitness_function = None

    def create_random_individual(self):
        """create random individual with the length of genom_size"""
        return [random.random() for _ in range(self.genom_size)]

    def crossover(self, parent_1, parent_2, where_to_split):
        "create new two children"
        child_1 = parent_1[:where_to_split] + parent_2[where_to_split:]
        child_2 = parent_2[:where_to_split] + parent_1[where_to_split:]
        return child_1, child_2

    def mutate(self, individual):
        """mutate one individual"""
        individual = list(individual)  # copy of individual
        index = random.randrange(self.genom_size)
        individual[index] = random.random
        return individual

    def tournament_selection(self, population, tournament_size):

        tournament_members = random.sample(population, tournament_size)
        tournament_members.sort(key=attrgetter('fitness'))

        return tournament_members[0]



if __name__ == "__main__":
    ga = GeneticAlgorithm()
    pop = []

