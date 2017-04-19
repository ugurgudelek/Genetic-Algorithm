%Fix armature geometry parameters for energy calculation
%Take mass and peak acceleration info from FEA
x1=5;
x2=5;
x3=5;
x4=5;
x5=5;
showPlot=1;
FEA_Result = Farm_FEA(x1,x2,x3,x4,x5,showPlot);
mass=FEA_Result(1,2);
acc_peak=FEA_Result(1,1);
%acc_peak=acc_peak*mass/0.125; %önceki analizlerde 0.125kg mass alm??t?m,
%80m/s ç?km??t? onu görmek için bunu ekledim 71m/s ç?kt?.

%import sampled current data
text = '200kJ_I.txt'; %import sampled data
textdata=importdata(text);

data_number=size(textdata,1); %find # of data
data_number=(round(data_number/2)-1)*2;

current=textdata(1:data_number,2); %save current and time array from the text file
time=textdata(1:data_number,1);
peak_current=max(current); %find peak current to control L' from peak force (below)


Force_max=acc_peak*mass;
Lprime=2*Force_max/(peak_current*peak_current);%L' should be approximately 0.5uH/m

current_square=(current).*(current); %Force is related with square of current
peak_current_square=max(current_square);
waveform=current_square/peak_current_square;%find normalized force and acceleration waveforms
%plot(time,waveform); %normalized waveform

acc_waveform=acc_peak*waveform;%find actual acceleration waveform
plot(time,acc_waveform)


 
velocity = trapz(time,acc_waveform(1:data_number));

energy=0.5*mass*velocity*velocity
 
 
 
 
 
 