clear all; close all; clc;


load Measure_100.mat

%% Symetric
% load Second_1.TXT
% load Third_1.TXT
% 
% Training_Junction = [Second_1 Third_1];
% Training_Metal = [Third_1 Second_1];

%% Assymetric
load sample_2nd_RX_data4.TXT
load sample_3rd_RX_data4.TXT
load sample_2nd_RX_data5.TXT
load sample_3rd_RX_data5.TXT

Training_Junction = [sample_2nd_RX_data4 sample_3rd_RX_data4];
Training_Metal = [sample_2nd_RX_data5 sample_3rd_RX_data5];

% progressbar;
% kNN Factor
k = 3:2:25;

Measured = [Class1(:,1:2); Class2(:,1:2)];
Real = [Class1(:,3); Class2(:,3)];

for idx_k = 1:length(k)
    
    for idx_simulation = 1:length(Class1)+length(Class2)
        
        class(idx_simulation) = kNN(k(idx_k),Measured(idx_simulation,:),Training_Junction,Training_Metal);
        
        if Measured(idx_simulation,1) > Measured(idx_simulation,2)
            Decision_Level(idx_simulation) = 0; % NLJD
        elseif Measured(idx_simulation,1) < Measured(idx_simulation,2)
            Decision_Level(idx_simulation) = 1; % Metal
        end;
        
 
        %             progress_count = idx_simulation/length(A);
        %             % Do something important
        %             pause(0.01)
        %             % Update figure
        %             progressbar(((idx_k-1)*frame+((idx_frame-1)+progress_count))/(length(k)*frame));
       
               
    end;
    
    Result_DL = Decision_Level';
    Result_kNN = class';
    
    Err_DL = sum(xor(Real,Result_DL));
    Err_kNN = sum(xor(Real,Result_kNN));
    
    Probability_DL(idx_k) = Err_DL / (length(Class1)+length(Class2)) * 100;
    Probability_kNN(idx_k) = Err_kNN / (length(Class1)+length(Class2)) * 100;

end;

bar(k,Probability_kNN);

save Result_30.mat Probability_DL Probability_kNN;

