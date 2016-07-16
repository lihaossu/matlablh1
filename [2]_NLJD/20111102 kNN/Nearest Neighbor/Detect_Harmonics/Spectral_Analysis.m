clear all; close all; clc;
%% Create signal.
F1 = 2E3; F2 = 3E3;
Fs = 10E3;
t = 0:1/Fs:.296;
A1 = 1; A2 = 4;

%% Generate Noise and Interference
% % Generate Noise
% Noise1 = sqrt(2).*(randn(1,length(t))).*a;
% Noise2 = sqrt(2).*(randn(1,length(t))).*a;

% Generate Interference
InterNoise1 = sqrt(1/2).*randn(1,length(t));
InterNoise2 = sqrt(1/2).*randn(1,length(t));

% F1 Hz Interferences
Inter1 = 10*rand.*cos(2*pi*t*F1);

% F2 Hz Interferences
Inter2 = 10*rand.*cos(2*pi*t*F2);

%% A cosine of F1 Hz and F2 Hz
a = 1*cos(2*pi*t*F1) + 4*cos(2*pi*t*F2);
Pxx0 = spectrum.welch;
% psd(Pxx0,a,'Fs',Fs);

% Received Signal
% Interference
x = a + Inter1 + Inter2; 
%% Spectrum Analysis
Hs = spectrum.welch;
psd(Hs,x,'Fs',Fs)
hold on
axis([0 5 -70 -0]);
