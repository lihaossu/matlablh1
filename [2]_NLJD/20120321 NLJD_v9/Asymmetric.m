clear all;
close all;
clc;

load sample_2nd_RX_data4.TXT
load sample_3rd_RX_data4.TXT
load sample_2nd_RX_data5.TXT
load sample_3rd_RX_data5.TXT


Mean_Value = 1;
Deviation = 20;

Data1 = [sample_2nd_RX_data4 sample_3rd_RX_data4];
Data2 = [sample_2nd_RX_data5 sample_3rd_RX_data5];

Data_1 = [Data1; Mean_Value+Deviation.*ceil(randn(length(Data1),2))+Data1;...
    Mean_Value+Deviation.*ceil(randn(length(Data1),2))+Data1;...
    Mean_Value+Deviation.*ceil(randn(length(Data1),2))+Data1;...
    Mean_Value+Deviation.*ceil(randn(length(Data1),2))+Data1];

Data_2 = [Data2; Mean_Value+Deviation.*ceil(randn(length(Data2),2))+Data2;...
    Mean_Value+Deviation.*ceil(randn(length(Data2),2))+Data2;...
    Mean_Value+Deviation.*ceil(randn(length(Data2),2))+Data2;...
    Mean_Value+Deviation.*ceil(randn(length(Data2),2))+Data2];
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

xlabel('Third Harmonics');
ylabel('Second Harmonics');

Class1 = zeros(length(Data_1),1);
Class2 = ones(length(Data_2),1);

Class1 = [Data_1 Class1];
Class2 = [Data_2 Class2];

save Asymmetric_50.mat Class1 Class2

axis([100 1000 100 1000])
grid on
