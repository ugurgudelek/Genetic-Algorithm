function [eliminate,cur_history] = pressure_satisfied(params, var_history)


    cur_history = calculate_energy(params, var_history);
    
    pressure = cur_history.pressure;
    eliminate = pressure > 110e6;
    cur_history.eliminate = eliminate;

end