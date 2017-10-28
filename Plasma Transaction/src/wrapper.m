function output_arr = wrapper(input_arr)
    
    x1 = input_arr{1};
    x2 = input_arr{2};
    x4 = input_arr{3};
    x5 = input_arr{4};
    x6 = input_arr{5};
    
    % call FEM function
    fem_output = fem_caller(x1,x2,x4,x5,x6)
    
    % return FEM output
    % output signature
    % fem_output(1) = Farm;
    % fem_output(2) = J;
    % fem_output(3) = mass;
    % fem_output(4) = Energy;
    % fem_output(5) = Lprime;
    % fem_output(6) = acc_max;
    % fem_output(7) = velocity;
    output_arr = double(fem_output);
end