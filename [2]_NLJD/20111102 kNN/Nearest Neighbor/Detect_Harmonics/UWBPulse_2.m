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
pw=.3e-9;
t=-1e-9:1/Fs:1e-9;

% t= [-pw/2+1/Fs:1/Fs:pw/2]; 
%% Gaussian Doublet
tc = pw/1.24;
% pulse = (1 - 4*pi.*((t)/pw).^2).* exp(-2*pi.*((t)/pw).^2);
% pulse = A*(1 - 4*pi.*((t)/tc).^2).* exp(-2*pi.*((t)/tc).^2);
%% Gaussian Monocyle
pulse = 2*(t/tc) .* exp(-2*pi.*(t/tc).^2);
% pulse = 2*(t/tc) .* exp(-2*pi.*((t)/tc).^2);
%% Nomalize pulse to unit energy
A = 1/sqrt(sum(pulse.^2));
N = A.*randn(1,length(t));
pulse = pulse.*A;

%% Graph 1 - Pulse
figure();
plot(t,pulse);
grid on;
% axis([-1e-9 1e-9 -0.4 0.4])
%% Graph 2 - PSD
figure();
h = spectrum.welch('hamming',64);
hpsd = psd(h,pulse,'Fs',Fs);
Pxx = hpsd.Data;
W = hpsd.Frequencies;
Hpsd = dspdata.psd(Pxx,W,'Fs',Fs);
plot(Hpsd);
grid on;
axis([0 8 -170 -100]);

%% Graph 3 - PSD
% figure();
% p=spower(pulse);
% psd=spectrum(pulse,1024);
% specplot(psd,Fs)
% grid on;