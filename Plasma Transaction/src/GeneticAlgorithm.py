import random
import copy
from operator import attrgetter
from tqdm import tqdm


class GeneticAlgorithm:
    """This class is the naive implementation of genetic algorithm.
    It has built with the help of easyga.
    
    Population : not sorted not calculated cluster of chromosomes
    Generation : sorted and calculated cluster of chromosomes"""

    def __init__(self,
                 genom_size=5,
                 population_size=50,
                 generation_size=50,
                 crossover_probability=0.8,
                 mutation_probability=0.2,
                 elitism_ratio=0.2,
                 crossover_split_ratio=0.5,
                 maximise_fitness=True):

        self.genom_size = genom_size
        self.population_size = population_size
        self.generation_size = generation_size
        self.crossover_probability = crossover_probability
        self.mutation_probability = mutation_probability
        self.elitism_ratio = elitism_ratio
        self.crossover_split_ratio = crossover_split_ratio
        self.maximise_fitness = maximise_fitness

        self.current_generation = []

        self.fitness_function = None
        self.selection_function = self.tournament_selection
        self.is_pre_constraints_satisfied = lambda x: True
        self.tournament_size = 3

        self.history = dict()  # to not calculate same fitness




    def default_fitness_function(self, genes):
        return sum(genes)

    def create_random_genom(self):
        # genom rounded with 2 decimal point precision
        return round(random.random(),2)

    def create_random_chromosome(self):
        """create random individual with the length of genom_size"""
        return Chromosome([self.create_random_genom() for _ in range(self.genom_size)])

    def crossover(self, parent_1, parent_2, where_to_split):
        """takes 2 parents chromosome and returns new two children chromosome"""
        child_1_genes = parent_1.genes[:where_to_split] + parent_2.genes[where_to_split:]
        child_2_genes = parent_2.genes[:where_to_split] + parent_1.genes[where_to_split:]
        return Chromosome(child_1_genes), Chromosome(child_2_genes)

    def mutate(self, chromosome):
        """mutate one genom of chromosome"""
        individual = copy.deepcopy(chromosome)  # copy of individual
        index = random.randrange(self.genom_size)
        individual.genes[index] = self.create_random_genom()
        return Chromosome(individual.genes)

    def tournament_selection(self, population, tournament_size):
        """select individuals with the size of tournament_size
        and return their fittest"""
        tournament_members = random.sample(population, tournament_size)
        tournament_members.sort(key=attrgetter('fitness'), reverse=self.maximise_fitness)

        return tournament_members[0]

    def create_initial_population(self):
        """create initial population and fill self.current_generation object"""
        initial_population = []
        while len(initial_population) < self.population_size:
            individual = self.create_random_chromosome()
            if self.is_pre_constraints_satisfied(individual.genes):
                initial_population.append(individual)
        self.current_generation = initial_population

    def calculate_fitnesses(self):
        """calculate fitnesses of self.current_generation"""
        for individual in tqdm(self.current_generation):
            fitness = self.history.get(tuple(individual.genes), None)
            if fitness is None:  # if individual is newborn then calculate its fitness
                individual.fitness = self.fitness_function(individual.genes, calculate_signal=True)
                self.history[tuple(individual.genes)] = individual.fitness
            else: #otherwise just send do not calculate signal to fitness function
                individual.fitness = self.fitness_function(individual.genes, calculate_signal=False)

    def sort_population(self):
        """sort self.current_generation according to fitnesses"""
        self.current_generation.sort(key=attrgetter('fitness'), reverse=self.maximise_fitness)

    def create_new_population(self):
        """create new population while taking care of constraints
        this function assumes current_generation is already sorted
        1. drop non-elites
        2. while len(new_population) < self.population_size do:
            2.a. select parents
            2.b. create new 2 children
            2.c. maybe crossover
            2.d. maybe mutate
        3. maybe check population for sanity"""

        new_population = []
        # drop non-elites
        elite_size = int(self.population_size * self.elitism_ratio)
        for i in range(elite_size):
            new_population.append(self.current_generation[i])

        while len(new_population) < self.population_size:
            parent_1 = self.selection_function(self.current_generation, self.tournament_size)
            parent_2 = self.selection_function(self.current_generation, self.tournament_size)

            child_1, child_2 = parent_1, parent_2

            if random.random() < self.crossover_probability:
                child_1, child_2 = self.crossover(parent_1=parent_1, parent_2=parent_2,
                                                  where_to_split=int(self.crossover_split_ratio * self.genom_size))

            if random.random() < self.mutation_probability:
                child_1 = self.mutate(child_1)
                child_2 = self.mutate(child_2)

            if self.is_pre_constraints_satisfied(child_1.genes):
                new_population.append(child_1)
            if len(new_population) < self.population_size:
                if self.is_pre_constraints_satisfied(child_2.genes):
                    new_population.append(child_2)

        self.current_generation = new_population

    def create_first_generation(self):
        """ 1. Create the first population
            2. Calculate their fitnesses
            3. Sort them"""

        self.create_initial_population()
        self.calculate_fitnesses()
        self.sort_population()

    def create_next_generation(self):
        """
        1. Create next population
        2. Calculate their fitnesses
        3. Sort population"""

        self.create_new_population()
        self.calculate_fitnesses()
        self.sort_population()

    def run(self):
        """Endless loop to find solution"""

        self.create_first_generation()
        yield self.current_generation

        for iteration in range(self.generation_size):
            self.create_next_generation()
            yield self.current_generation


    def best_individual(self):
        """returns first individual of current generation"""
        return self.current_generation[0]

    def last_generation(self):
        return self.current_generation


class Chromosome:
    def __init__(self, genes):
        self.genes = genes
        self.fitness = 0

    def __repr__(self):
        return repr((self.fitness, self.genes))








if __name__ == "__main__":
    # todo fitness and constraint function should not take chromosome
    ga = GeneticAlgorithm(generation_size=10000,mutation_probability=0.5, maximise_fitness=False, genom_size=2)
    ga.fitness_function = bukin6_function
    # ga.is_pre_constraints_satisfied = is_pre_constraints_satisfied
    ga.run()
    # print(ga.best_individual())
    # actuals = [genom * mul for (genom, mul) in zip(ga.best_individual().genes, [11, 11, 48, 48, 48])]
    best= ga.best_individual().genes
    x1,x2 = best[0],best[1]
    x1 = x1*10 - 15
    x2 = x2*6 - 3
    print(x1,x2)
    # print(actuals)
