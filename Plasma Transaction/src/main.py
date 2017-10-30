from matlab_wrapper import MatlabWrapper
from GeneticAlgorithm import GeneticAlgorithm, Chromosome
from Data import IterationStorage, parse_output

from utils import normalize, convert_norm_to_actual
import utils
import pandas as pd
import os
from operator import attrgetter
import math

import matplotlib.pyplot as plt

def is_pre_constraints_satisfied(raw_genes):
    genes = convert_norm_to_actual(raw_genes)
    x1, x2, x4, x5, x6 = genes[0], genes[1], genes[2], genes[3], genes[4]



    if x1 < 1 or x2 < 1 or x4 < 5 or x5 < 5 or x6 < 5:
        # create new chromosome
        return False

    if x1 + x2 > 11.5:
        # create new chromosome
        return False

    if x4 + x5 + x6 > 50:
        # create new chromosome
        return False

    return True

def fitness_function(raw_genes, calculate_signal):

    if calculate_signal:  # call fem to calculate fitness
        fem_output = matlab.fem_function(convert_norm_to_actual(raw_genes))
        individual = parse_output(id=next(id_generator), fem_output=fem_output, raw_genes=raw_genes)

    else: # find individual from history to save computational time significantly
        individual = iteration_storage.find_individual(raw_genes)

    if individual is None: # should not be
        raise Exception("You could be here. Individuals could not found in iteration storage history!")


    iteration_storage.add_individual_to_current_generation(individual=individual)


    print(individual)
    return individual.fitness

def plot_best(iteration_storage):

    f_armatures, masses, energies, Js = [],[],[],[]
    for (iteration_num, generation) in iteration_storage.data.items():
        sorted_population = sorted(generation.population, key=attrgetter('fitness'), reverse=True)
        fittest = sorted_population[-1]
        f_armatures.append(fittest.f_armature)
        masses.append(fittest.mass)
        energies.append(fittest.energy)
        Js.append(fittest.j)

    x = list(range(len(f_armatures)))
    # plt.scatter(x=x,y=f_armatures)
    # plt.scatter(x=x,y=masses)
    # plt.scatter(x=x,y=energies)
    # plt.scatter(x=x,y=Js)

    matlab.eng.scatter(x,f_armatures)

def sphere_function(xx, calculate_signal):

    d = len(xx)
    sum = 0
    for ii in range(d):
        xi = xx[ii]
        sum += (xi ** 2)
    return sum


def bukin6_function(xx, calculate_signal):
    x1,x2 = xx[0],xx[1]
    x1 = x1*10 - 15
    x2 = x2*6 - 3

    term1 = 100 * math.sqrt(abs(x2 - 0.01 * (x1 ** 2)))
    term2 = 0.01 * abs(x1 + 10)

    y = term1 + term2

    return y
    




if __name__ == "__main__":

    # history_filename = 'history_file.xlsx'

    prefix_filename = "../history/iteration_history"
    if not os.path.exists("../history"):
        os.makedirs("../history")

    # matlab handler
    matlab = MatlabWrapper()
    iteration_storage = IterationStorage()
    id_generator = utils.IdGenerator()


    # genetic algorithm handler
    ga = GeneticAlgorithm(population_size=20,generation_size=20,
                          mutation_probability=0.3, maximise_fitness=True, genom_size=5)

    # define fitness function
    ga.fitness_function = fitness_function

    ga.is_pre_constraints_satisfied = is_pre_constraints_satisfied

    for (iteration_num, generation) in enumerate(ga.run()):
        iteration_storage.store_generation()
        iteration_storage.be_prepared_for_next_generation(iteration_num=iteration_num+1)

        iteration_storage.to_dataframe()
        iteration_storage.dataframe.to_csv(prefix_filename+"_"+str(iteration_num)+".csv", index=False)


        print("Iteration:",iteration_num)
        print(ga.best_individual())


# todo:
# *GRAPHS and HISTORY Info:*
#     For the control during the computation, create the graph of change of the fittest individual's:
# 1) Farm_max value (comes from FEA)
# 2) Armature mass value (comes from FEA)
# 3) Energy value (comes from Energy_Calc function)
# 4) Maximum current density value on the surface between armature and and rail (comes from FEA)

