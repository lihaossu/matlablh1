clear all; close all; clc;

%% Load File

load Training_1000.mat

k_3 = Training_1000(1);
k_5 = Training_1000(2);
k_7 = Training_1000(3);
k_9 = Training_1000(4);
k_11 = Training_1000(5);
k_13 = Training_1000(6);
k_15 = Training_1000(7);

Data = [100-k_3 100-k_5 100-k_7 100-k_9 100-k_11 100-k_13 100-k_15];

%% Figure

Iter = 3:2:15;

bar(Iter,Data)
axis([2 16 0 100])
xlabel('Number of k');
ylabel('Detection Ratio (%)');
grid on
