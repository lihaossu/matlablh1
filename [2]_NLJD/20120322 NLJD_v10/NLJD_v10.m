clear all; close all; clc;


%% Load Training Data
load Symmetric_40.mat

% Measurement Data
Measured = [Class1(:,1:2); Class2(:,1:2)];

%% Simulation Number
knn_simulation_no = length(Measured);
frame = 10;
%% Calculate
A = ceil(sum(Class1(:,1:2))/length(Class1));
B = ceil(sum(Class2(:,1:2))/length(Class2));
C = ceil(A+B)/2;

progressbar;
% kNN Factor
k = [3 5 7];

Measure_Deviation = 1;
Noise_Deviation = 40;

for idx_k = 1:length(k)

    for idx_frame = 1:frame
        
         % Fuzzy
        [center,U,objFcn] = fcm_1(Measured,2);

        maxU = max(U);
        for idx_fuzzy = 1:knn_simulation_no
            if U(1,idx_fuzzy) == maxU(idx_fuzzy)
                decision_fuzzy(idx_fuzzy) = 1;
            elseif U(2,idx_fuzzy) == maxU(idx_fuzzy)
                decision_fuzzy(idx_fuzzy) = 0;
            end;
        end;

        for idx_simulation = 1:knn_simulation_no

            % Initiate Measured Data Class
            %             if Measured(idx_simulation,1) <= Measured(idx_simulation,2)
            %                 Estimation(idx_simulation) = 0; % NLJD
            %             elseif Measured(idx_simulation,1) > Measured(idx_simulation,2)
            %                 Estimation(idx_simulation) = 1; % Metal
            %             end;

            % Faireness
            xv11 = [C(2)-C(2); C(2)+C(2); C(2)-C(2); C(2)-C(2)];
            yv11 = [C(1)-C(2); C(1)+C(2); C(1)+C(2); C(1)-C(2)];
            rd = Measured(idx_simulation,1); nd = Measured(idx_simulation,2);
            in11 = inpolygon(nd,rd,xv11,yv11);

            if in11 == 0
                Estimation(idx_simulation) = 0; % NLJD
            elseif in11 == 1
                Estimation(idx_simulation) = 1; % Metal
            end;

            Measured_Noise(idx_simulation,1:2) = Measured(idx_simulation,1:2) + ceil(sqrt(Noise_Deviation).*randn(1,2));
            
            % kNN
            class(idx_simulation) = kNN(k(idx_k),Measured_Noise(idx_simulation,1:2),Class1(:,1:2),Class2(:,1:2));

            % Faireness Decision Level
            xv22 = [C(2)-C(2); C(2)+C(2); C(2)-C(2); C(2)-C(2)];
            yv22 = [C(1)-C(2); C(1)+C(2); C(1)+C(2); C(1)-C(2)];
            rd2 = Measured_Noise(idx_simulation,1); nd2 = Measured_Noise(idx_simulation,2);
            in22 = inpolygon(nd2,rd2,xv22,yv22);

            if in22 == 0
                Estimation1(idx_simulation) = 0; % NLJD
            elseif in22 == 1
                Estimation1(idx_simulation) = 1; % Metal
            end;


            % Symmetric Decision Level
            if Measured_Noise(idx_simulation,1) <= Measured_Noise(idx_simulation,2)
                Estimation2(idx_simulation) = 0; % NLJD
            elseif Measured_Noise(idx_simulation,1) > Measured_Noise(idx_simulation,2)
                Estimation2(idx_simulation) = 1; % Metal
            end;

            progress_count = idx_simulation/knn_simulation_no;
            % Do something important
            pause(0.01)
            % Update figure
            progressbar(((idx_k-1)*frame+((idx_frame-1)+progress_count))/(length(k)*frame));

            Err_DL(idx_simulation) = xor(Estimation(idx_simulation),Estimation2(idx_simulation));
            Err_kNN(idx_simulation) = xor(Estimation(idx_simulation),class(idx_simulation));
            Err_FairvskNN(idx_simulation) = xor(Estimation1(idx_simulation),class(idx_simulation));
            Err_FairvsDL(idx_simulation) = xor(Estimation1(idx_simulation),Estimation2(idx_simulation));
            Err_DLvskNN(idx_simulation) = xor(Estimation2(idx_simulation),class(idx_simulation));


        end;

        err_fuzzy_vs_AdvancedDL(idx_frame) = sum(xor(decision_fuzzy,Estimation));
        err_fuzzy_vs_Fair(idx_frame) = sum(xor(decision_fuzzy,Estimation1));
        err_fuzzy_vs_FairDL(idx_frame) = sum(xor(decision_fuzzy,Estimation2));
        err_fuzzy_vs_kNN(idx_frame) = sum(xor(decision_fuzzy,class));
        
        
        err_DL(idx_frame) = sum(Err_DL);
        err_kNN(idx_frame) = sum(Err_kNN);
        err_FairvskNN(idx_frame) = sum(Err_FairvskNN);
        err_FairvsDL(idx_frame) = sum(Err_FairvsDL);
        err_DLvskNN(idx_frame) = sum(Err_DLvskNN);

    end;

    Prob_DL(idx_k) = (sum(err_DL) / (knn_simulation_no * frame)) * 100;
    Prob_knn(idx_k) = (sum(err_kNN) / (knn_simulation_no * frame)) * 100;
    Prob_Fairvsknn(idx_k) = (sum(err_FairvskNN) / (knn_simulation_no * frame)) * 100;
    Prob_FairvsDL(idx_k) = (sum(err_FairvsDL) / (knn_simulation_no * frame)) * 100;
    Prob_DLvskNN(idx_k) = (sum(err_DLvskNN) / (knn_simulation_no * frame)) * 100;

    Prob_fuzzy_vs_AdvancedDL(idx_k) = (sum(err_fuzzy_vs_AdvancedDL) / (knn_simulation_no * frame)) * 100;
    Prob_fuzzy_vs_Fair(idx_k) = (sum(err_fuzzy_vs_Fair) / (knn_simulation_no * frame)) * 100;
    Prob_fuzzy_vs_FairDL(idx_k) = (sum(err_fuzzy_vs_FairDL) / (knn_simulation_no * frame)) * 100;
    Prob_fuzzy_vs_kNN(idx_k) = (sum(err_fuzzy_vs_kNN) / (knn_simulation_no * frame)) * 100;
end;
%
% Prob_DL
% Prob_FairvsDL
% Prob_knn
% Prob_Fairvsknn
% Prob_DLvskNN
bar(k,Prob_fuzzy_vs_FairDL);
xlabel('k');
ylabel('Error');
% save Result_Asymmetric_40.mat Prob_DL Prob_FairvsDL Prob_knn Prob_Fairvsknn Prob_DLvskNN


index1 = find(U(1,:) == maxU);
index2 = find(U(2,:) == maxU);
figure
line(Measured_Noise(index1,1),Measured_Noise(index1,2),'linestyle','none','marker', 'x','color','r');
line(Measured_Noise(index2,1),Measured_Noise(index2,2),'linestyle','none','marker', 'o','color','b');

hold on

plot(center(1,1),center(1,2),'kx','markersize',15,'LineWidth',2)
plot(center(2,1),center(2,2),'yo','markersize',15,'LineWidth',2)

xlabel('Third Harmonics');
ylabel('Second Harmonics');

% axis([350 700 350 700])
% axis([150 550 150 1000])

grid on