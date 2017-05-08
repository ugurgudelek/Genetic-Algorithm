    x1=1;
    x2=2;
    %x3=params(3);
    x3=12.5-(x1+x2);
    x4=10;
    x5=10;
    x6=1;
    mass_projectile=0.3;
    bombe=5;
    rail_to_rail=2*(x1+x2+x3);

        
    FEA_Result = FEM_t_1mj_pressure_friction2(x1,x2,x3,x4,x5,x6,bombe,1);
    
   % 1)F_armature, 2)Pressure, 3)F_rail 4)Fcontact_from_armature_volume 5)Fcontact_from_armature_boundary 6) mass
    mass_armature=FEA_Result(1,6);
    Pressure=FEA_Result(1,2);
    force_peak_armature=FEA_Result(1,1); %maximum force on armature

    %import sampled current data
    text = '1mJ.txt'; %import sampled data
    textdata=importdata(text);
%     data_number=size(textdata.data,1); %find # of data
%     data_number=(round(data_number/2)-1)*2;
%     current=textdata.data(1:data_number,2); %save current and time array from the text file
%     time=textdata.data(1:data_number,1);
    %time=time.*1e-6;
    time=textdata(:,1);
    current=textdata(:,2);
    
    peak_current=max(current); %find peak current to control L' from peak force (below)
%TO DO: AGA BURDA ELLE GIR OLMADI BOLE L'

   
    Lprime=2*force_peak_armature/(peak_current*peak_current);%L' should be approximately 0.5uH/m

    current_square=(current).*(current); %Force is related with square of current
    peak_current_square=max(current_square);
    waveform=current_square/peak_current_square;%find normalized force and acceleration waveforms
    %plot(time,waveform); %normalized waveform

%     mass_projectile=0.125;
    acc_projectile_peak=force_peak_armature/(mass_armature+mass_projectile); %maximum acceleration of projectile+armature
    acc_waveform=acc_projectile_peak*waveform;%find actual acceleration waveform
    %plot(time,acc_waveform)



    velocity = trapz(time,acc_waveform);

    energy=0.5*(mass_projectile)*velocity*velocity;

       