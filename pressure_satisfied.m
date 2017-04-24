function [eliminate,cur_history] = pressure_satisfied(params, var_history)
    
    % do not calculate fitness via comsol, use precalculated values
    if isKey(var_history,num2str(params))
        cur_history = var_history(num2str(params));
%         pressure = cur_history.pressure;
        eliminate = rand > 0.5;
        return
    end
    
%     TODO:
%     CALCULATE PRESSURE BELOW
    
    eliminate = rand > 0.5;
%     eliminate = false;


    cur_history.params              = rand;
    cur_history.mass_armature       = rand;
    cur_history.acc_peak_armature   = rand;
    cur_history.Lprime              = rand;
    cur_history.energy              = rand;
    cur_history.velocity            = rand;
    cur_history.mass_projectile     = rand;