clear all; close all; clc;

% Symmetric
picture=open('Asymmetric_DL.fig');
axs=get(gcf,'Children');
% you may have to start poking around at the different axs(n) to get the right one
pos=get(axs(2),'Children');
% same with the pos(n), especially if you labelled your plots or have more than one line
x1=get(pos(1),'Xdata');
y1=get(pos(1),'Ydata');

