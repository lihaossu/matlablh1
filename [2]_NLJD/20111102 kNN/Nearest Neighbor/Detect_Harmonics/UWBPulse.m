% This file is to generate the UWB pulse.
% Le Nhat Tan
% lenhattan86@gmail.com or lenhattan86@amcs.ssu.ac.kr
% CIP, SSU, Seoul, Korea
% function pulse = UWBPulse(Fs, pw)

clear all;
clc

% Fs: Sampling rate
% pw: pulse width
Fs=100e9;
pw1=.2e-9;
pw2=.5e-9;
t=-1e-9:1/Fs:1e-9;
% t= [-pw/2+1/Fs:1/Fs:pw/2]; 
tc1 = pw1/2.5;
tc2 = pw2/2.5;
%% Gaussian Doublet
% pulse = (1 - 4*pi.*((t)/pw).^2).* exp(-2*pi.*((t)/pw).^2);
% pulse = A*(1 - 4*pi.*((t)/tc).^2).* exp(-2*pi.*((t)/tc).^2);
%% Gaussian Monocyle
pulse1 = 2*(t/tc1) .* exp(-2*pi.*(t/tc1).^2);
pulse2 = 2*(t/tc2) .* exp(-2*pi.*(t/tc2).^2);
% pulse = 2*(t/tc) .* exp(-2*pi.*((t)/tc).^2);
%% Nomalize pulse to unit energy
% A1 = 1/sqrt(sum(pulse1.^2));
% A2 = 1/sqrt(sum(pulse2.^2));
% I1= sqrt(A1).*randn(1,length(t)).*pulse1;
% I2= sqrt(A2).*randn(1,length(t)).*pulse2;
% pulse1 = pulse1.*A1 + I1;
% pulse2 = pulse2.*A2 + I2;

%% Graph 1 - Pulse
figure();
plot(t,pulse1,'b');
hold on
plot(t,pulse2,'r');
grid on
legend('0.2 ns','0.5 ns');
% axis([-1e-9 1e-9 -0.4 0.4])
%% Graph 2 - PSD
figure();
h = spectrum.welch('hamming',128);

hpsd1 = psd(h,pulse1,'Fs',Fs);
hpsd2 = psd(h,pulse2,'Fs',Fs);

Pxx1 = hpsd1.Data;
Pxx2 = hpsd2.Data;
W = hpsd1.Frequencies;
Hpsd = dspdata.psd([Pxx1,Pxx2],W,'Fs',Fs);
plot(Hpsd);
grid on;
legend('0.2 ns','0.5 ns');
% axis([1 4 -170 -100]);

%% Graph 3 - PSD
% figure();
% p=spower(pulse);
% psd=spectrum(pulse,1024);
% specplot(psd,Fs)
% grid on;
