clear all; close all; clc;

Fs = 10^3; t = 0:1/Fs:1; fc = 100;
N = 128;
%% AWGN
n = sqrt(1/2)*randn(1,N);

%% Signal
w1 = 0.2;
w2 = 0.3;
a = 0.1 * sin(w1*pi*2*fc*t) + sin(w1*pi*2*fc*t);

result = welch(a);
plot(result)