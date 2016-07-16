clear all; close all; clc;
knn_simulation_no = 100;
frame = 10;

load Deviation_10.mat

A = ceil(sum(Class1(:,1:2))/length(Class1));
B = ceil(sum(Class2(:,1:2))/length(Class2));
C = ceil(A+B)/2;

progressbar;
% kNN Factor
k = 3:2:25;

for idx_k = 1:length(k)
    
    for idx_frame = 1:frame
        
        for idx_simulation = 1:knn_simulation_no
            
            Measured = ceil(C+sqrt(40)*randn(1,2));
            class = kNN(k(idx_k),Measured, Class1(:,1:2),Class2(:,1:2));
            
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
    
    Result_10(idx_k) = (sum(err) / (knn_simulation_no * frame)) * 100;
    
end;

save Result_10.mat Result_10;

