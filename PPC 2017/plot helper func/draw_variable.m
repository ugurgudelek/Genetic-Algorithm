function [] = draw_variable(which_param)

% L', velocity, energy, armature_mass
% 1. x1 - param1
% 2. x2 - param2
% 3. x3 = 12.5 - x1 - x2
% 4. x4 - param3
% 5. x5 - param4
% 6. x6 - param5 (et kalýnlýðý)
% 7. projectile_mass - param6


    genetic = load('5-15_genetic.mat');
    genetic = genetic.genetic;
    param_size = size(genetic.history.chromosome,2);
    iter_size = size(genetic.history.chromosome,3);
    population_size = size(genetic.history.chromosome,1);
    
    number_of_chrom_to_draw = 20;
    
    figure
    for j=1:number_of_chrom_to_draw %plot first m
        fittest_ones = reshape(genetic.history.chromosome(j,:,:),[param_size,iter_size])';
        
%         pick first n iteration
        fittest_ones = fittest_ones(1:iter_size,:);
        %apply mul and add part of variables   
        for i=1:size(fittest_ones,1)
            fittest_ones(i,:) = fittest_ones(i,:).*genetic.chromosome_multiplier + genetic.chromosome_adder;
        end
        hold on
        
        % which value of v will be plotted?
        % optimized parameters
        if strcmp(which_param,'x_1')
            y = fittest_ones(:,1);
            ylabel(sprintf('%s (mm)', which_param));
        elseif strcmp(which_param,'x_2')
            y = fittest_ones(:,2);
            ylabel(sprintf('%s (mm)', which_param));

        elseif strcmp(which_param,'x_4')
            y = fittest_ones(:,3);
            ylabel(sprintf('%s (mm)', which_param));
        elseif strcmp(which_param,'x_5')
            y = fittest_ones(:,4);
            ylabel(sprintf('%s (mm)', which_param));
        elseif strcmp(which_param,'x_6')
            y = fittest_ones(:,5);
            ylabel(sprintf('%s (mm)', which_param));
        elseif strcmp(which_param , 'Projectile Mass')
            y = fittest_ones(:,6);
            ylabel(sprintf('%s (mm)', which_param));
        
        % dummy variable
        elseif strcmp(which_param,'x_3')
            x1 = fittest_ones(:,1);
            x2 = fittest_ones(:,2);
            y = 12.5 - x1 - x2;
            ylabel(sprintf('%s (mm)', which_param));
            
        % data from FEM    
        elseif strcmp(which_param , 'Armature Mass')
            y = get_property_value(genetic.variable_history,fittest_ones, 'mass_armature');
            ylabel(sprintf('%s (kg)', which_param));
            
        elseif strcmp(which_param , 'Armature Peak Acceleration')
            y = get_property_value(genetic.variable_history,fittest_ones, 'acc_peak_armature');
            ylabel(sprintf('%s (m/s^2)', which_param));
            
        elseif strcmp(which_param , 'Inductance Gradient')
            y = get_property_value(genetic.variable_history,fittest_ones, 'Lprime');
            ylabel(sprintf('%s (H/m)', which_param));
            
        elseif strcmp(which_param , 'Muzzle Kinetic Energy')
            y = get_property_value(genetic.variable_history,fittest_ones, 'energy');
            ylabel(sprintf('%s (Joule)', which_param));
            
        elseif strcmp(which_param , 'Armature Muzzle Velocity')
            y = get_property_value(genetic.variable_history,fittest_ones, 'velocity');
            ylabel(sprintf('%s (m/s)', which_param));
            
        elseif strcmp(which_param , 'Maximum Pressure')
            y = get_property_value(genetic.variable_history,fittest_ones, 'pressure');
            ylabel(sprintf('%s (Pa)', which_param));

        elseif strcmp(which_param , 'Armature Maximum Repulsive Force')
            y = get_property_value(genetic.variable_history,fittest_ones, 'force_peak_armature');
            ylabel(sprintf('%s (N)', which_param));

        end
        
        
        x = 1:size(y,1);
        a = 1:size(y,1);
        title(sprintf('Change of %s During The Optimization',which_param))
        xlabel('Number of Iteration');
        
        legend('fittest','individual','Location','northwest')
        if j == 1
            plot(y,'-r');
        end
        
            scatter(x,y,a, 'MarkerFaceColor','b', 'MarkerEdgeColor','b',...
                'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2);
    end


end