clear all; close all; clc;

%% Load File
% k = 3
load Training_20_k_3.mat
load Training_40_k_3.mat
load Training_60_k_3.mat
load Training_80_k_3.mat
load Training_100_k_3.mat

k_3 = [Training_20_k_3 Training_40_k_3 Training_60_k_3 Training_80_k_3 Training_100_k_3];

% k = 5
load Training_20_k_5.mat
load Training_40_k_5.mat
load Training_60_k_5.mat
load Training_80_k_5.mat
load Training_100_k_5.mat

k_5 = [Training_20_k_5 Training_40_k_5 Training_60_k_5 Training_80_k_5 Training_100_k_5];

% k = 7
load Training_20_k_7.mat
load Training_40_k_7.mat
load Training_60_k_7.mat
load Training_80_k_7.mat
load Training_100_k_7.mat

k_7 = [Training_20_k_7 Training_40_k_7 Training_60_k_7 Training_80_k_7 Training_100_k_7];

% k = 9
load Training_20_k_9.mat
load Training_40_k_9.mat
load Training_60_k_9.mat
load Training_80_k_9.mat
load Training_100_k_9.mat

k_9 = [Training_20_k_9 Training_40_k_9 Training_60_k_9 Training_80_k_7 Training_100_k_7];

% k = 11
load Training_20_k_11.mat
load Training_40_k_11.mat
load Training_60_k_11.mat
load Training_80_k_11.mat
load Training_100_k_11.mat

k_11 = [Training_20_k_11 Training_40_k_11 Training_60_k_11 Training_80_k_11 Training_100_k_11];

% k = 13
load Training_20_k_13.mat
load Training_40_k_13.mat
load Training_60_k_13.mat
load Training_80_k_13.mat
load Training_100_k_13.mat

k_13 = [Training_20_k_13 Training_40_k_13 Training_60_k_13 Training_80_k_13 Training_100_k_13];

% k = 15
load Training_20_k_15.mat
load Training_40_k_15.mat
load Training_60_k_15.mat
load Training_80_k_15.mat
load Training_100_k_15.mat

k_15 = [Training_20_k_15 Training_40_k_15 Training_60_k_15 Training_80_k_15 Training_100_k_15];


%% Figure

Interval = 20:20:100;

plot(Interval,k_3,'bs-','LineWidth',2)
hold on
plot(Interval,k_5,'go-','LineWidth',2)
hold on
plot(Interval,k_7,'rd-','LineWidth',2)
hold on
plot(Interval,k_9,'cs-','LineWidth',2)
hold on
plot(Interval,k_11,'mo-','LineWidth',2)
hold on
plot(Interval,k_13,'yd-','LineWidth',2)
hold on
plot(Interval,k_15,'kd-','LineWidth',2)
axis([20 100 0 30])
xlabel('Training Data');
ylabel('Error Probability (%)');
legend('k=3','k=5','k=7','k=9','k=11','k=13','k=15');
grid on
