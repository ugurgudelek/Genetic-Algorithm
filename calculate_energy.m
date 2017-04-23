function [energy, cur_history] = calculate_energy(params, prev_history)

%     if size(params,1) ~= 5
%         'energy params size is not 5. fix this pls'
%     end
%     
    % FEA and Energy Calculation-----------------------------
    x1=params(1);
    x2=params(2);
    %x3=params(3);
    x3=12.5-(x1+x2);
    x4=params(3);
    x5=params(4);
    mass_projectile=params(5);
    
    rail_to_rail=2*(x1+x2+x3);
    
    % do not calculate fitness via comsol, use precalculated values
    if ~isempty(prev_history)
        % find params in prev_history.params
        
        is_params_in_prev_history = arrayfun(@(x) isequal(x.params, params), prev_history);
        
        % get found idx
        [row,col] = find(is_params_in_prev_history == 1);
        if ~isempty(row)
            energy = prev_history(row(1),col(1)).energy;
            cur_history = prev_history(row(1),col(1));
            return
        end
    end
        
    FEA_Result = Farm_FEA(x1,x2,x3,x4,x5,0);
    mass_armature=FEA_Result(1,2);
    acc_peak_armature=FEA_Result(1,1);

    %import sampled current data
    text = '200kJ_I.txt'; %import sampled data
    textdata=importdata(text);

    data_number=size(textdata,1); %find # of data
    data_number=(round(data_number/2)-1)*2;

    current=textdata(1:data_number,2); %save current and time array from the text file
    time=textdata(1:data_number,1);
    peak_current=max(current); %find peak current to control L' from peak force (below)


    Force_max=acc_peak_armature*mass_armature; %maximum force on armature
    Lprime=2*Force_max/(peak_current*peak_current);%L' should be approximately 0.5uH/m

    current_square=(current).*(current); %Force is related with square of current
    peak_current_square=max(current_square);
    waveform=current_square/peak_current_square;%find normalized force and acceleration waveforms
    %plot(time,waveform); %normalized waveform

%     mass_projectile=0.125;
    acc_projectile_peak=Force_max/(mass_armature+mass_projectile); %maximum acceleration of projectile+armature
    acc_waveform=acc_projectile_peak*waveform;%find actual acceleration waveform
    %plot(time,acc_waveform)



    velocity = trapz(time,acc_waveform(1:data_number));

    energy=0.5*(mass_projectile)*velocity*velocity;

    
    
    % save parameters for future
    cur_history.params = params;
    cur_history.mass_armature = mass_armature;
    cur_history.acc_peak_armature = acc_peak_armature;
    cur_history.Lprime = Lprime;
    cur_history.energy = energy;
    cur_history.velocity = velocity;
    cur_history.mass_projectile = mass_projectile;
        
end