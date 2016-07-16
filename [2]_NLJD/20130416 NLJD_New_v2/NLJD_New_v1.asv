clear all; close all; clc

%% Initialize
% Number of Measurement Data
N = 50;
% Number of Frame
F = 1;
% Deviation of Measurement
D_E_Ratio = 50;
D1 = D_E_Ratio;
D2 = 100-D1;
% Deviation of Real Data
R = 100;

% Error Rate %
E_Ratio = 40;
% Ratio
N1 = (N*(100-E_Ratio)/100);
N2 = N - N1;

% Dummy
NLJD = zeros(F,1);

%% Simulation Part

for idx_F = 1:F
    
    Real_Data = [300 600]
    
    if Real_Data(2) >= Real_Data(1)
        % Device
        NLJD(idx_F) = 0;
        % Metal
    else NLJD(idx_F) = 1;
    end;
    
    % Correct Data
    for idx_First_N = 1:N1
        Measurement_Data1(idx_First_N,:) = ceil(D1*randn(1,2)+Real_Data);
        
    end;
    
    % Incorrect Data
    for idx_Second_N = 1:N2/2
        Measurement_Data2(idx_Second_N,:) = ceil(D2*randn(1,2)+[900 300]);
    end;
    
    for idx_Second_N = 1:N2/2
        Measurement_Data3(idx_Second_N,:) = ceil(D2*randn(1,2)+[600 300]);
    end;
    
    Measurement_Data = [Measurement_Data1; Measurement_Data2; Measurement_Data3];
    
    
    Measurement_Data_Fuzzy = [Measurement_Data];
    
    [center,U,objFcn] = fcm_1(Measurement_Data_Fuzzy,3);
    
    figure
    plot(objFcn)
    title('Objective Function Values')
    xlabel('Iteration Count')
    ylabel('Objective Function Value')
    
    
end;



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

% Fuzzy_Center = ceil((center(position(3),1:2) + center(position(2),1:2))/2)
Fuzzy_Center = ceil(center(position(3),1:2))
Averaging = ceil(sum(Measurement_Data)/N)

%%
% Fingerprinting Plot Properties
% figPosition = 1;
% axis([0 1000 0 1000]);
% set(figPosition,'Position', [450, 550, 550, 450]);
% hold on

%%
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
plot(Fuzzy_Center(1),Fuzzy_Center(2),'c*','markersize',10,'LineWidth',5)

legend('Conventional D/B','Cluster 1','Cluster 2','Cluster 3','Center of Cluster 1','Center of Cluster 2','Center of Cluster 3','Real Data','Averaging','Proposed')


%% Measurement 2nd & 3rd
figure()

plot(1:N,Measurement_Data(:,1),'bs:','MarkerSize',10,'LineWidth',2)
hold on;
plot(1:N,Measurement_Data(:,2),'ro:','MarkerSize',10,'LineWidth',2)

axis([1 N 0 1000])
grid on
title('Micro-Electronic Devices Detection [Electronics]');
legend('Second Harmonics','Third Harmonics');
xlabel('Number of Measurements');
ylabel('Decimal Amplitude of the Harmonics');

%%
figure()
line(Measurement_Data1(:,1),Measurement_Data1(:,2),'linestyle','none','marker', 's','color','r','MarkerSize',10,'LineWidth',2);
hold on
line(Measurement_Data2(:,1),Measurement_Data2(:,2),'linestyle','none','marker', 'o','color','b','MarkerSize',10,'LineWidth',2);
grid on
axis([0 1000 0 1000]);
hold on
plot([1:1:1000],[1:1:1000],'r:','LineWidth',3)
xlabel('Second Harmonics');
ylabel('Third Harmonics');