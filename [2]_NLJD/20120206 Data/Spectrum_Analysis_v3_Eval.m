clear all; close all; clc;
%% Create signal.

knn_simulation_no = 100;
frame = 1;

load sample_data1.txt
load sample_data2.txt

Elect = [sample_data1 sample_data2];
Metal = [sample_data2 sample_data1];

figure();
progressbar;
% kNN Factor
k = [3 5 7 9 11 13 15];

for idx_k = 1:length(k)
    
    for idx_frame = 1:frame
        
        for idx_simulation = 1:knn_simulation_no
            
            Measured = 530+randn(1,2);
            class = kNN(k(idx_k),Measured,Elect,Metal);
            
            if Measured(1) > Measured(2)
                Estimation = 0; % NLJD
            elseif Measured(1) < Measured(2)
                Estimation = 1; % Metal
            end;
            
            Err_knn(idx_simulation) = xor(class,Estimation);
            
            progress_count = idx_simulation/knn_simulation_no;
            % Do something important
            pause(0.01)
            % Update figure
            progressbar(((idx_k-1)*frame+((idx_frame-1)+progress_count))/(length(k)*frame));
            
        end;
        
        err(idx_frame) = sum(Err_knn);
        
    end;
    
    Training_20(idx_k) = (sum(err) / (knn_simulation_no * frame)) * 100
    
end;


figure();
for idx_Class1 = 1:size(Elect,1)
    plot(Elect(idx_Class1,1),Elect(idx_Class1,2),'rs','LineWidth',2,'MarkerSize',3);
    hold on;
end;

% Class2 Plot
for idx_Class2 = 1:size(Metal,1)
    plot(Metal(idx_Class2,1),Metal(idx_Class2,2),'bo','LineWidth',2,'MarkerSize',3);
    hold on;
end;

plot(Measured(1),Measured(2),'go','LineWidth',2,'MarkerSize',3);
grid on
axis([350 700 350 700])
xlabel('Second Harmonics');
ylabel('Third Harmonics');

save Training_20.mat Training_20;

