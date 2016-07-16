clear all; close all; clc;

%% Load File

load Training_20.mat
load Training_40.mat
load Training_60.mat
load Training_80.mat
load Training_100.mat

%% Figure

Interval = 3:2:15;

plot(Interval,100-Training_20,'bs-','LineWidth',2)
hold on
plot(Interval,100-Training_40,'go-','LineWidth',2)
hold on
plot(Interval,100-Training_60,'rd-','LineWidth',2)
hold on
plot(Interval,100-Training_80,'cs-','LineWidth',2)
hold on
plot(Interval,100-Training_100,'mo-','LineWidth',2)
hold on

axis([3 15 0 100])
xlabel('Number of k');
ylabel('Detection Ratio (%)');
legend('training=20','training=40','training=60','training=80','training=100');
grid on
