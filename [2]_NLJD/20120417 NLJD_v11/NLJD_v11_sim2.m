clear all;
close all;
clc;
%% Load Training Data
load Asymmetric_50.mat

%% Simulation Number
knn_simulation_no = 1000;
frame = 100;
%% Calculate
A = ceil(sum(Class1(:,1:2))/length(Class1));
B = ceil(sum(Class2(:,1:2))/length(Class2));
C = ceil(A+B)/2;

progressbar;
% kNN Factor
k = 3:2:25;

% Measure_Deviation = 1;
% Noise_Deviation = 40;

%% Dummy
Fairness_Estimation = zeros(1,knn_simulation_no);
Symmetric_Estimation = zeros(1,knn_simulation_no);
kNN_Class = zeros(1,knn_simulation_no);
fuzzy_Class = zeros(1,knn_simulation_no);

Err_Fairness_Symmetric = zeros(1,knn_simulation_no);
Err_kNN_Class_Symmetric = zeros(1,knn_simulation_no);
Err_fuzzy_Class_Symmetric = zeros(1,knn_simulation_no);
Err_kNN_Class_Fairness = zeros(1,knn_simulation_no);
Err_fuzzy_Class_Fairness = zeros(1,knn_simulation_no);
Err_kNN_Fuzzy = zeros(1,knn_simulation_no);

Acc_Fairness_Symmetric = zeros(1,frame);
Acc_kNN_Class_Symmetric = zeros(1,frame);
Acc_fuzzy_Class_Symmetric = zeros(1,frame);
Acc_kNN_Class_Fairness = zeros(1,frame);
Acc_fuzzy_Class_Fairness = zeros(1,frame);
Acc_kNN_Fuzzy = zeros(1,frame);

Prob_Fairness_Symmetric = zeros(1,length(k));
Prob_kNN_Class_Symmetric = zeros(1,length(k));
Prob_fuzzy_Class_Symmetric = zeros(1,length(k));
Prob_kNN_Class_Fairness = zeros(1,length(k));
Prob_fuzzy_Class_Fairness = zeros(1,length(k));
Prob_kNN_Fuzzy = zeros(1,length(k));

%% Fuzzy Logic
% Generate Database for Fuzzy
fuzzy_Data = 1000;
Measured_rand = repmat(C,fuzzy_Data,1) + 100.*randn(fuzzy_Data,2);
Database = [Class1(:,1:2); Class2(:,1:2); Measured_rand];

% Execute Fuzzy
[center,U,objFcn] = fcm_1(Database,2);
maxU = max(U);
index1 = find(U(1,:) == maxU);
index2 = find(U(2,:) == maxU);

% Make a Cluster
if Database(index1,1) <= Database(index1,2) % NLJD
    fuzzy_cluster1 = Database(index2,1:2);
    fuzzy_cluster2 = Database(index1,1:2);
elseif Database(index1,1) > Database(index1,2) % NLJD
    fuzzy_cluster1 = Database(index1,1:2);
    fuzzy_cluster2 = Database(index2,1:2);
end;

%% Faireness D/L
xv11 = [C(2)-C(2); C(2)+C(2); C(2)-C(2); C(2)-C(2)];
yv11 = [C(1)-C(2); C(1)+C(2); C(1)+C(2); C(1)-C(2)];

% Figure for one time
%         plot(Database(:,1), Database(:,2),'o');
%         hold on;
%         line(fuzzy_cluster1(:,1),fuzzy_cluster1(:,2),'marker','*','color','g');
%         line(fuzzy_cluster2(:,1),fuzzy_cluster2(:,2),'marker','*','color','r');
%         plot([center([1 2],1)],[center([1 2],2)],'*','color','k')
%         hold off;
%         grid on;

%% Simulation
for idx_k = 1:length(k)
    
    for idx_frame = 1:frame
                
        % Simulation Count
        for idx_simulation = 1:knn_simulation_no
            
            % Measured the NLJD
%             Measured = 1000.*rand(1,2);
            Measured = ceil(C+sqrt(40)*randn(1,2));
            
            % Symmetric D/L
            if Measured(1) <= Measured(2)
                Symmetric_Estimation(idx_simulation) = 0; % NLJD
            elseif Measured(1) > Measured(2)
                Symmetric_Estimation(idx_simulation) = 1; % Metal
            end;
            
            % Fairness DL
            rd = Measured(1); nd = Measured(2);
            in11 = inpolygon(nd,rd,xv11,yv11);
            if in11 == 0
                Fairness_Estimation(idx_simulation) = 0; % NLJD
            elseif in11 == 1
                Fairness_Estimation(idx_simulation) = 1; % Metal
            end;
            
            % kNN
            kNN_Class(idx_simulation) = kNN(k(idx_k),Measured,Class1(:,1:2),Class2(:,1:2));
            % kNN w/ Fuzzy
            fuzzy_Class(idx_simulation) = kNN(k(idx_k),Measured,fuzzy_cluster1,fuzzy_cluster2);
            
            % Progress Bar
            progress_count = idx_simulation/knn_simulation_no;
            % Do something important
            pause(0.01)
            % Update figure
            progressbar(((idx_k-1)*frame+((idx_frame-1)+progress_count))/(length(k)*frame));
            
            % Error Count between D/L
            Err_Fairness_Symmetric(idx_simulation) = xor(Symmetric_Estimation(idx_simulation),Fairness_Estimation(idx_simulation));
                        
            % Error Count w/ Symmetric
            Err_kNN_Class_Symmetric(idx_simulation) = xor(Symmetric_Estimation(idx_simulation),kNN_Class(idx_simulation));
            Err_fuzzy_Class_Symmetric(idx_simulation) = xor(Symmetric_Estimation(idx_simulation),fuzzy_Class(idx_simulation));
            
            % Error Count w/ Fairness
            Err_kNN_Class_Fairness(idx_simulation) = xor(Fairness_Estimation(idx_simulation),kNN_Class(idx_simulation));
            Err_fuzzy_Class_Fairness(idx_simulation) = xor(Fairness_Estimation(idx_simulation),fuzzy_Class(idx_simulation));
            
            % Error Count kNN vs. kNN w/ Fuzzy
            Err_kNN_Fuzzy(idx_simulation) = xor(kNN_Class(idx_simulation),fuzzy_Class(idx_simulation));
            
        end;
        
        % Accumulate Error Count between D/L
        Acc_Fairness_Symmetric(idx_frame) = sum(Err_Fairness_Symmetric);
        
        % Accumulate Error Count w/ Symmetric
        Acc_kNN_Class_Symmetric(idx_frame) = sum(Err_kNN_Class_Symmetric);
        Acc_fuzzy_Class_Symmetric(idx_frame) = sum(Err_fuzzy_Class_Symmetric);
        
        % Accumulate Error Count w/ Fairness
        Acc_kNN_Class_Fairness(idx_frame) = sum(Err_kNN_Class_Fairness);
        Acc_fuzzy_Class_Fairness(idx_frame) = sum(Err_fuzzy_Class_Fairness);
        
        % Accumulate Count kNN vs. kNN w/ Fuzzy
        Acc_kNN_Fuzzy(idx_frame) = sum(Err_kNN_Fuzzy);
        
    end;
    
    % Probability Error Count between D/L
    Prob_Fairness_Symmetric(idx_k) = (sum(Acc_Fairness_Symmetric) / (knn_simulation_no * frame)) * 100;
    
    % Probability Error Count w/ Symmetric
    Prob_kNN_Class_Symmetric(idx_k) = (sum(Acc_kNN_Class_Symmetric) / (knn_simulation_no * frame)) * 100;
    Prob_fuzzy_Class_Symmetric(idx_k) = (sum(Acc_fuzzy_Class_Symmetric) / (knn_simulation_no * frame)) * 100;
    
    % Probability Error Count w/ Fairness
    Prob_kNN_Class_Fairness(idx_k) = (sum(Acc_kNN_Class_Fairness) / (knn_simulation_no * frame)) * 100;
    Prob_fuzzy_Class_Fairness(idx_k) = (sum(Acc_fuzzy_Class_Fairness) / (knn_simulation_no * frame)) * 100;
    
    % Probability Count kNN vs. kNN w/ Fuzzy
    Prob_kNN_Fuzzy(idx_k) = (sum(Err_kNN_Fuzzy) / (knn_simulation_no * frame)) * 100;
    
end;

plot_data_Asymmetric_50 = [Prob_Fairness_Symmetric' Prob_kNN_Class_Symmetric' ...
    Prob_fuzzy_Class_Symmetric' Prob_kNN_Class_Fairness'...
    Prob_fuzzy_Class_Fairness' Prob_kNN_Fuzzy'];

bar(k,plot_data_Asymmetric_50);
legend('Fairness','DL kNN','DL kNN /w Fuzzy','Advanced kNN','Advanced kNN /w Fuzzy','kNN vs. kNN /w Fuzzy');

save Result_Asymmetric_50.mat plot_data_Asymmetric_50

figure
plot(Database(:,1), Database(:,2),'o');
hold on;
line(Database(index1,1),Database(index1,2),'marker','*','color','g');
line(Database(index2,1),Database(index2,2),'marker','*','color','r');
% Plot the cluster centers
plot([center([1 2],1)],[center([1 2],2)],'*','color','k')
hold off;
grid on;

% axis([150 550 150 1000])
% axis([350 700 350 700])
