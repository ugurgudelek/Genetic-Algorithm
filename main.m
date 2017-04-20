close all
chromosome_len   = 5; %x1,x2,x3,x4,x5
population_size  = 100;
crossover_ratio  = 0.95;
mutation_ratio   = 0.05;
elitism_ratio = 0.5;
chromosome_split = 0.5; % must be between [0,1]
iteration_size = 100;


% define fitness function below.
% fitness_function = @(x)Genetic_Algorithm.hartmann_6(x);
fitness_function = @(x,y)calculate_energy(x,y);  % bu bizim enerji veren
% kodumuz

% define contraints below.
% multiplier ve adder a öncelik vermek lazým.
% chromosome_multiplier = [10,10,10,10,10];
% chromosome_adder = [0,0,0,0,0];
% constraints_function = @(x)...
%                             x(1)        > 1 && ... % constraint_1 -- x1    < 0.2
%                             x(1) + x(2) < 10    ... % constraint_2 -- x2+x3 > 0.7
%                             ;
chromosome_len = 6;
chromosome_multiplier = [1,1,1,1,1,1];
chromosome_adder = [0,0,0,0,0,0];
constraints_function = @(x)...
                            x(1) < 0.2 && ...
                            x(1) + x(2) > 0.7 ...
                        ;


tic
% instantiate an onject of Genetic Algorithm
genetic = Genetic_Algorithm(chromosome_len,population_size,crossover_ratio,mutation_ratio,elitism_ratio,chromosome_split,iteration_size,...
                            fitness_function, chromosome_multiplier, chromosome_adder, constraints_function);
                        
% call main method to run all function we have
genetic.run();

toc





% % retrieve fitness_history
% fit_hist = genetic.fitness_history;
% fig_plot = figure
% plot([1:length(fit_hist)],fit_hist, '--or')
% title('Fitness history convergence diagram')
% legend(strcat('fitness : ',num2str(fit_hist(length(fit_hist)))), 'Location', 'southeast')
% 


% file_str = strcat('plots\plot',datestr(datetime('now')));
% file_str = strrep(file_str, ':', '_');
% file_str = strrep(file_str, '-', '_');
% print(fig_plot,file_str,'-dpng')

% % retrieve chromosome_history
% chrom_hist = genetic.chromosome_history;
% % plot chromosome history according to its weights
% chrom_hist_sum = sum(chrom_hist,2);
% chrom_hist_weight = zeros(size(chrom_hist_sum));
% for i = 1:size(chrom_hist_sum,1)
%     chrom_hist_weight(i) = size([find(chrom_hist_sum(i) == chrom_hist_sum)],1);
% end
% 
% fig_scatter = figure
% scatter(chrom_hist(:,1),chrom_hist(:,2),chrom_hist_weight*10)
% title('Chromosome vs Weight')
% xlabel('chromosome 1')
% ylabel('chromosome 2')
% % 
% file_str = strcat('plots\scatter_',datestr(datetime('now')));
% file_str = strrep(file_str, ':', '_');
% file_str = strrep(file_str, '-', '_');
% print(fig_scatter,file_str,'-dpng')



%     hold off
%     [x,y] = meshgrid(-10:0.1:10,-10:0.1:10);
%     %x = x - 4;
%     %y = y + 3;
%     z = -((x-4).^2 + (y+3).^2);
%     mesh(x,y,z)
%     hold on
%     genetic.scatter()






