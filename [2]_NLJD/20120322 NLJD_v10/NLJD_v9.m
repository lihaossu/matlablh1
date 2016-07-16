clear all; close all; clc;

%% Simulation Number
knn_simulation_no = 100;
frame = 1;

%% Load Training Data
load Asymmetric_10.mat

%% Calculate 
A = ceil(sum(Class1(:,1:2))/length(Class1));
B = ceil(sum(Class2(:,1:2))/length(Class2));
C = ceil(A+B)/2;

progressbar;
% kNN Factor
k = [3 5 7 9 11 13 15 17 19 21 23 25];

Measure_Deviation = 1;
Noise_Deviation = 40;

for idx_k = 1:length(k)
    
    for idx_frame = 1:frame
        
        for idx_simulation = 1:knn_simulation_no
            
            % Measurement Data
            Measured(idx_simulation,1:2) = C + ceil(20.*randn(1,2));
            
                       
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
    
end;
% 
% Prob_DL
% Prob_FairvsDL
% Prob_knn
% Prob_Fairvsknn
% Prob_DLvskNN

save Result_Asymmetric_10.mat Prob_DL Prob_FairvsDL Prob_knn Prob_Fairvsknn Prob_DLvskNN