var1=6;
var2=6;
var3=12.5-var1-var2;
var4=6;
var5=6;
var6=6;
showPlot=1;

tic
FEA_Results=FEA_Contact(1.9, 4.1,12.5-1.9-4.1, 6.4, 7.9, 5.1);%[F j m]]
toc

Farm=FEA_Results(1);
J=FEA_Results(2);
mass=FEA_Results(3);

[Energy Lprime]=Energy_Calc(Farm, mass);

%Jcritical=4.6e9;
%Jmax=1.24e10;
%Jnorm=J/Jmax;
%Jcritical_norm=Jnorm/Jcritical;