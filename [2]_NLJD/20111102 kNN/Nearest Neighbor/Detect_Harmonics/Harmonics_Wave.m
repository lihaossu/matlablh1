clear all;
close all;
clc

t=[0:0.01:8];
T=8;
f0=1/T;
w0=2*pi*f0;
A=2/pi;
y0=zeros(1,length(t));
y1=A/1*sin(1*w0*t);
y2=A/2*sin(2*w0*t);
y3=A/3*sin(3*w0*t);
y=y0+y1+y2+y3;
plot(t,y,t,y0,t,y1,t,y2,t,y3);
