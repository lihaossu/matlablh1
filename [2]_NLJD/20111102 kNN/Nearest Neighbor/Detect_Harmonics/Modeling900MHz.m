clear all;
close all;
clc

F = 900 * 10^6;
Fs = 900E6;   t = 0:1/Fs:0.0001;
x = cos(2*pi*t*F);
h = spectrum.welch;    % Create a Welch spectral estimator.

Hpsd = psd(h,x,'Fs',Fs);            % Calculate the PSD
plot(Hpsd)                          % Plot the PSD.

save('Modeling900MHz_Cos.mat','x');
% save('Modeling900MHz_PSD.mat','Hpsd');