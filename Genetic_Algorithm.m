classdef Genetic_Algorithm < handle
    properties
        chromosome_len;
        population_size;
        crossover_ratio;
        mutation_ratio;
        elitism_ratio;
        chromosome_split;
        iteration_size;
        
        population;
        history;
        variable_history;
        
        chromosome_multiplier;
        chromosome_adder;
        is_constraints_satisfied;
        fitness_function;
        
        
    end
    methods(Static)
        function fitness = hartmann_6(chromosome) 
            %   hartman-6-dim-func
            %   f[0.20169,0.150011,0.476874,0.275332,0.311652,0.6573] =  3.0425
            %
            xx = chromosome;
            alpha = [1.0, 1.2, 3.0, 3.2]';
            A = [10, 3, 17, 3.5, 1.7, 8;
                0.05, 10, 17, 0.1, 8, 14;
                3, 3.5, 1.7, 10, 17, 8;
                17, 8, 0.05, 10, 0.1, 14];
            P = 10^(-4) * [1312, 1696, 5569, 124, 8283, 5886;
                2329, 4135, 8307, 3736, 1004, 9991;
                2348, 1451, 3522, 2883, 3047, 6650;
                4047, 8828, 8732, 5743, 1091, 381];
            
            outer = 0;
            for ii = 1:4
                inner = 0;
                for jj = 1:6
                    xj = xx(jj);
                    Aij = A(ii, jj);
                    Pij = P(ii, jj);
                    inner = inner + Aij*(xj-Pij)^2;
                end
                new = alpha(ii) * exp(-inner);
                outer = outer + new;
            end
            
            y = -(2.58 + outer) / 1.94;
            
            fitness = -y;
        end
        
        function fitness = branin(chromosome)
            
%             f[9.42478,2.475] = 0.397887
%             f[-pi,12.275] = 0.397887
%             f[pi,2.275] = 0.397887
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %
            % INPUTS:
            %
            % xx = [x1, x2]
            % a = constant (optional), with default value 1
            % b = constant (optional), with default value 5.1/(4*pi^2)
            % c = constant (optional), with default value 5/pi
            % r = constant (optional), with default value 6
            % s = constant (optional), with default value 10
            % t = constant (optional), with default value 1/(8*pi)
            %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            x1 = chromosome(1);
            x2 = chromosome(2);

            if (nargin < 7)
                t = 1 / (8*pi);
            end
            if (nargin < 6)
                s = 10;
            end
            if (nargin < 5)
                r = 6;
            end
            if (nargin < 4)
                c = 5/pi;
            end
            if (nargin < 3)
                b = 5.1 / (4*pi^2);
            end
            if (nargin < 2)
                a = 1;
            end

            term1 = a * (x2 - b*x1^2 + c*x1 - r)^2;
            term2 = s*(1-t)*cos(x1);

            y = term1 + term2 + s;
            fitness = -y;
            end

        function [selection,roulette_arr] = roulette( roulette_arr )
            selection = 1;
            if ~isempty(roulette_arr)
                max_of = max(roulette_arr);
                min_of = min(roulette_arr);
                roulette_arr = (roulette_arr - min_of)/((max_of - min_of));
                rand_pnt = rand;
                for i = 1:size(roulette_arr,1)
                    if rand_pnt <= roulette_arr(i)
                        %           i is my selected point
                        selection = i;
                        return
                    end
                end
            end
        end
        
%         function boolAns = is_constraints_satisfied(chromosome, mul, add)
%             %   set predefined contraints
%             chromosome = chromosome .* mul + add;
%             
%             x1 = chromosome(1);
%             x2 = chromosome(2);
%             x3 = chromosome(3);
%             x4 = chromosome(4);
%             x5 = chromosome(5);
%             x6 = chromosome(6);
%             
%             boolAns = (x1 < 0.2) && (x2 < 1);
% 
%         end
        
        
        
    end
    
    methods
%       constructor
        function obj = Genetic_Algorithm(chromosome_len,population_size,crossover_ratio,mutation_ratio,elitism_ratio,chromosome_split,iteration_size,...
                                            fitness_function, chromosome_multiplier, chromosome_adder,constraints_function)
            obj.chromosome_len   = chromosome_len;
            obj.population_size  = population_size;
            obj.crossover_ratio  = crossover_ratio;
            obj.mutation_ratio   = mutation_ratio;
            obj.elitism_ratio    = elitism_ratio;
            obj.chromosome_split = int8(chromosome_len * chromosome_split);
            obj.iteration_size   = iteration_size;
            obj.fitness_function = fitness_function;
                       
%             default argument fix below
            switch nargin
                case 8
                    chromosome_multiplier = ones(1,chromosome_len);
                    chromosome_adder = zeros(1,chromosome_len);
                    constraints_function = @(x)true;
                case 9
                    chromosome_adder = zeros(1,chromosome_len);
                    constraints_function = @(x)true;
                case 10
                    constraints_function = @(x)true;
            end
                    
            obj.is_constraints_satisfied = constraints_function;
            obj.chromosome_multiplier = chromosome_multiplier ;
            obj.chromosome_adder = chromosome_adder ;
            
            obj.population = struct('chromosomes', zeros(population_size,chromosome_len), 'fitnesses', zeros(population_size,1));
            obj.create_population();
        end
    
        
        
        function plot(obj)
            % retrieve fitness_history
            hold on
            iter = size(obj.history.fitness,3);
            fit_hist = obj.history.fitness(1,1,iter);
            plot(iter,fit_hist, '.r');
            title('Fitness history convergence diagram');
            
            fittest_1 = obj.history.chromosome(1,:,max(iter,1));
            fittest_2 = obj.history.chromosome(1,:,max(iter-1,1));
            fittest_3 = obj.history.chromosome(1,:,max(iter-2,1));
            legend(strcat('fitness : ',num2str(fit_hist)),...
                strcat('fittest 1 : ',num2str(fittest_1.*obj.chromosome_multiplier + obj.chromosome_adder)),...
                strcat('fittest 2 : ',num2str(fittest_2.*obj.chromosome_multiplier + obj.chromosome_adder)),...
                strcat('fittest 3 : ',num2str(fittest_3.*obj.chromosome_multiplier + obj.chromosome_adder)),...
                'Location', 'southeast');
            drawnow;
        end
        
        function run(obj)
            obj.calculate_fitnesses()

            for iter = 1:obj.iteration_size
                obj.elitism()
                obj.crossover()
                obj.mutation()
                obj.calculate_fitnesses()
                obj.sort_by_field()
                obj.history.fitness(:,:,iter) = obj.population.fitnesses;
                obj.history.chromosome(:,:,iter) = obj.population.chromosomes;
                obj.plot()
            end
        end
        
        function [] = create_population(obj)
            % create first generation
            for i = 1:obj.population_size
                obj.population.chromosomes(i,:) = obj.create_proper_random_chromosome(obj.chromosome_len, obj.chromosome_multiplier, obj.chromosome_adder);
            end
        end
        
        function [] = calculate_fitnesses(obj)
            %   calculate 
            
            for i = 1:obj.population_size
                [obj.population.fitnesses(i),new_history(i)] = obj.fitness_function(obj.population.chromosomes(i,:) .* obj.chromosome_multiplier + obj.chromosome_adder, obj.variable_history);
            end
            
            obj.variable_history = cat(1,obj.variable_history,new_history);
            
        end
        
        function [] = sort_by_field(obj)
            % sort population struct
            [~, ind]=sort(cell2mat({obj.population.fitnesses}),'descend');
            obj.population.chromosomes=obj.population.chromosomes(ind,:);
            obj.population.fitnesses=obj.population.fitnesses(ind);
        end
        
        function [] = elitism(obj)
            %   elitism
            obj.sort_by_field()
            obj.population.chromosomes = obj.population.chromosomes(1:size(obj.population.chromosomes,1)*obj.elitism_ratio,:);
            obj.population.fitnesses = obj.population.fitnesses(1:size(obj.population.fitnesses,1)*obj.elitism_ratio);
        end
        
        function [] = crossover(obj)
            %   crossover with roulette
            summ = sum(obj.population.fitnesses);
            roulette_arr = zeros(size(obj.population.fitnesses,1),1);
            for i = 1:size(obj.population.fitnesses,1)
                roulette_arr(i) = (sum(obj.population.fitnesses(1:i-1)) + obj.population.fitnesses(i) ) / summ;
            end
            
            prev_pop_cnt = size(obj.population.fitnesses,1);
            next_gen = struct('chromosomes', zeros(obj.population_size - prev_pop_cnt,obj.chromosome_len), 'fitnesses', zeros(obj.population_size - prev_pop_cnt,1));
            
            
            next_mem_count = prev_pop_cnt + 1;
            
            next_gen.chromosomes(1:next_mem_count-1,:) = obj.population.chromosomes;
            next_gen.fitnesses(1:next_mem_count-1,:) = obj.population.fitnesses;
            constraint_check_counter = 0;
            while true
                if rand > (1-obj.crossover_ratio)
                    if  size(roulette_arr,1) > 1 && ~isempty(roulette_arr) % only switch if we can find a pair
                        save_roulette_arr = roulette_arr;
                        [idx_1,roulette_arr] = Genetic_Algorithm.roulette(roulette_arr);
                        roulette_arr = cat(1,roulette_arr(1:idx_1-1),roulette_arr(idx_1+1:size(roulette_arr,1)));
                        [idx_2,roulette_arr] = Genetic_Algorithm.roulette(roulette_arr);
                        roulette_arr = cat(1,roulette_arr(1:idx_2-1),roulette_arr(idx_2+1:size(roulette_arr,1)));
                        
                        chromosome_1 = obj.population.chromosomes(idx_1,:);
                        chromosome_2 = obj.population.chromosomes(idx_2,:);
                        
                        new_chromosome_1 = chromosome_1;
                        new_chromosome_2 = chromosome_2;
                        new_chromosome_1(obj.chromosome_split+1:obj.chromosome_len) = chromosome_2(obj.chromosome_split+1:obj.chromosome_len);
                        new_chromosome_2(obj.chromosome_split+1:obj.chromosome_len) = chromosome_1(obj.chromosome_split+1:obj.chromosome_len);
                        
%                         check contraints. if new chromosomes do not
%                         satisfy then drop them
                        if ~(obj.is_constraints_satisfied(new_chromosome_1 .* obj.chromosome_multiplier + obj.chromosome_adder)...
                                && obj.is_constraints_satisfied(new_chromosome_2 .* obj.chromosome_multiplier + obj.chromosome_adder))
                            roulette_arr = save_roulette_arr; %get untouched roulette array back
                            constraint_check_counter = constraint_check_counter + 1;
%                             if we cannot find proper pair in given
%                             time_check then choose pair randomly
                            if constraint_check_counter > 10
                                new_chromosome_1 = obj.create_proper_random_chromosome(obj.chromosome_len, obj.chromosome_multiplier, obj.chromosome_adder);
                                new_chromosome_2 = obj.create_proper_random_chromosome(obj.chromosome_len, obj.chromosome_multiplier, obj.chromosome_adder);
                            else
                                continue
                            end
                        end
                        
                        constraint_check_counter = 0;
                        next_gen.chromosomes(next_mem_count,:) = new_chromosome_1;
                        next_gen.chromosomes(next_mem_count+1,:) = new_chromosome_2;
                        next_mem_count = next_mem_count + 2;
                        

                    elseif size(roulette_arr,1) == 1 && ~isempty(roulette_arr)
%                         we cannot fill new population properly. Fill
%                         last empty population randomly then.
                        for i = 1:obj.population_size - size(next_gen.chromosomes,1)
                            next_gen.chromosomes(next_mem_count,:) = obj.create_proper_random_chromosome(obj.chromosome_len, obj.chromosome_multiplier, obj.chromosome_adder);
                            next_mem_count = next_mem_count + 1;
                        end
                        roulette_arr = [];
                  
                    else
%                         size of rouletter array is 0 here
                          break
                    end
               
                
                end
            end
            
            obj.population = next_gen;
        end
        
        function [] = mutation(obj)
            %   mutation
            for i = 1:obj.population_size
                for j = 1:obj.chromosome_len
                    if rand > (1-obj.mutation_ratio)
                        mutated = obj.population.chromosomes(i,:);
                        mutated(j) = rand;
%                         loop until mutated is satisfied too
                        while ~obj.is_constraints_satisfied(mutated .* obj.chromosome_multiplier + obj.chromosome_adder)
                            mutated(j) = rand;
                        end
                        obj.population.chromosomes(i,:) = mutated;
     
                    end
                end
            end
        end
        
        function chromosome = create_proper_random_chromosome(obj,chromosome_len, mul, add)
%             create random chromosome
            chromosome = rand(chromosome_len,1)';

%             loop until find
            while ~obj.is_constraints_satisfied(chromosome .* mul + add)
                chromosome = rand(chromosome_len,1)';
            end
                       
        end
        
    end
    
    
end

