import pandas as pd
import matplotlib.pyplot as plt
import os


def get_one_iteration_data(data, iter_num):
    return data.loc[data.iteration_num == iter_num]

def sort_by(data, by='fitness'):
    return data.sort_values(by=by, ascending=False)

def get_all_best(data, iter_size=20, which_one=0):
    bests = pd.DataFrame()
    for iter_num in range(iter_size):
        iter_data = get_one_iteration_data(data, iter_num)
        iter_data = sort_by(iter_data, 'fitness')
        bests = bests.append(iter_data.iloc[which_one], ignore_index=True)
    return bests

def plot(data, which='fitness', iter_size = 20):
    for i in range(20):
        bests = get_all_best(data, iter_size=20, which_one=i)[which].values
        plt.scatter(x= list(range(len(bests))), y=bests, label=i)
        plt.legend(bbox_to_anchor=(1.1, 1.05))
    bests = get_all_best(data, iter_size=20, which_one=0)[which].values
    plt.plot(bests)
    plt.title(which)
    plt.show()

print(os.getcwd())
history = pd.read_csv('../history/history_fifth_run/iteration_20.csv')
print(history.columns)
plot(history, which='x2', iter_size=20)
print()