from fake_matlab_wrapper import MatlabWrapper
from GeneticAlgorithm import GeneticAlgorithm, Chromosome
from Data import Individual,IterationStorage,GenerationStorage
import utils
from utils import normalize
import pandas as pd
import os

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




def fitness_function(genes):
    genes = convert_norm_to_actual(genes)
    individual = history_dict.get(tuple(genes), None)

    if individual is None:
        fem_output = matlab.fem_function(genes)
        individual = parse_output(fem_output, genes=genes)
        history_dict[tuple(genes)] = individual

    J_crit, J_max, J_min = 4.6e9, 1.24e10, 1e8
    E_max, E_min = 200, 100
    J_norm = normalize(individual.j, J_max, J_min)
    J_crit_norm = normalize(J_crit, J_max, J_min)

    E_norm = normalize(individual.energy, E_max, E_min)

    print(individual)
    return individual.energy

def fitness_function_test(raw_genes, calculate_signal):
    genes = utils.convert_norm_to_actual(raw_genes)

    if calculate_signal:  # call fem to calculate fitness
        fem_output = matlab.fem_function(genes)
        individual = utils.parse_output(id=next(id_generator), fem_output=fem_output, genes=genes)

    else: # find individual from history to save computational time significantly
        individual = iteration_storage.find_individual(genes)

    if individual is None: # should not be
        #todo: it should not be here. fix this case
        print("")
    iteration_storage.add_individual_to_current_generation(individual=individual)


    J_crit, J_max, J_min = 4.6e9, 1.24e10, 1e8
    E_max, E_min = 200, 100
    J_norm = normalize(individual.j, J_max, J_min)
    J_crit_norm = normalize(J_crit, J_max, J_min)

    E_norm = normalize(individual.energy, E_max, E_min)

    print(individual)
    return individual.energy

def update_history_file(history_dict, history_file):
    # todo: fix below line
    if history_file.shape[0] == len(history_dict):
        return history_file

    keys = list(history_dict.keys())
    need_update_keys = keys[history_file.shape[0]:] # only new keys
    for key in need_update_keys:
        history_file = history_file.append(history_dict[key].to_series(), ignore_index=True)

    return history_file

def excel_to_history_dict(history_file, history_dict):
    pass

if __name__ == "__main__":

    # history_filename = 'history_file.xlsx'

    prefix_filename = "../history/iteration_history"
    # matlab handler
    matlab = MatlabWrapper()
    iteration_storage = IterationStorage()
    id_generator = utils.IdGenerator()


    # history_dict = dict()

    # if not os.path.exists(history_filename):
    #     pd.DataFrame().to_excel(history_filename)
    #
    # history_file = pd.read_excel(history_filename)
    #
    # initialize history_dict with history_file


    # genetic algorithm handler
    ga = GeneticAlgorithm(population_size=20,generation_size=20, mutation_probability=0.2, maximise_fitness=True, genom_size=5)
    ga.fitness_function = fitness_function_test
    # define fitness function
    # fitness function saves calculation for each iteration
    # ga.fitness_function = bukin6_function

    # ga.is_pre_constraints_satisfied = is_pre_constraints_satisfied
    for (iteration_num,generation) in enumerate(ga.run()):
        iteration_storage.store_generation()
        iteration_storage.be_prepared_for_next_generation(iteration_num=iteration_num+1)

        iteration_storage.to_dataframe()
        iteration_storage.dataframe.to_csv(prefix_filename+"_"+str(iteration_num), index=False)
        print("Iteraton:",iteration_num)
        # print("Shape:",history_file.shape[0])

        # history_file = update_history_file(history_dict, history_file)
        # history_file.to_excel(history_filename)
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
