from matlab_wrapper import MatlabWrapper
from GeneticAlgorithm import GeneticAlgorithm, Chromosome
from Data import Individual

def is_pre_constraints_satisfied(genes):
    genes = convert_norm_to_actual(genes)
    x1, x2, x4, x5, x6 = genes[0], genes[1], genes[2], genes[3], genes[4]



    if x1 < 1 or x2 < 1 or x4 < 1 or x5 < 1 or x6 < 1:
        # create new chromosome
        return False

    if x1 + x2 > 11.5:
        # create new chromosome
        return False

    if x4 + x5 + x6 > 50:
        # create new chromosome
        return False

    return True

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

def parse_output(fem_output, genes):
    individual = Individual(fem_output[0],fem_output[1], fem_output[2],
                            fem_output[3],fem_output[4],fem_output[5],fem_output[6], genes)
    return individual

def normalize(value, maximum, minimum):
    return (value - minimum)/(maximum - minimum)

history = dict()
def fitness_function(genes):
    genes = convert_norm_to_actual(genes)
    individual = history.get(tuple(genes), None)

    if individual is None:
        fem_output = matlab.fem_function(genes)
        individual = parse_output(fem_output, genes=genes)
        history[tuple(genes)] = individual

    J_crit, J_max, J_min = 4.6e9, 1.24e10, 1e8
    E_max, E_min = 200,100
    J_norm = normalize(individual.j, J_max, J_min)
    J_crit_norm = normalize(J_crit, J_max, J_min)

    E_norm = normalize(individual.energy, E_max, E_min)
    return individual.energy
# matlab handler
matlab = MatlabWrapper()
if __name__ == "__main__":



    # genetic algorithm handler
    ga = GeneticAlgorithm(generation_size=20, mutation_probability=0.1, maximise_fitness=True, genom_size=5)
    ga.fitness_function = fitness_function
    # define fitness function
    # fitness function saves calculation for each iteration
    # ga.fitness_function = bukin6_function

    ga.is_pre_constraints_satisfied = is_pre_constraints_satisfied
    for generation in ga.run():
        print(history.get(tuple(ga.best_individual().genes),0))
    # print(ga.best_individual())
    # actuals = [genom * mul for (genom, mul) in zip(ga.best_individual().genes, [11, 11, 48, 48, 48])]
    best = ga.best_individual()
    print(best)




# *GRAPHS and HISTORY Info:*
#     For the control during the computation, create the graph of change of the fittest individual's:
# 1) Farm_max value (comes from FEA)
# 2) Armature mass value (comes from FEA)
# 3) Energy value (comes from Energy_Calc function)
# 4) Maximum current density value on the surface between armature and and rail (comes from FEA)
#
#     For the history of the optimization,save all individual's:
# 1) Farm_max value (comes from FEA)
# 2) Armature mass value (comes from FEA also)
# 3) Energy value (comes from Energy_Calc function)
# 4) Maximum current density value on the surface between armature and and
# rail (comes from FEA)
# 5) Velocity value (comes from Energy_Calc function)
# 6) Lprime value (comes from Energy_Calc function)
# 7) x1,x2,x3,x4,x5, and x6 geometric independent variables
# 8) Peak acceleration (comes from Energy_Calc function)
