clear all; close all; clc;

%% Load File

load k_by_Training_10_k_3.mat
load k_by_Training_10_k_5.mat
load k_by_Training_10_k_7.mat
load k_by_Training_10_k_9.mat
load k_by_Training_10_k_11.mat
load k_by_Training_10_k_13.mat

Data = [k_by_Training_10_k_3 k_by_Training_10_k_5 k_by_Training_10_k_7 ...
    k_by_Training_10_k_9 k_by_Training_10_k_11 k_by_Training_10_k_13];

%% Figure

Iter = 3:2:13;

bar(Iter,Data)
axis([2 14 0 20])
xlabel('Number of k');
ylabel('Error Probability (%)');
grid on
