clear all; close all; clc

%% Load Data
load Sample3.mat
% load Normal.mat
N = length(Data);
% Data = Metal - (repmat(sum(Normal)/length(Normal),length(Metal),1));
%% Simulation Part
Fuzzy_Choice = 3;

%% Fuzzy
Measurement_Data_Fuzzy = Data;

[center,U,objFcn] = fcm_1(Data,Fuzzy_Choice);

if Fuzzy_Choice == 2
    
    maxU = max(U);
    index1 = find(U(1,:) == maxU);
    index2 = find(U(2,:) == maxU);
    
    aaa = [length(index1) length(index2)];
    
elseif Fuzzy_Choice == 3;
    
    
    maxU = max(U);
    index1 = find(U(1,:) == maxU);
    index2 = find(U(2,:) == maxU);
    index3 = find(U(3,:) == maxU);
    
    aaa = [length(index1) length(index2) length(index3)];
    
end;

aaa = [length(index1) length(index2)];

[value,position] = sort(aaa);

Fuzzy_Center = ceil(center(position(end),1:2))
Averaging = ceil(sum(Data)/(length(Data)))

%% Fingerprinting Plot Properties

plot([0:1:4000],[0:1:4000],'b:','LineWidth',2);
grid on;

if Fuzzy_Choice == 3
    
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
    
    plot(Averaging(1),Averaging(2),'gd','markersize',10,'LineWidth',5)
    hold on
    plot(Fuzzy_Center(1),Fuzzy_Center(2),'c*','markersize',10,'LineWidth',5)
    
    legend('Conventional D/B','Cluster 1','Cluster 2','Cluster 3','Center of Cluster 1','Center of Cluster 2','Center of Cluster 3','Averaging','Proposed')
    
    
elseif Fuzzy_Choice == 2
    
    
    % Cluster
    line(Measurement_Data_Fuzzy(index1,1),Measurement_Data_Fuzzy(index1,2),'linestyle',':','marker', '^','color','r','MarkerSize',7,'LineWidth',2);
    line(Measurement_Data_Fuzzy(index2,1),Measurement_Data_Fuzzy(index2,2),'linestyle',':','marker', 'o','color','b','MarkerSize',7,'LineWidth',2);
    hold on
    
    % Cluster Center
    plot(center(1,1),center(1,2),'r^','markersize',7,'LineWidth',5)
    plot(center(2,1),center(2,2),'bo','markersize',7,'LineWidth',5)
    
    xlabel('Second Harmonics');
    ylabel('Third Harmonics');
    hold on
    
    plot(Averaging(1),Averaging(2),'gd','markersize',10,'LineWidth',5)
    hold on
    plot(Fuzzy_Center(1),Fuzzy_Center(2),'c*','markersize',10,'LineWidth',5)
    
    legend('Conventional D/B','Cluster 1','Cluster 2','Center of Cluster 1','Center of Cluster 2','Averaging','Proposed')
    
end;

%% Measurement 2nd & 3rd
figure()

plot(1:N,Data(:,1),'bs-','MarkerSize',10,'LineWidth',2)
hold on;
plot(1:N,Data(:,2),'ro-','MarkerSize',10,'LineWidth',2)
hold on
axis([1 N 0 4000])
grid on
legend('Second Harmonics','Third Harmonics');
xlabel('Number of Measurements');
ylabel('Decimal Amplitude of the Harmonics');
