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

chromosome_len   = 6;
population_size  = 100;
crossover_ratio  = 0.95;
mutation_ratio   = 0.05;
elitism_ratio = 0.02;
chromosome_split = 0.5; % must be between [0,1]
iteration_size = 100;

chromosome_multiplier = [1,1,1,1,1,1];
chromosome_adder = [0,0,0,0,0,0];

tic

genetic = Genetic_Algorithm(chromosome_len,population_size,crossover_ratio,mutation_ratio,elitism_ratio,chromosome_split,iteration_size, chromosome_multiplier, chromosome_adder);
genetic.run();

toc

% retrieve fitness_history
fit_hist = genetic.fitness_history;
fig_plot = figure
plot([1:length(fit_hist)],fit_hist, '--or')
title('Fitness history convergence diagram')
legend(strcat('fitness : ',num2str(fit_hist(length(fit_hist)))), 'Location', 'southeast')

% retrieve chromosome_history
chrom_hist = genetic.chromosome_history;
% plot chromosome history according to its weights
chrom_hist_sum = sum(chrom_hist,2);
chrom_hist_weight = zeros(size(sum_chrom_hist));
for i = 1:size(chrom_hist_sum,1)
    chrom_hist_weight(i) = size([find(chrom_hist_sum(i) == chrom_hist_sum)],1);
end

file_str = strcat('plots\plot',datestr(datetime('now')));
file_str = strrep(file_str, ':', '_');
file_str = strrep(file_str, '-', '_');
print(fig_plot,file_str,'-dpng')

fig_scatter = figure
scatter(chrom_hist(:,1),chrom_hist(:,2),chrom_hist_weight*10)
title('Chromosome vs Weight')
xlabel('chromosome 1')
ylabel('chromosome 2')

file_str = strcat('plots\scatter_',datestr(datetime('now')));
file_str = strrep(file_str, ':', '_');
file_str = strrep(file_str, '-', '_');
print(fig_scatter,file_str,'-dpng')



%     hold off
%     [x,y] = meshgrid(-10:0.1:10,-10:0.1:10);
%     %x = x - 4;
%     %y = y + 3;
%     z = -((x-4).^2 + (y+3).^2);
%     mesh(x,y,z)
%     hold on
%     genetic.scatter()



