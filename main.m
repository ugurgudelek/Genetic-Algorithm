% DONE : Implement crossover func
%       input  : takes 2 chromosome, crossover_ratio, chromosome_split
%       output : returns new 2 chromosome
% DONE : Implement mutation func
%       input  : takes 1 chromosome, mutation_ratio
%       output : returns new 1 chromosome
% DONE : Implement elitism func
%       input  : takes whole population, ratio
%       output : returns subpopulation
% DONE : Implement roulette func
%       input  : takes whole population
%       output : returns 2 chromosome

chromosome_len   = 2;
population_size  = 100;
crossover_ratio  = 0.95;
mutation_ratio   = 0.05;
elitism_ratio = 0.02;
chromosome_split = 0.5; % must be between [0,1]
iteration_size = 100;

chromosome_multiplier = [15,15];
chromosome_adder = [-5,0];

tic

genetic = Genetic_Algorithm(chromosome_len,population_size,crossover_ratio,mutation_ratio,elitism_ratio,chromosome_split,iteration_size, chromosome_multiplier, chromosome_adder);
genetic.run();

toc

fit_hist = genetic.fitness_history;
plot([1:length(fit_hist)],fit_hist, '.b')
legend(strcat('fitness : ',num2str(fit_hist(length(fit_hist)))), 'Location', 'southeast')

chrom_hist = genetic.chromosome_history;

% scatter(chrom_hist(:,1),chrom_hist(:,2))





%     hold off
%     [x,y] = meshgrid(-10:0.1:10,-10:0.1:10);
%     %x = x - 4;
%     %y = y + 3;
%     z = -((x-4).^2 + (y+3).^2);
%     mesh(x,y,z)
%     hold on
%     genetic.scatter()



