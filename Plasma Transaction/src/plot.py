import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.pylab import MaxNLocator
import numpy as np
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

def plot(data, which='fitness', unit_func=None, iter_size = 20, title='', xlabel='Number of Iteration', ylabel='', fontsize=30, save_path='../plot', show=False):
    print('Plotting {}...'.format(which))
    fig = plt.figure(figsize=(15.0, 9.0))
    axes = fig.gca()
    for i in range(iter_size):
        bests = get_all_best(data, iter_size=iter_size, which_one=i)[which].values
        if unit_func is not None:
            bests = np.array(list(map(unit_func, bests)))
        sizes = [3*(i+1) for i in range(len(bests))]
        if i == iter_size-1:
            plt.scatter(x=list(range(len(bests))), y=bests, label='individual', c='b', s=sizes, alpha=0.2)
        else:
            plt.scatter(x=list(range(len(bests))), y=bests, c='b', s=sizes, alpha=0.2)

    # plot best line
    bests = get_all_best(data, iter_size=iter_size, which_one=0)[which].values
    if unit_func is not None:
        bests = np.array(list(map(unit_func, bests)))
    plt.plot(bests, c='g', label='fittest')

    #plot critical line
    if which=='j':

        line = plt.plot([4.04e9 if unit_func is None else unit_func(4.04e9)]*len(bests), c='r', label='critical')
        plt.setp(line, linewidth=3)  # set linewidth

    if which == 'P_left' or which == 'P_right':
        line = plt.plot([100e6 if unit_func is None else unit_func(100e6)] * len(bests), c='r', label='critical')
        plt.setp(line, linewidth=3)  # set linewidth


    plt.title(title, fontsize=fontsize)
    plt.xlabel(xlabel, fontsize=fontsize)
    plt.ylabel(ylabel, fontsize=fontsize)
    plt.legend(loc=2, fontsize=20)  # bbox_to_anchor=(1.1, 1.05)

    # set axis to Integer
    axes.get_yaxis().set_major_locator(MaxNLocator(integer=True))
    axes.get_xaxis().set_major_locator(MaxNLocator(integer=True))

    plt.xticks(fontsize=fontsize)
    plt.yticks(fontsize=fontsize)

    # display plot
    if show:
        plt.show()

    fig.savefig(save_path+"/"+which+".png", dpi=fig.dpi)

print(os.getcwd())
history = pd.read_csv('../history/history_sixth_run/iteration_20.csv', index_col=False)
print(history.columns)
plot(history, which='x1',      title=r'$x_1$',                                       ylabel=r'$x_1(mm)$')
plot(history, which='x2',      title=r'$x_2$',                                       ylabel=r'$x_2(mm)$')
plot(history, which='x3',      title=r'$x_3$',                                       ylabel=r'$x_3(mm)$')
plot(history, which='x4',      title=r'$x_4$',                                       ylabel=r'$x_4(mm)$')
plot(history, which='x5',      title=r'$x_5$',                                       ylabel=r'$x_5(mm)$')
plot(history, which='x6',      title=r'$x_6$',                                       ylabel=r'$x_6(mm)$')
plot(history, which='energy',  title='Muzzle Kinetic Energy',                        ylabel='Muzzle Kinetic Energy (kJ)', unit_func=lambda x: x/1e3)
plot(history, which='j',       title='Maximum Current Density on Contact Surface',   ylabel='Current Density (A/$m^2$)')
plot(history, which='Lprime',  title='Inductance Gradient',                          ylabel='Inductance Gradient ($\mu$H/m)', unit_func=lambda x: x*1e6)
plot(history, which='mass',    title='Mass of Armature',                             ylabel='Mass of Armature (g)', unit_func=lambda x: x*1e3)
plot(history, which='P_left',  title='Maximum Pressure on Contact Surface',          ylabel='Pressure (MPa)', unit_func=lambda x: x/1e6)
plot(history, which='P_right', title='Maximum Pressure on Inner Surface',            ylabel='Pressure (MPa)', unit_func=lambda x: x/1e6)
plot(history, which='velocity',title='Velocity',                                     ylabel='Velocity (m/s)')
print()