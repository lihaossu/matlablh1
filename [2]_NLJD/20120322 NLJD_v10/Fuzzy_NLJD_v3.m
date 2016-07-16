clear all;
close all;
clc;

load Symmetric_40.mat

Data1 = [Class1(:,1:2); Class2(:,1:2)];

A = ceil(sum(Class1(:,1:2))/length(Class1));
B = ceil(sum(Class2(:,1:2))/length(Class2));
C = ceil(A+B)/2;

N = 10000;

for idx = 1:N
    Measured(idx,1:2) = C + ceil(20.*randn(1,2));
end;


Data = [Data1; Measured];



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

xlabel('Third Harmonics');
ylabel('Second Harmonics');

% axis([350 700 350 700])
axis([150 550 150 1000])

grid on