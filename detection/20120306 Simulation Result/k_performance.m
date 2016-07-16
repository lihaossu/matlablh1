clear all; close all; clc;

%% Load File

% load Result_200.mat
% load Result_400.mat
load Result_10.mat
load Result_20.mat
load Result_30.mat
load Result_40.mat
load Result_50.mat

Data = [Result_10' Result_20' Result_30' ...
    Result_40' Result_50'];

%% Figure

Iter = 3:2:25;% mistake(i think.lh)  
%Iter = 3:2:15;
bar(Iter,Data)
axis([2 26 0 100])% overfitness(i think.lh)
%axis([2 17 0 20])
xlabel('Number of k');
ylabel('Error Probability (%)');
grid on
legend('Deviaion=10','Deviaion=20','Deviaion=30',...
    'Deviaion=40','Deviaion=50');