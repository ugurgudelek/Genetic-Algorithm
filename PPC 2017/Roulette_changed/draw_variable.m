function [] = draw_variable(which_var)

    object = load('obj.mat');
    object = object.obj;
    param_size = size(object.history.chromosome,2);
    iter_size = size(object.history.chromosome,3);
    population_size = size(object.history.chromosome,1);
    
    
    
    figure
    for j=1:13 %plot first 10
        fittest_ones = reshape(object.history.chromosome(j,:,:),[param_size,iter_size])';
        
%         pick first 40 iteration
        fittest_ones = fittest_ones(1:40,:);
        %apply mul and add part of variables   
        for i=1:40
            fittest_ones(i,:) = fittest_ones(i,:).*object.chromosome_multiplier + object.chromosome_adder;
        end
        hold on
        if j == 1
            plot(fittest_ones(:,which_var),'-r', 'MarkerSize', 9, 'MarkerFaceColor', 'r')
        end
        
        plot(fittest_ones(:,which_var),'ob', 'MarkerSize', 3, 'MarkerFaceColor', 'b')
        
        
    
    end


end