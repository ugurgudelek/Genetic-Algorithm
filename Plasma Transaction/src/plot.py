import pandas as pd
import matplotlib.pyplot as plt


def get_one_iteration_data(data, iter_num):
    return data.loc[data.iteration_num == iter_num]

def sort_by(data, by='fitness'):
    return data.sort_values(by=by, ascending=False)

def get_all_best(data, iter_size=20):
    bests = pd.DataFrame()
    for iter_num in range(iter_size):
        iter_data = get_one_iteration_data(data, iter_num)
        iter_data = sort_by(iter_data, 'fitness')
        bests = bests.append(iter_data.iloc[0], ignore_index=True)
    return bests

def plot(data, iter_size = 20):
    pass

history = pd.read_csv('../history/iteration_history_20.csv')

print()