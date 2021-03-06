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
        fitness_history;
        chromosome_history;
        
        chromosome_multiplier;
        chromosome_adder;
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
            
        
        function fitness = fitness_func( chromosome, mul, add )
            
            

            
            corr_chroms = chromosome .* mul + add;
            
% FEA and Energy Calculation-----------------------------
x1=corr_chroms(1);
x2=corr_chroms(2);
x3=corr_chroms(3);
x4=corr_chroms(4);
x5=corr_chroms(5);
FEA_Result = Farm_FEA(x1,x2,x3,x4,x5,0);
mass=FEA_Result(1,2);
acc_peak=FEA_Result(1,1);
%acc_peak=acc_peak*mass/0.125; %�nceki analizlerde 0.125kg mass alm??t?m,
%80m/s �?km??t? onu g�rmek i�in bunu ekledim 71m/s �?kt?.

%import sampled current data
text = '200kJ_I.txt'; %import sampled data
textdata=importdata(text);

data_number=size(textdata,1); %find # of data
data_number=(round(data_number/2)-1)*2;

current=textdata(1:data_number,2); %save current and time array from the text file
time=textdata(1:data_number,1);
peak_current=max(current); %find peak current to control L' from peak force (below)


Force_max=acc_peak*mass;
Lprime=2*Force_max/(peak_current*peak_current);%L' should be approximately 0.5uH/m

current_square=(current).*(current); %Force is related with square of current
peak_current_square=max(current_square);
waveform=current_square/peak_current_square;%find normalized force and acceleration waveforms
%plot(time,waveform); %normalized waveform

acc_waveform=acc_peak*waveform;%find actual acceleration waveform
plot(time,acc_waveform)


 
velocity = trapz(time,acc_waveform(1:data_number));

energy=0.5*mass*velocity*velocity;


            fitness = energy;

            
            
            
            
            %             fitness = -((x-4).^2 + (y+3).^2);
            %             fitness = -(0.26*(x.^2 + y.^2)- 0.48*x.*y + 32);
            %             fitness = -(-cos(x)*cos(y)*exp(-((x-pi)^2 + (y-pi)^2)));
            
            %
            %             fact1a = (x1 + x2 + 1)^2;
            %             fact1b = 19 - 14*x1 + 3*x1^2 - 14*x2 + 6*x1*x2 + 3*x2^2;
            %             fact1 = 1 + fact1a*fact1b;
            %
            %             fact2a = (2*x1 - 3*x2)^2;
            %             fact2b = 18 - 32*x1 + 12*x1^2 + 48*x2 - 36*x1*x2 + 27*x2^2;
            %             fact2 = 30 + fact2a*fact2b;
            %
            %             fitness = - fact1*fact2;
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
        
        
    end
    
    methods
        function obj = Genetic_Algorithm(chromosome_len,population_size,crossover_ratio,mutation_ratio,elitism_ratio,chromosome_split,iteration_size,chromosome_multiplier, chromosome_adder)
            obj.chromosome_len   = chromosome_len;
            obj.population_size  = population_size;
            obj.crossover_ratio  = crossover_ratio;
            obj.mutation_ratio   = mutation_ratio;
            obj.elitism_ratio    = elitism_ratio;
            obj.chromosome_split = chromosome_len * chromosome_split;
            obj.iteration_size   = iteration_size;
            obj.chromosome_history = zeros(population_size, chromosome_len);
            
            obj.chromosome_multiplier = chromosome_multiplier ;
            obj.chromosome_adder = chromosome_adder ;
            
            obj.population = struct('chromosomes', zeros(population_size,chromosome_len), 'fitnesses', zeros(population_size,1));
            obj.create_population();
        end
        
        
        function [] = scatter(obj)
            chroms = obj.population.chromosomes;
            fits   = obj.population.fitnesses;
            scatter3(chroms(:,1),chroms(:,2),fits,'.r');
            %             scatter3(chromosome(1,1),chromosome(1,2),fitness);
            %             for i = 1:obj.population_size
            %                 chromosome = obj.population.chromosomes(i,:);
            %                 fitness = obj.population.fitnesses(i);
            %                 scatter3(chromosome(1,1),chromosome(1,2),fitness);
            %             end
        end
        
        function plot(obj)
            % retrieve fitness_history
            hold on
            fit_hist = obj.fitness_history;
            plot([1:length(fit_hist)],fit_hist, '--or');
            title('Fitness history convergence diagram');
            fittest_chrom = obj.population.chromosomes(1,:);
            legend(strcat('fitness : ',num2str(fit_hist(length(fit_hist)))),...
                strcat('fittest : ',num2str(fittest_chrom)),...
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
                obj.fitness_history(iter) = obj.population.fitnesses(1);
                obj.chromosome_history(iter,:) = obj.population.chromosomes(1,:);
                obj.plot()
            end
        end
        
        function [] = create_population(obj)
            % create first generation
            for i = 1:obj.population_size
                obj.population.chromosomes(i,:) = rand(obj.chromosome_len,1)';
            end
        end
        
        function [] = calculate_fitnesses(obj)
            %   calculate fitnesses
            for i = 1:obj.population_size
                obj.population.fitnesses(i) = Genetic_Algorithm.fitness_func(obj.population.chromosomes(i,:), obj.chromosome_multiplier, obj.chromosome_adder);
            end
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
            obj.population.chromosomes = obj.population.chromosomes(1:size(obj.population.chromosomes,1)/2,:);
            obj.population.fitnesses = obj.population.fitnesses(1:size(obj.population.fitnesses,1)/2);
        end
        
        function [] = crossover(obj)
            %   crossover with roulette
            summ = sum(obj.population.fitnesses);
            roulette_arr = zeros(size(obj.population.fitnesses,1),1);
            for i = 1:size(obj.population.fitnesses,1)
                roulette_arr(i) = (sum(obj.population.fitnesses(1:i-1)) + obj.population.fitnesses(i) ) / summ;
            end
            
            next_gen = struct('chromosomes', zeros(obj.population_size,obj.chromosome_len), 'fitnesses', zeros(obj.population_size,1));
            
            mem_cnt = size(obj.population.fitnesses,1) + 1;
            
            next_gen.chromosomes(1:mem_cnt-1,:) = obj.population.chromosomes;
            next_gen.fitnesses(1:mem_cnt-1,:) = obj.population.fitnesses;
            while true
                if rand > (1-obj.crossover_ratio)
                    if  size(roulette_arr,1) > 1
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
                        
                        next_gen.chromosomes(mem_cnt,:) = new_chromosome_1;
                        next_gen.chromosomes(mem_cnt+1,:) = new_chromosome_2;
                        mem_cnt = mem_cnt + 2;
                        
                        if isempty(roulette_arr)
                            break
                        end
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
                        obj.population.chromosomes(i,j) = rand;
                    end
                end
            end
        end
    end
    
    
end

