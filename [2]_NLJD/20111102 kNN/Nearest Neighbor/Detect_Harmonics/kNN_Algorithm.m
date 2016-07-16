clear all;
close all;
clc;

%% Make the Harmonics
Fs = 1000;   t = 0:1/Fs:.296;
A = 5;
B = 5;
x = A*(cos(2*pi*t*200)+randn(size(t))) + B*(cos(2*pi*t*400)+randn(size(t)));
h = spectrum.welch;    % Create a Welch spectral estimator.

Hpsd = psd(h,x,'Fs',Fs);            % Calculate the PSD
plot(Hpsd);                          % Plot the PSD.
grid on;
axis([0 500 -20 0])