function fem_output = fem_caller(x1,x2,x4,x5,x6)

    % *GRAPHS and HISTORY Info:*
    %     For the control during the computation, create the graph of change of the fittest individual's:
    % 1) Farm_max value (comes from FEA)
    % 2) Armature mass value (comes from FEA)
    % 3) Energy value (comes from Energy_Calc function)
    % 4) Maximum current density value on the surface between armature and and
    % rail (comes from FEA)
    %     
    %     For the history of the optimization,save all individual's:
    % 1) Farm_max value (comes from FEA)
    % 2) Armature mass value (comes from FEA also)
    % 3) Energy value (comes from Energy_Calc function)
    % 4) Maximum current density value on the surface between armature and and
    % rail (comes from FEA)
    % 5) Velocity value (comes from Energy_Calc function)
    % 6) Lprime value (comes from Energy_Calc function)
    % 7) x1,x2,x3,x4,x5, and x6 geometric independent variables
    % 8) Peak acceleration (comes from Energy_Calc function)

    

    [Farm, J, mass] =FEA_Contact(1.9, 4.1,12.5-1.9-4.1, 6.4, 7.9, 5.1);%[F j m]]
    
    tic
    x3=12.5-x1-x2;
% === Real sim ===
%     [Farm, J, mass] = FEA_Contact(x1, x2,x3, x4, x5, x6);%[F j m]]
% === Real sim ===

% === Fake sim ===
%     Farm = rand;
%     J = rand;
%     mass = rand;
% === Fake sim ===

    [Energy, Lprime, acc_max, velocity]=Energy_Calc(Farm, mass);
    toc

    %Jcritical=4.6e9;
    %Jmax=1.24e10;
    %Jnorm=J/Jmax;
    %Jcritical_norm=Jnorm/Jcritical;
    
    fem_output(1) = Farm;
    fem_output(2) = J;
    fem_output(3) = mass;
    fem_output(4) = Energy;
    fem_output(5) = Lprime;
    fem_output(6) = acc_max;
    fem_output(7) = velocity;
end