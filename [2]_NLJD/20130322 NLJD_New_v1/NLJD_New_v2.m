clear all; close all; clc

%% Load Data
load Sample3.mat
% load Normal.mat
N = length(Data);
% Data = Metal - (repmat(sum(Normal)/length(Normal),length(Metal),1));
%% Simulation Part

[center,U,objFcn] = fcm_1(Data,2);
    
maxU = max(U);
index1 = find(U(1,:) == maxU);
index2 = find(U(2,:) == maxU);
% index3 = find(U(3,:) == maxU);
% 
% if length(index1) > length(index2)
%     Fuzzy_Center = center(1,1:2);
% else Fuzzy_Center = center(2,1:2);
% end;

% aaa = [length(index1) length(index2) length(index3)];
aaa = [length(index1) length(index2)];

[value,position] = sort(aaa);

% Fuzzy_Center = ceil((center(position(3),1:2) + center(position(2),1:2))/2)
Fuzzy_Center = ceil(center(position(length(aaa)),1:2))
Averaging = ceil(sum(Data)/(length(Data)))

%% Fingerprinting Plot Properties
figPosition = 1;
axis([0 4000 0 4000]);
set(figPosition,'Position', [450, 550, 550, 450]);

plot([0:1:4000],[0:1:4000],'b:','LineWidth',2);
hold on;

line(Data(index1,1),Data(index1,2),'linestyle','none','marker', '^','color','r','MarkerSize',10,'LineWidth',5);
line(Data(index2,1),Data(index2,2),'linestyle','none','marker', 'o','color','b','MarkerSize',10,'LineWidth',5);
% line(Data(index3,1),Data(index3,2),'linestyle','none','marker', 's','color','y','MarkerSize',10,'LineWidth',5);
hold on

plot(center(1,1),center(1,2),'k^','markersize',15,'LineWidth',5)
plot(center(2,1),center(2,2),'go','markersize',15,'LineWidth',5)
% plot(center(3,1),center(3,2),'cs','markersize',15,'LineWidth',5)
grid on

axis([0 4000 0 4000]);

xlabel('Second Harmonics');
ylabel('Third Harmonics');

%% Measurement 2nd & 3rd 
figure()

plot(1:N,Data(:,1),'bs-')
hold on;
plot(1:N,Data(:,2),'ro-')
hold on
axis([1 N 0 4000])
grid on
title('Micro-Electronic Devices Detection [Electronics]');
legend('Second Harmonics','Third Harmonics');
xlabel('Number of Measurements');
ylabel('Decimal Amplitude of the Harmonics');
