clear all;
close all;
clc;

load Training_40.mat

Data = [Class1; Class2];


NLJD = Data((Data(:,3)==0),:);        % data for NLJD
Metal = Data((Data(:,3)==1),:);    % data for Metal
obsv_n = size(Data, 1);                 % total number of observations


Characteristics = {'Second Harmics','Third Harmonics'};
pairs = [1 2; 1 2];
h = figure;
for j = 1:2,
    x = pairs(j, 1);
    y = pairs(j, 2);
    subplot(1,2,j);
    plot([NLJD(:,x) Metal(:,x)],...
         [NLJD(:,y) Metal(:,y)], '.');
    xlabel(Characteristics{x});
    ylabel(Characteristics{y});
end


cluster_n = 3;                          % Number of clusters
expo = 2.0;                             % Exponent for U
max_iter = 100;                         % Max. iteration
min_impro = 1e-6;                       % Min. improvement

% initialize fuzzy partition
U = initfcm(cluster_n, obsv_n);
% plot the data if the figure window is closed
if ishghandle(h)
    figure(h);
else
    for j = 1:2,
        x = pairs(j, 1);
        y = pairs(j, 2);
        subplot(1,1,j);
        plot([NLJD(:,x) Metal(:,x)],...
             [NLJD(:,y) Metal(:,y)], '.');
        xlabel(Characteristics{x});
        ylabel(Characteristics{y});
    end
end
% iteration
for i = 1:max_iter,
    [U, center, obj] = stepfcm(Data, U, cluster_n, expo);
    fprintf('Iteration count = %d, obj. fcn = %f\n', i, obj);
    % refresh centers
    if i>1 && (abs(obj - lastobj) < min_impro)
        for j = 1:2,
            subplot(1,2,j);
            for k = 1:cluster_n,
                text(center(k, pairs(j,1)), center(k,pairs(j,2)), int2str(k), 'FontWeight', 'bold');
            end
        end
        break;
    elseif i==1
        for j = 1:2,
            subplot(1,2,j);
            for k = 1:cluster_n,
                text(center(k, pairs(j,1)), center(k,pairs(j,2)), int2str(k), 'color', [0.5 0.5 0.5]);
            end
        end
    end
    lastobj = obj;
end