function output_arr = wrapper(input_arr)
    
    x1 = input_arr{1};
    x2 = input_arr{2};
    x3 = input_arr{3};
    x4 = input_arr{4};
    
    % call FEM function
    fem_output = fem_caller(x1,x2,x3,x4)
    
    % return FEM output
    output_arr = double(fem_output);
end