function [Energy, Lprime, acc_max, Velocity] = Energy_Calc(force_peak_armature, mass_armature)

    Current_Max=1e6;
    mass_pro=0.3;

    acc_max=force_peak_armature/(mass_armature+mass_pro);
    Velocity=((4.5e-3+2.7e-3)/2)*acc_max;
    Energy=(0.5*(mass_pro))*(Velocity)^2;
    Lprime=2*force_peak_armature/(Current_Max*Current_Max);
    


    

        
