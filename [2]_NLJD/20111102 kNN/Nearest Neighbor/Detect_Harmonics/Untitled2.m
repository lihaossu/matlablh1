clear all;
close all;
clc;

N = 1024; %% we need 1024 point fft
fs = 100e7; %% sampling frequency of the system
fb = 9e6;  %% fundamental frequency 50 Hz
t = linspace(0,N/fs - 1/fs,N);
x = 0.3*cos(2*pi*fb*t)+      ...
    0.3*cos(2*pi*2*fb*t)+    ...
    0.3*cos(2*pi*3*fb*t)+    ...
    0.3*cos(2*pi*4*fb*t)+    ...
    0.3*cos(2*pi*5*fb*t)+    ...
    0.3*cos(2*pi*6*fb*t)+    ...
    0.3*cos(2*pi*7*fb*t)+    ...
    0.3*cos(2*pi*8*fb*t);
fft_x = fft(x);
plot((0:N-1)*fs/N, abs(fft_x));

