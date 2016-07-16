clear all;
close all;
clc;

%% Symmetric
% load Second_1.TXT
% load Third_1.TXT

%% Assymetric

load sample_2nd_RX_data4.TXT
load sample_3rd_RX_data4.TXT
load sample_2nd_RX_data5.TXT
load sample_3rd_RX_data5.TXT

Data_1 = [sample_2nd_RX_data4 sample_3rd_RX_data4];
Data_2 = [sample_2nd_RX_data5 sample_3rd_RX_data5];

%% 
% Mean = 1
Deviation_Value = 100;
Measure_Number = 10000;

Measure_1 = repmat(Data_1,Measure_Number/length(Data_1),1) + ceil(Deviation_Value*randn(Measure_Number,2));
Measure_2 = repmat(Data_2,Measure_Number/length(Data_2),1) + ceil(Deviation_Value*randn(Measure_Number,2));

Class_Measure_1 = zeros(length(Measure_1),1);
Class_Measure_2 = ones(length(Measure_2),1);

Class1 = [Measure_1 Class_Measure_1];
Class2 = [Measure_2 Class_Measure_2];

save Measure_100.mat Class1 Class2

%% Figure
% Class1 Plot
for idx_Class1 = 1:size(Measure_1,1)
    plot(Measure_1(idx_Class1,1),Measure_1(idx_Class1,2),'rs','LineWidth',2,'MarkerSize',3);
    hold on;
end;

% Class2 Plot
for idx_Class2 = 1:size(Measure_2,1)
    plot(Measure_2(idx_Class2,1),Measure_2(idx_Class2,2),'bo','LineWidth',2,'MarkerSize',3);
    hold on;
end;


xlabel('Third Harmonics');
ylabel('Second Harmonics');

axis([0 800 0 1200])
grid on
