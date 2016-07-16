clear all; close all; clc

%% Initialize
% Number of Measurement Data
N = [10:10:50];
% Number of Frame
F = 100;
% Deviation of Measurement
D = 100;
% Deviation of Real Data
R = 1000;

% Dummy
NLJD = zeros(F,1);
NLJD_Fuzzy = zeros(F,1);
Detection = zeros(F,1);
Err_Acc = zeros(length(N),1);

%% Simulation Part
progressbar;

for idx_Simulation = 1:length(N)
    
    for idx_F = 1:F
        Real_Data = [500 500] + ceil(50*randn(1,2));
        
        if Real_Data(1) >= Real_Data(2)
            % Device
            NLJD = 0;
            % Metal
        else NLJD = 1;
        end;
        
        for idx_N = 1:N(idx_Simulation)
            Measurement_Data(idx_N,:) = ceil(D*randn(1,2)+Real_Data);
        end;
        
        % Fuzzy Center
        [center,U,objFcn] = fcm_1(Measurement_Data,3);
        maxU = max(U);
        index1 = find(U(1,:) == maxU);
        index2 = find(U(2,:) == maxU);
        index3 = find(U(3,:) == maxU);
        %
        % if length(index1) > length(index2)
        %     Fuzzy_Center = center(1,1:2);
        % else Fuzzy_Center = center(2,1:2);
        % end;
        
        aaa = [length(index1) length(index2) length(index3)];
        
        [value,position] = sort(aaa);
        
        Fuzzy_center = (center(position(3),1:2) + center(position(2),1:2))/2;
        
        if Fuzzy_center(1) >= Fuzzy_center(2)
            % Device
            NLJD_Fuzzy_Center = 0;
            % Metal
        else NLJD_Fuzzy_Center = 1;
        end;
        
        % Fuzzy Distance
        
        
        % Averaging
        Averaging = sum(Measurement_Data)/N(idx_Simulation);
        if Averaging(1) >= Averaging(2)
            % Device
            NLJD_Averaging = 0;
            % Metal
        else NLJD_Averaging = 1;
        end;
        
        % Detection
        Detection1(idx_F) = xor(NLJD,NLJD_Fuzzy_Center);
       
        Detection3(idx_F) = xor(NLJD,NLJD_Averaging);
        
        % Progressbar Count
        progress_count = idx_F/F;
        % Do something important
        pause(0.01)
        % Update figure
        progressbar(((idx_Simulation-1)+progress_count)/(length(N)));
        
    end;
    
    Err_Acc1(idx_Simulation) = sum(Detection1);
%     Err_Acc2(idx_Simulation) = sum(Detection2);
    Err_Acc3(idx_Simulation) = sum(Detection3);
    
end;

Fuzzy = Err_Acc1/F*100;
% Error2 = Err_Acc2/F*100;
Averaging = Err_Acc3/F*100;

Error = [Averaging' Fuzzy'];
bar(N,Error)

% axis([N(1)-3 N(length(N))+3 0 100])
xlabel('Number of Measurement Data');
ylabel('Classification Error Probability (%)');
grid on
legend('Averaging','Fuzzy Center');