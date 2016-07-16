clear all; close all; clc;

load Memory1.mat

Data = Memory_1;

plot(1:length(Data),Memory_1(:,1),'bs-','LineWidth',2);
hold on;
plot(1:length(Data),Memory_1(:,2),'ro-','LineWidth',2);
grid on;

axis([0 length(Data) 1000 4000])

figure()
plot(Data(:,1),Data(:,2),'o');
hold on
plot(1:4000,1:4000,'r:')
grid on;
axis([0 4000 0 4000]);