%%%%%%% Parameter %%%%%%%%
% kNN Factor
% Standard Deviation
% Number of Training Data
% Simulation Number
% Data Mode
%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all; clc;

%% Important Parameter
% kNN Factor
k = 3:6:51;
% Standard Deviation
Standard_Measure = 30;
Standard_Noise = 2;
% Standard deviation of the training data
Training_Standard_Deviation = 50;
% Number of training data (if 50, the Total Traning Data is 100)
Number_of_Training_Data = 100;

%% Simulation Number
knn_simulation_no = 10;
frame = 10;

%% Initialize the Coordination of Training Data (Data Generator)
%1 : Symmetric, 2 : Asymmetric

Data_Mode = 2;
if Data_Mode == 1
    % Symmetric
    Metal_x = 700; Metal_y = 300;% modify the distance between Metal_x and Metal_y can change the Degree of Precison in MLP.And also we can generate the total data by randon (lh) 
    Electronic_x = 300; Electronic_y = 700;
elseif Data_Mode == 2
    % Asymmetric
    Metal_x = 400; Metal_y = 100;
    Electronic_x = 200; Electronic_y = 900;
end; 

%% Dummy
Fairness_Estimation = zeros(1,knn_simulation_no);
Symmetric_Estimation = zeros(1,knn_simulation_no);
kNN_Class = zeros(1,knn_simulation_no);
fuzzy_Class = zeros(1,knn_simulation_no);
MLP_Class = zeros(1,knn_simulation_no);

Err_Fairness_Symmetric = zeros(1,knn_simulation_no);
Err_kNN_Class_Symmetric = zeros(1,knn_simulation_no);
Err_fuzzy_Class_Symmetric = zeros(1,knn_simulation_no);
Err_MLP_Class_Symmetric = zeros(1,knn_simulation_no);
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

%% Simulation
progressbar;
for idx_k = 1:length(k)
    for idx_frame = 1:frame
        % Simulation Count
        for idx_simulation = 1:knn_simulation_no
            
            % Generate the Metal and NLJ Training Data
            Metal = [ceil(Metal_x+Training_Standard_Deviation*randn(Number_of_Training_Data,1)) ceil(Metal_y+Training_Standard_Deviation*randn(Number_of_Training_Data,1))];
            NLJ = [ceil(Electronic_x+Training_Standard_Deviation*randn(Number_of_Training_Data,1)) ceil(Electronic_y+Training_Standard_Deviation*randn(Number_of_Training_Data,1))];
            
            % Initialize the NLJ to Class1 and Metal to Class2
            Class1 = [NLJ zeros(length(NLJ),1)];
            Class2 = [Metal ones(length(Metal),1)];
            
            % Calculate the center of total training data
            A = ceil(sum(Class1(:,1:2))/length(Class1));
            B = ceil(sum(Class2(:,1:2))/length(Class2));
            C = ceil(A+B)/2;
            
            %% Measure the concealed-device
            Measured = ceil(C+Standard_Measure*randn(1,2));
            Measured_Noise = Measured + ceil(Standard_Noise*randn(1,2));
            
            %% Symmetric D/L
            if Measured(1) <= Measured(2)
                Symmetric_Estimation = 0; % NLJD
            elseif Measured(1) > Measured(2)
                Symmetric_Estimation = 1; % Metal
            end;
            
            %% Faireness D/L
            xv11 = [C(1)-C(2); C(1)+C(2); C(1)+C(2); C(1)-C(2)];
            yv11 = [C(2)-C(2); C(2)+C(2); C(2)-C(2); C(2)-C(2)];
                       
            in11 = inpolygon(Measured(1),Measured(2),xv11,yv11);
            if in11 == 0
                Fairness_Estimation = 0; % NLJD
            elseif in11 == 1
                Fairness_Estimation = 1; % Metal
            end;
            
            %% Fuzzy c-means D/L
           
            % Generate Database for Fuzzy
            fuzzy_Data = 100;
            Measured_rand = repmat(C,fuzzy_Data,1) + 100.*randn(fuzzy_Data,2);
            Database = [Class1(:,1:2); Class2(:,1:2); Measured_rand];

            % Execute Fuzzy
            [center,U,objFcn] = FCM_NLJD(Database,2);
            maxU = max(U);
            index1 = find(U(1,:) == maxU);
            index2 = find(U(2,:) == maxU);
            
            % Make a Cluster
            if sum(Database(index1,1))/length(Database(index1,1)) <= sum(Database(index1,2))/length(Database(index1,2)) && ...
                sum(Database(index2,1))/length(Database(index2,1)) > sum(Database(index2,2))/length(Database(index2,2))
                fuzzy_cluster1 = Database(index1,1:2); % NLJ
                fuzzy_cluster2 = Database(index2,1:2); % Metal
            
            elseif sum(Database(index1,1))/length(Database(index1,1)) > sum(Database(index1,2))/length(Database(index1,2)) && ...
                    sum(Database(index2,1))/length(Database(index2,1)) <= sum(Database(index2,2))/length(Database(index2,2))
                fuzzy_cluster1 = Database(index2,1:2); % NLJ
                fuzzy_cluster2 = Database(index1,1:2); % Metal
            end;%
            fuzzy_Class = kNN_NLJD(k(idx_k),Measured,fuzzy_cluster1,fuzzy_cluster2);% Measured 
%             %% MLP D/L
%             Multi_Class = MLP_NLJD(Measured,Class1,Class2);
            %% kNN Classification and Decision
            kNN_Class = kNN_NLJD(k(idx_k),Measured_Noise,Class1(:,1:2),Class2(:,1:2));
                        
            % Progress Bar
            progress_count = idx_simulation/knn_simulation_no;
            % Do something important
            pause(0.01)
            % Update figure
            progressbar(((idx_k-1)*frame+((idx_frame-1)+progress_count))/(length(k)*frame));
            
            % Error Count of the Symmetric D/L
            Err_kNN_Class_Symmetric(idx_simulation) = xor(Symmetric_Estimation,kNN_Class);
            % Error Count of the Fairness D/L
            Err_kNN_Class_Fairness(idx_simulation) = xor(Fairness_Estimation,kNN_Class);
            % Error Count of the Fuzzy D/L
            Err_kNN_Fuzzy(idx_simulation) = xor(fuzzy_Class,kNN_Class);
%             % Error Count of the MLP D/L
%             Err_kNN_MLP(idx_simulation) = xor(Multi_Class,kNN_Class);
            
        end;
        
        % Accumulate Error Count of the Symmetric D/L
        Acc_kNN_Class_Symmetric(idx_frame) = sum(Err_kNN_Class_Symmetric);
        % Accumulate Error Count of the Faireness D/L
        Acc_kNN_Class_Fairness(idx_frame) = sum(Err_kNN_Class_Fairness);
        % Accumulate Error Count of the Fuzzy D/L
         Acc_kNN_Fuzzy(idx_frame) = sum(Err_kNN_Fuzzy);
         % Accumulate Error Count of the MLP D/L
          Acc_kNN_MLP(idx_frame) = sum(Err_kNN_MLP);
        
    end;
    
    % Probability Error of the Symmetric D/L
    Prob_kNN_Class_Symmetric(idx_k) = (sum(Acc_kNN_Class_Symmetric) / (knn_simulation_no * frame)) * 100;
    % Probability Error of the Fairness D/L
    Prob_kNN_Class_Fairness(idx_k) = (sum(Acc_kNN_Class_Fairness) / (knn_simulation_no * frame)) * 100;
    % Probability Error of the Fuzzy D/L
     Prob_kNN_Fuzzy(idx_k) = (sum(Err_kNN_Fuzzy) / (knn_simulation_no * frame)) * 100;
     %
       Prob_kNN_MLP(idx_k) = (sum(Err_kNN_MLP) / (knn_simulation_no * frame)) * 100;
    
end;

plot_data = [Prob_kNN_Class_Symmetric' Prob_kNN_Class_Fairness' Prob_kNN_Fuzzy' Prob_kNN_MLP];

bar(k,plot_data);
legend('Conventional D/L','Proposed 1 (Fairness)','Proposed 2 (Fuzzy)','Proposed 3 (MLP)');
axis([1 53 0 50]);
grid on;

figure
plot(Database(:,1), Database(:,2),'o');
hold on;
line(Database(index1,1),Database(index1,2),'marker','*','color','g');
line(Database(index2,1),Database(index2,2),'marker','*','color','r');
% Plot the cluster centers
plot([center([1 2],1)],[center([1 2],2)],'*','color','k')
hold on
plot(xv11,yv11,'LineWidth',3);
grid on;
%axis([0 1000 0 1000])