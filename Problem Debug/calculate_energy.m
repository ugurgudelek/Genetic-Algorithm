function [cur_history] = calculate_energy(params, var_history)

    % FEA and Energy Calculation-----------------------------
    x1=params(1);
    x2=params(2);
    %x3=params(3);
    x3=12.5-(x1+x2);
    x4=params(3);
    x5=params(4);
    x6=params(5);
    mass_projectile=params(6);
    bombe=params(7);
    
    rail_to_rail=2*(x1+x2+x3);
    
    % do not calculate fitness via comsol, use precalculated values
    if isKey(var_history,num2str(params))
        cur_history = var_history(num2str(params));
        energy = cur_history.energy;
        pressure = cur_history.pressure;
    else
        %     FEA_Result = FEM_t_1mj_pressure_friction2(x1,x2,x3,x4,x5,x6,bombe,0);
        % % 1)F_armature, 2)Pressure, 3)F_rail 4)Fcontact_from_armature_volume 5)Fcontact_from_armature_boundary 6) mass
        %     mass_armature=FEA_Result(1,6);
        %     pressure=FEA_Result(1,2);
        %     force_peak_armature=FEA_Result(1,1); %maximum force on armature
        mass_armature=rand/5;
        pressure=rand*60e6 + 100e6;
        force_peak_armature=rand*100e3;
 

        %import sampled current data
        text = '1mJ.txt'; %import sampled data
        textdata=importdata(text);
        data_number=size(textdata,1); %find # of data
        data_number=(round(data_number/2)-1)*2;
        current=textdata(1:data_number,2); %save current and time array from the text file
        time=textdata(1:data_number,1);
        %time=time.*1e-6;

        peak_current=max(current); %find peak current to control L' from peak force (below)



        Lprime=2*force_peak_armature/(peak_current*peak_current);%L' should be approximately 0.5uH/m

        current_square=(current).*(current); %Force is related with square of current
        peak_current_square=max(current_square);
        waveform=current_square/peak_current_square;%find normalized force and acceleration waveforms
        %plot(time,waveform); %normalized waveform

    %     mass_projectile=0.125;
        acc_projectile_peak=force_peak_armature/(mass_armature+mass_projectile); %maximum acceleration of projectile+armature
        acc_waveform=acc_projectile_peak*waveform;%find actual acceleration waveform
        %plot(time,acc_waveform)

        velocity = trapz(time,acc_waveform(1:data_number));

        energy=0.5*(mass_projectile)*velocity*velocity;
        
        
            % save parameters for future
        cur_history.params = params;
        cur_history.mass_armature = mass_armature;
        cur_history.acc_peak_armature = acc_projectile_peak;
        cur_history.Lprime = Lprime;
        cur_history.energy = energy;
        cur_history.velocity = velocity;
        cur_history.mass_projectile = mass_projectile;

        cur_history.pressure = pressure;
        cur_history.force_peak_armature = force_peak_armature;

        cur_history.fitness = energy;
        
    end
      

        
end



    
