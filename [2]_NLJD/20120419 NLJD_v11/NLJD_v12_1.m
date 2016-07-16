clear all;
close all;
clc;
%% Load Training Data
load Asymmetric_40.mat

%% Simulation Number
knn_simulation_no = 100;
frame = 1;
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
Real_Value = zeros(1,knn_simulation_no);
Fairness_Estimation = zeros(1,knn_simulation_no);
Symmetric_Estimation = zeros(1,knn_simulation_no);
kNN_Class = zeros(1,knn_simulation_no);
fuzzy_Class = zeros(1,knn_simulation_no);

Err_Symmetric = zeros(1,knn_simulation_no);
Err_Fairness = zeros(1,knn_simulation_no);
Err_kNN = zeros(1,knn_simulation_no);
Err_Fuzzy = zeros(1,knn_simulation_no);

Acc_Symmetric = zeros(1,frame);
Acc_Fairness = zeros(1,frame);
Acc_kNN = zeros(1,frame);
Acc_Fuzzy = zeros(1,frame);

Prob_Symmetric = zeros(1,length(k));
Prob_Fairness = zeros(1,length(k));
Prob_kNN = zeros(1,length(k));
Prob_Fuzzy = zeros(1,length(k));

%% Fuzzy Logic
% Generate Database for Fuzzy
fuzzy_Data = 100;
Measured_rand = repmat(C,fuzzy_Data,1) + 100.*randn(fuzzy_Data,2);
Database = [Class1(1:100,1:2); Class2(1:100,1:2); Measured_rand];

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
% xv11 = [C(2)-C(2); C(2)+C(2); C(2)-C(2); C(2)-C(2)];
% yv11 = [C(1)-C(2); C(1)+C(2); C(1)+C(2); C(1)-C(2)];
xv11 = [C(1)-C(2); C(1)+C(2); C(1)+C(2); C(1)-C(2)];
yv11 = [C(2)-C(2); C(2)+C(2); C(2)-C(2); C(2)-C(2)];

% Symmetric DL
xv00 = [0; C(1)+C(2); C(1)+C(2); 0];
yv00 = [0; C(1)+C(2); C(1)+C(2); 0];

% Figure for one time
%         plot(Database(:,1), Database(:,2),'o');
%         hold on;
%         line(fuzzy_cluster1(:,1),fuzzy_cluster1(:,2),'marker','*','color','g');
%         line(fuzzy_cluster2(:,1),fuzzy_cluster2(:,2),'marker','*','color','r');
%         plot([center([1 2],1)],[center([1 2],2)],'*','color','k')
%         hold off;
%         grid on;

%% Simulation
Measure_Std = 200;
Noise_Std = 40;
for idx_k = 1:length(k)

    for idx_frame = 1:frame

        % Simulation Count
        for idx_simulation = 1:knn_simulation_no

            % Measured the NLJD
            Measured = ceil(C+Measure_Std*randn(1,2));
%             Measured = Measured_Origin + ceil(Noise_Std*randn(1,2));

            % Real Value
%             if Measured_Origin(1) <= Measured_Origin(2)
%                 Real_Value(idx_simulation) = 0; % NLJD
%             elseif Measured_Origin(1) > Measured_Origin(2)
%                 Real_Value(idx_simulation) = 1; % Metal
%             end;

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
                Fairness_Estimation(idx_simulation) = 1; % Metal
            elseif in11 == 1
                Fairness_Estimation(idx_simulation) = 0; % NLJD
            end;

            % kNN
            kNN_Class(idx_simulation) = kNN(k(idx_k),Measured,Class1(1:100,1:2),Class2(1:100,1:2));
            % kNN w/ Fuzzy
            fuzzy_Class(idx_simulation) = kNN(k(length(k)),Measured,fuzzy_cluster1,fuzzy_cluster2);

            % Progress Bar
            progress_count = idx_simulation/knn_simulation_no;
            % Do something important
            pause(0.01)
            % Update figure
            progressbar(((idx_k-1)*frame+((idx_frame-1)+progress_count))/(length(k)*frame));

            % Error Symmetric
            Err_Symmetric(idx_simulation) = xor(fuzzy_Class(idx_simulation),Symmetric_Estimation(idx_simulation));
            % Error Fairness
            Err_Fairness(idx_simulation) = xor(fuzzy_Class(idx_simulation),Fairness_Estimation(idx_simulation));
            % Error kNN
            Err_kNN(idx_simulation) = xor(fuzzy_Class(idx_simulation),kNN_Class(idx_simulation));
            % Error kNN w/ Fuzzy
            Err_Fuzzy(idx_simulation) = xor(fuzzy_Class(idx_simulation),fuzzy_Class(idx_simulation));

        end;

        % Accumulate Symmetric Error
        Acc_Symmetric(idx_frame) = sum(Err_Symmetric);
        % Accumulate Fairness Error
        Acc_Fairness(idx_frame) = sum(Err_Fairness);
        % Accumulate kNN Error
        Acc_kNN(idx_frame) = sum(Err_kNN);
        % Accumulate kNN w/ Fuzzy Error
        Acc_Fuzzy(idx_frame) = sum(Err_Fuzzy);

    end;

    % Probability Symmetric
    Prob_Symmetric(idx_k) = (sum(Acc_Symmetric) / (knn_simulation_no * frame)) * 100;
    % Probability Fairness
    Prob_Fairness(idx_k) = (sum(Acc_Fairness) / (knn_simulation_no * frame)) * 100;
    % Probability kNN
    Prob_kNN(idx_k) = (sum(Acc_kNN) / (knn_simulation_no * frame)) * 100;
    % Probability kNN w/ Fuzzy
    Prob_Fuzzy(idx_k) = (sum(Acc_Fuzzy) / (knn_simulation_no * frame)) * 100;

end;

plot_data_Asymmetric_40 = [Prob_Symmetric' Prob_Fairness' ...
    Prob_kNN' Prob_Fuzzy'];

bar(k,plot_data_Asymmetric_40);
legend('Symmetric','Fairness','kNN','kNN w/ Fuzzy');

% save Asymmetric_40.mat plot_data_Asymmetric_40

figure
plot(Database(:,1), Database(:,2),'o');
hold on;
line(Database(index1,1),Database(index1,2),'marker','*','color','g');
line(Database(index2,1),Database(index2,2),'marker','*','color','r');
% Plot the cluster centers
plot([center([1 2],1)],[center([1 2],2)],'*','color','k')
hold on;
plot(xv11,yv11,'color','r','LineWidth',2)
hold on;
plot(xv00,yv00,'b:','LineWidth',2)
grid on;

% axis([150 550 150 1000])
% axis([350 700 350 700])
