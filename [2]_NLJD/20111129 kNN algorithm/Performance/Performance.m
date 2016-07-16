clear all; close all; clc;

%% Load File
load Training_10_k_3.mat
load Training_20_k_3.mat
load Training_30_k_3.mat
load Training_40_k_3.mat
load Training_50_k_3.mat

k_3 = [Training_10_k_3 Training_20_k_3 Training_30_k_3 Training_40_k_3 Training_50_k_3];

% load Training_60_k_3
% load Training_70_k_3
% load Training_80_k_3
% load Training_90_k_3
% load Training_100_k_3

% k_3 = [Training_10_k_3 Training_20_k_3 Training_30_k_3 Training_40_k_3 Training_50_k_3 ...
%     Training_60_k_3 Training_70_k_3 Training_80_k_3 Training_90_k_3 Training_100_k_3];

load Training_10_k_5.mat
load Training_20_k_5.mat
load Training_30_k_5.mat
load Training_40_k_5.mat
load Training_50_k_5.mat

k_5 = [Training_10_k_5 Training_20_k_5 Training_30_k_5 Training_40_k_5 Training_50_k_5];

% load Training_60_k_5
% load Training_70_k_5
% load Training_80_k_5
% load Training_90_k_5
% load Training_100_k_5

% k_5 = [Training_10_k_5 Training_20_k_5 Training_30_k_5 Training_40_k_5 Training_50_k_5 ...
%     Training_60_k_5 Training_70_k_5 Training_80_k_5 Training_90_k_5 Training_100_k_5];

load Training_10_k_7.mat
load Training_20_k_7.mat
load Training_30_k_7.mat
load Training_40_k_7.mat
load Training_50_k_7.mat

k_7 = [Training_10_k_7 Training_20_k_7 Training_30_k_7 Training_40_k_7 Training_50_k_7];

% load Training_60_k_7
% load Training_70_k_7
% load Training_80_k_7
% load Training_90_k_7
% load Training_100_k_7

% k_7 = [Training_10_k_7 Training_20_k_7 Training_30_k_7 Training_40_k_7 Training_50_k_7 ...
%     Training_60_k_7 Training_70_k_7 Training_80_k_7 Training_90_k_7 Training_100_k_7];

%% Figure

% Interval = [10:10:100];
Interval = 10:10:50;

plot(Interval,k_3,'bs-','LineWidth',2)
hold on
plot(Interval,k_5,'ro-','LineWidth',2)
hold on
plot(Interval,k_7,'gd-','LineWidth',2)
axis([10 50 0 30])
xlabel('Training Data');
ylabel('Error Probability (%)');
legend('k=3','k=5','k=7');
grid on
