clear
clc
close all

%% Load Data Set

load meas
load species

%% Scatter Plot
% figure
% gscatter(Fisher1(:,2),Fisher1(:,3),Fisher1(:,1));
% figure
% gscatter(Fisher1(:,2),Fisher1(:,4),Fisher1(:,1));
% figure
% gscatter(Fisher1(:,2),Fisher1(:,5),Fisher1(:,1));
% figure
% gscatter(Fisher1(:,3),Fisher1(:,4),Fisher1(:,1));
% figure
% gscatter(Fisher1(:,3),Fisher1(:,5),Fisher1(:,1));
% figure
% gscatter(Fisher1(:,4),Fisher1(:,5),Fisher1(:,1));

%% gplotmatrix
figure
gplotmatrix(meas,[],species);