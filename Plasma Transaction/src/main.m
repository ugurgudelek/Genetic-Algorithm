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


var1=6;
var2=6;
var3=12.5-var1-var2;
var4=6;
var5=6;
var6=6;
%showPlot=1;

tic
[Farm, J, mass]=FEA_Contact(9.4992,1.2580, 12.5-9.4992-1.2580,11.6196,11.7308,7.3801);%[F j m]]
toc

% Farm=FEA_Results(1);
% J=FEA_Results(2);
% mass=FEA_Results(3);

[Energy Lprime acc_max Velocity]=Energy_Calc(Farm, mass);

%Jcritical=4.6e9;
%Jmax=1.24e10;
%Jnorm=J/Jmax;
%Jcritical_norm=Jnorm/Jcritical;

