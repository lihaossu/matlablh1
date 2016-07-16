clear all;
close all;
clc;

load Second_1.TXT
load Third_1.TXT

Mean_Value = 1;
Deviation_Value = 10;

Second  = [Second_1; Mean_Value+Deviation_Value*randn(length(Second_1),1)+Second_1;...
    Mean_Value+Deviation_Value*randn(length(Second_1),1)+Second_1;...
    Mean_Value+Deviation_Value*randn(length(Second_1),1)+Second_1;...
    Mean_Value+Deviation_Value*randn(length(Second_1),1)+Second_1];
Third = [Third_1; Mean_Value+Deviation_Value*randn(length(Second_1),1)+Third_1;...
    Mean_Value+Deviation_Value*randn(length(Second_1),1)+Third_1;...
    Mean_Value+Deviation_Value*randn(length(Second_1),1)+Third_1;...
    Mean_Value+Deviation_Value*randn(length(Second_1),1)+Third_1];

Data_1 = [Second Third];
Data_2 = [Third Second];

%% Class1 Plot
for idx_Class1 = 1:size(Data_1,1)
    plot(Data_1(idx_Class1,1),Data_1(idx_Class1,2),'rs','LineWidth',2,'MarkerSize',3);
    hold on;
end;

%% Class2 Plot
for idx_Class2 = 1:size(Data_2,1)
    plot(Data_2(idx_Class2,1),Data_2(idx_Class2,2),'bo','LineWidth',2,'MarkerSize',3);
    hold on;
end;
% 
% plot(Measured(1),Measured(2),'go','LineWidth',2,'MarkerSize',3);

xlabel('Second Harmonics');
ylabel('Third Harmonics');

Class1 = zeros(length(Second),1);
Class2 = ones(length(Third),1);

Class1 = [Data_1 Class1];
Class2 = [Data_2 Class2];

save Training_10.mat Class1 Class2

axis([350 700 350 700])
grid on
