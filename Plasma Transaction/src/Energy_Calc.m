function [Energy, Lprime, acc_max, Velocity] = Energy_Calc(force_peak_armature, mass_armature)

    Current_Max=1e6;
    mass_pro=0.025;


    
    Energy=(0.5/(mass_armature+mass_pro))*(((10e-3+1.4e-3)/2)*force_peak_armature)^2;
    Lprime=2*force_peak_armature/(Current_Max*Current_Max);
    acc_max=force_peak_armature/(mass_armature+mass_pro);
    Velocity=sqrt(2*Energy/(mass_armature+mass_pro));
    

        
