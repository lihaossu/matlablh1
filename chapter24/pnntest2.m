

%%
clc;
clear all
close all
nntwarn off;
warning off;

%%
load data2
%%
Train=data(1:23,:);
Test=data(24:end,:);
p_train=Train(:,1:3)';
t_train=Train(:,4)';
p_test=Test(:,1:3)';
t_test=Test(:,4)';

%%
%t_train=ind2vec(t_train);%% ind2vec function
t_train_temp=Train(:,4)';
%% 
Spread=1.5;
PNN(p_train,t_train,p_test,Spread)