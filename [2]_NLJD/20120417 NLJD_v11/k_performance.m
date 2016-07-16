clear all; close all; clc;

%% Load File

% Symmetric
load Result_Symmetric_40.mat
Sym_Prob_Fairness_Symmetric_40 = plot_data_Symmetric_40(:,1);
Sym_Prob_kNN_Class_Symmetric_40 = plot_data_Symmetric_40(:,2);
Sym_Prob_fuzzy_Class_Symmetric_40 = plot_data_Symmetric_40(:,3);
Sym_Prob_kNN_Class_Fairness_40 = plot_data_Symmetric_40(:,4);
Sym_Prob_fuzzy_Class_Fairness_40 = plot_data_Symmetric_40(:,5);
Sym_Prob_kNN_Fuzzy_40 = plot_data_Symmetric_40(:,6);

load Result_Symmetric_50.mat
Sym_Prob_Fairness_Symmetric_50 = plot_data_Symmetric_50(:,1);
Sym_Prob_kNN_Class_Symmetric_50 = plot_data_Symmetric_50(:,2);
Sym_Prob_fuzzy_Class_Symmetric_50 = plot_data_Symmetric_50(:,3);
Sym_Prob_kNN_Class_Fairness_50 = plot_data_Symmetric_50(:,4);
Sym_Prob_fuzzy_Class_Fairness_50 = plot_data_Symmetric_50(:,5);
Sym_Prob_kNN_Fuzzy_50 = plot_data_Symmetric_50(:,6);

% Asymmetric
load Result_Asymmetric_40.mat
Asy_Prob_Fairness_Symmetric_40 = plot_data_Asymmetric_40(:,1);
Asy_Prob_kNN_Class_Symmetric_40 = plot_data_Asymmetric_40(:,2);
Asy_Prob_fuzzy_Class_Symmetric_40 = plot_data_Asymmetric_40(:,3);
Asy_Prob_kNN_Class_Fairness_40 = plot_data_Asymmetric_40(:,4);
Asy_Prob_fuzzy_Class_Fairness_40 = plot_data_Asymmetric_40(:,5);
Asy_Prob_kNN_Fuzzy_40 = plot_data_Asymmetric_40(:,6);

load Result_Asymmetric_50.mat
Asy_Prob_Fairness_Symmetric_50 = plot_data_Asymmetric_50(:,1);
Asy_Prob_kNN_Class_Symmetric_50 = plot_data_Asymmetric_50(:,2);
Asy_Prob_fuzzy_Class_Symmetric_50 = plot_data_Asymmetric_50(:,3);
Asy_Prob_kNN_Class_Fairness_50 = plot_data_Asymmetric_50(:,4);
Asy_Prob_fuzzy_Class_Fairness_50 = plot_data_Asymmetric_50(:,5);
Asy_Prob_kNN_Fuzzy_50 = plot_data_Asymmetric_50(:,6);

%% Symmetric 40
% Data = [Sym_Prob_Fairness_Symmetric_40 Sym_Prob_kNN_Class_Symmetric_40 Sym_Prob_fuzzy_Class_Symmetric_40 ...
%     Sym_Prob_kNN_Class_Fairness_40 Sym_Prob_fuzzy_Class_Fairness_40];


%% Symmetric 50
% Data = [Sym_Prob_Fairness_Symmetric_50 Sym_Prob_kNN_Class_Symmetric_50 Sym_Prob_fuzzy_Class_Symmetric_50 ...
%     Sym_Prob_kNN_Class_Fairness_50 Sym_Prob_fuzzy_Class_Fairness_50];

%% Asymmetric 40
% Data = [Asy_Prob_Fairness_Symmetric_40 Asy_Prob_kNN_Class_Symmetric_40 Asy_Prob_fuzzy_Class_Symmetric_40 ...
%     Asy_Prob_kNN_Class_Fairness_40 Asy_Prob_fuzzy_Class_Fairness_40];

%% Asymmetric 50
Data = [Asy_Prob_Fairness_Symmetric_50 Asy_Prob_kNN_Class_Symmetric_50 Asy_Prob_fuzzy_Class_Symmetric_50 ...
    Asy_Prob_kNN_Class_Fairness_50 Asy_Prob_fuzzy_Class_Fairness_50];



%% Figure

Iter = 3:2:25;

bar(Iter,Data)
axis([2 26 0 100])
xlabel('Number of k');
ylabel('Error Probability (%)');
grid on
legend('Decision Level Error','Conventional kNN','Conventional kNN w/ Fuzzy','Advanced kNN','Advacned kNN w/ Fuzzy');
