clear all;
close all;
clc

Fs = 900e6;
t = 0:1/Fs:0.001;
x = cos(2*pi*t*Fs);
h = spectrum.welch;    % Create a Welch spectral estimator.

Hpsd = psd(h,x,'Fs',Fs);            % Calculate the PSD
plot(Hpsd)                          % Plot the PSD.

% save('Modeling900MHz_Cos.mat','x');
% save('Modeling900MHz_PSD.mat','Hpsd');