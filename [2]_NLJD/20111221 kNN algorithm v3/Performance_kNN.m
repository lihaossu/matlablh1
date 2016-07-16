clear all; close all; clc;

%% Load File

load Training_20.mat
load Training_40.mat
load Training_60.mat
load Training_80.mat
load Training_100.mat

k_3 = [Training_20(1) Training_40(1) Training_60(1) Training_80(1) Training_100(1)];
k_5 = [Training_20(2) Training_40(2) Training_60(2) Training_80(2) Training_100(2)];
k_7 = [Training_20(3) Training_40(3) Training_60(3) Training_80(3) Training_100(3)];
k_9 = [Training_20(4) Training_40(4) Training_60(4) Training_80(4) Training_100(4)];
k_11 = [Training_20(5) Training_40(5) Training_60(5) Training_80(5) Training_100(5)];
k_13 = [Training_20(6) Training_40(6) Training_60(6) Training_80(6) Training_100(6)];
k_15 = [Training_20(7) Training_40(7) Training_60(7) Training_80(7) Training_100(7)];

%% Figure

Interval = 20:20:100;

plot(Interval,100-k_3,'bo-','LineWidth',2)
hold on
plot(Interval,100-k_5,'gx-','LineWidth',2)
hold on
plot(Interval,100-k_7,'r+-','LineWidth',2)
hold on
plot(Interval,100-k_9,'c*-','LineWidth',2)
hold on
plot(Interval,100-k_11,'ms-','LineWidth',2)
hold on
plot(Interval,100-k_13,'yd-','LineWidth',2)
hold on
plot(Interval,100-k_15,'kp-','LineWidth',2)
hold on
axis([20 100 0 100])
xlabel('Training Data');
ylabel('Detection Ratio (%)');
legend('k=3','k=5','k=7','k=9','k=11','k=13','k=15');
grid on
