clear all;
close all;
clc;

load Asymmetric_40.mat

Data = [Class1(:,1:2); Class2(:,1:2)];

plot(Data(:,1),Data(:,2),'o')

[center,U,objFcn] = fcm_1(Data,2);

figure
plot(objFcn)
title('Objective Function Values')
xlabel('Iteration Count')
ylabel('Objective Function Value')

maxU = max(U);
index1 = find(U(1,:) == maxU);
index2 = find(U(2,:) == maxU);
figure
line(Data(index1,1),Data(index1,2),'linestyle','none','marker', 'x','color','r');
line(Data(index2,1),Data(index2,2),'linestyle','none','marker', 'o','color','b');

hold on

plot(center(1,1),center(1,2),'kx','markersize',15,'LineWidth',2)
plot(center(2,1),center(2,2),'yo','markersize',15,'LineWidth',2)

xlabel('Second Harmonics');
ylabel('Third Harmonics');

axis([100 600 0 1000])


grid on