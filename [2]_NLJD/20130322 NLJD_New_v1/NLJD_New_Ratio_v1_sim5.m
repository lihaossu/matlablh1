clear all; close all; clc

%% Initialize
% Number of Measurement Data
N = 50;
% Number of Frame
F = 1000;
% Deviation of Measurement
D_E_Ratio = 50;
D1 = D_E_Ratio;
D2 = 100-D1;
% Deviation of Real Data
R = 0;

% Error Rate %
E_Ratio = [0:10:100];

% Dummy
NLJD = zeros(F,1);
% Dummy
NLJD = zeros(F,1);
progressbar;
for idx_R = 1:length(E_Ratio)
    % Ratio
    N1 = (N*(100-E_Ratio(idx_R))/100);
    N2 = N - N1;
    
    Real_Data = ceil(R*randn(1,2))+[500 400];
    
    for idx_F = 1:F
        
        if Real_Data(1) >= Real_Data(2)
            % Device
            NLJD(idx_F) = 0;
            % Metal
        else NLJD(idx_F) = 1;
        end;
        
        Measurement_Data1 = [];
        Measurement_Data2 = [];
        Measurement_Data3 = [];
        % Correct Data
        for idx_First_N = 1:N1
            Measurement_Data1(idx_First_N,:) = ceil(D1*randn(1,2)+Real_Data);
        end;
        
        % Incorrect Data #1
        for idx_Second_N1 = 1:N2/2
            Measurement_Data2(idx_Second_N1,:) = ceil(D2*randn(1,2)+[Real_Data(2) Real_Data(1)]);
        end;
        
        % Incorrect Data #2
        for idx_Second_N2 = 1:N2/2
            Measurement_Data3(idx_Second_N2,:) = ceil(D2*randn(1,2)+[Real_Data(2) Real_Data(1)]);
        end;
        
        
        Measurement_Data = [Measurement_Data1; Measurement_Data2; Measurement_Data3];
        
        %% Fuzzy
        Measurement_Data_Fuzzy = [Measurement_Data];
        
        [center,U,objFcn] = fcm_1(Measurement_Data_Fuzzy,3);
        
        maxU = max(U);
        index1 = find(U(1,:) == maxU);
        index2 = find(U(2,:) == maxU);
        index3 = find(U(3,:) == maxU);
        
        aaa = [length(index1) length(index2) length(index3)];
        
        [value,position] = sort(aaa);
        
        Fuzzy_center = ceil(center(position(3),1:2));
        
        if Fuzzy_center(1) >= Fuzzy_center(2)
            % Device
            NLJD_Fuzzy_Center = 0;
            % Metal
        else NLJD_Fuzzy_Center = 1;
        end;
        
        %% Averaging
        Averaging = ceil(sum(Measurement_Data)/N);
        if Averaging(1) >= Averaging(2)
            % Device
            NLJD_Averaging = 0;
            % Metal
        else NLJD_Averaging = 1;
        end;
        
        % Detection
        Detection1(idx_F) = xor(NLJD(idx_F),NLJD_Fuzzy_Center);
        Detection2(idx_F) = xor(NLJD(idx_F),NLJD_Averaging);
        
        
        % Progressbar Count
        progress_count = idx_F/F;
        % Do something important
        pause(0.01)
        % Update figure
        progressbar(((idx_R-1)+progress_count)/(length(E_Ratio)));
        
        
    end;
    
    Err_Acc1(idx_R) = sum(Detection1)/F*100;
    Err_Acc2(idx_R) = sum(Detection2)/F*100;
    
end;

plot(E_Ratio,Err_Acc1,'bs-','LineWidth',2)
hold on
plot(E_Ratio,Err_Acc2,'ro-','LineWidth',2)

axis([1 E_Ratio(length(E_Ratio)) 0 100])
grid on
title('Micro-Electronic Devices Detection [Electronics]');
legend('Fuzzy','Averaging');
xlabel('Ratio of the Error');
ylabel('Classification Error Probability');

%%
figure()
plot([0:1:1000],[0:1:1000],'b:','LineWidth',2);
grid on;

hold on;

% Cluster
line(Measurement_Data_Fuzzy(index1,1),Measurement_Data_Fuzzy(index1,2),'linestyle',':','marker', '^','color','r','MarkerSize',7,'LineWidth',2);
line(Measurement_Data_Fuzzy(index2,1),Measurement_Data_Fuzzy(index2,2),'linestyle',':','marker', 'o','color','b','MarkerSize',7,'LineWidth',2);
line(Measurement_Data_Fuzzy(index3,1),Measurement_Data_Fuzzy(index3,2),'linestyle',':','marker', 's','color','m','MarkerSize',7,'LineWidth',2);
hold on

% Cluster Center
plot(center(1,1),center(1,2),'r^','markersize',7,'LineWidth',5)
plot(center(2,1),center(2,2),'bo','markersize',7,'LineWidth',5)
plot(center(3,1),center(3,2),'ms','markersize',7,'LineWidth',5)

xlabel('Second Harmonics');
ylabel('Third Harmonics');
hold on

plot(Real_Data(1),Real_Data(2),'kx','markersize',15,'LineWidth',5)
hold on
plot(Averaging(1),Averaging(2),'gd','markersize',10,'LineWidth',5)
hold on
plot(Fuzzy_center(1),Fuzzy_center(2),'c*','markersize',10,'LineWidth',5)

legend('Conventional D/B','Cluster 1','Cluster 2','Cluster 3','Center of Cluster 1','Center of Cluster 2','Center of Cluster 3','Real Data','Averaging','Proposed')

