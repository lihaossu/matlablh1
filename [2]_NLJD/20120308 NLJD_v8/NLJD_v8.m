clear all; close all; clc;

%% Simulation Number
knn_simulation_no = 200;
frame = 100;

%% Load Training Data
load Training_40.mat

%% Calculate 
A = ceil(sum(Class1(:,1:2))/length(Class1));
B = ceil(sum(Class2(:,1:2))/length(Class2));
C = ceil(A+B)/2;

progressbar;
% kNN Factor
k = [3 5 7 9 11 13 15 17 19 21 23 25];

Measure_Deviation = 1000;
Noise_Deviation = 100;

for idx_k = 1:length(k)
    
    for idx_frame = 1:frame
        
        for idx_simulation = 1:knn_simulation_no
            
            % Measurement Data
            Measured(idx_simulation,1:2) = C + ceil(100.*randn(1,2));
                        
            % Initiate Measured Data Class
            if Measured(idx_simulation,1) > Measured(idx_simulation,2)
                Estimation(idx_simulation) = 0; % NLJD
            elseif Measured(idx_simulation,1) <= Measured(idx_simulation,2)
                Estimation(idx_simulation) = 1; % Metal
            end;
            
            Measured_Noise(idx_simulation,1:2) = Measured(idx_simulation,1:2) + ceil(sqrt(Noise_Deviation).*randn(1,2));
            class(idx_simulation) = kNN(k(idx_k),Measured_Noise(idx_simulation,1:2),Class1(:,1:2),Class2(:,1:2));
            
            if Measured_Noise(idx_simulation,1) > Measured_Noise(idx_simulation,2)
                Estimation2(idx_simulation) = 0; % NLJD
            elseif Measured_Noise(idx_simulation,1) <= Measured_Noise(idx_simulation,2)
                Estimation2(idx_simulation) = 1; % Metal
            end;
            
            progress_count = idx_simulation/knn_simulation_no;
            % Do something important
            pause(0.01)
            % Update figure
            progressbar(((idx_k-1)*frame+((idx_frame-1)+progress_count))/(length(k)*frame));
            
        Err_DL(idx_simulation) = xor(Estimation(idx_simulation),Estimation2(idx_simulation));
        Err_kNN(idx_simulation) = xor(Estimation(idx_simulation),class(idx_simulation));
        
        
        end;

        err_DL(idx_frame) = sum(Err_DL);
        err_kNN(idx_frame) = sum(Err_kNN);
        
    end;
    
    Prob_DL(idx_k) = (sum(err_DL) / (knn_simulation_no * frame)) * 100;
    Prob_knn(idx_k) = (sum(err_kNN) / (knn_simulation_no * frame)) * 100;
    
end;

% save Result_10.mat Result_10;

