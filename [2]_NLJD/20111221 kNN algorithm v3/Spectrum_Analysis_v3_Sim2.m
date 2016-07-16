clear all; close all; clc;
%% Create signal.
F1 = 2E3; F2 = 3E3;
Fs = 10E3;
t = 0:1/Fs:.296;

knn_simulation_no = 1000;
frame = 100;

load training_database_40.mat

progressbar;
% kNN Factor
k = [3 5 7 9 11 13 15];

for idx_k = 1:length(k)
    
    for idx_frame = 1:frame
        
        for idx_simulation = 1:knn_simulation_no
            
            Measured = 10*rand(1,2);
            class = kNN(k(idx_k),Measured,NLJD,Metal);
            
            if Measured(1) > Measured(2)
                Estimation_2 = 0; % NLJD
            elseif Measured(1) < Measured(2)
                Estimation_2 = 1; % Metal
            end;
            
            Err_knn(idx_simulation) = xor(class,Estimation_2);
            
            progress_count = idx_simulation/knn_simulation_no;
            % Do something important
            pause(0.01)
            % Update figure
            progressbar(((idx_k-1)*frame+((idx_frame-1)+progress_count))/(length(k)*frame));
            
        end;
        
        err(idx_frame) = sum(Err_knn);
        
    end;
    
    Training_40(idx_k) = (sum(err) / (knn_simulation_no * frame)) * 100;
    
end;

save Training_40.mat Training_40;

