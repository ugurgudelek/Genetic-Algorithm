function out = Energy_Calc(force_peak_armature, mass_armature)

    Current_Max=1e6;
    mass_pro=0.025;


    
    Energy=(0.5/(mass_armature+mass_pro))*(((10e-3+1.4e-3)/2)*force_peak_armature)^2;
    Lprime=2*force_peak_armature/(Current_Max*Current_Max);
    
    out=[Energy Lprime];
    
    
%     % save parameters for future
%     cur_history.params = params;
%     cur_history.mass_armature = mass_armature;
%     cur_history.acc_peak_armature = acc_projectile_peak;
%     cur_history.Lprime = Lprime;
%     cur_history.energy = energy;
%     cur_history.velocity = velocity;
%     cur_history.mass_projectile = mass_projectile;
        
