% This file is to generate the UWB pulse.
% Le Nhat Tan
% lenhattan86@gmail.com or lenhattan86@amcs.ssu.ac.kr
% CIP, SSU, Seoul, Korea
function pulse = UWB_Pulse(Fs, pw)
% Fs: Sampling rate
% pw: pulse width
t= [-pw/2+1/Fs:1/Fs:pw/2]; 
%% Gaussian Doublet
% tc = pw/2.5;
% pulse = A*(1 - 4*pi.*((t)/tc).^2).* exp(-2*pi.*((t)/tc).^2);
%% Gaussian Monocyle
tc = pw/1.24;
pulse = 2*(t/tc).* exp(-2*pi.*((t)/tc).^2);
%% Nomalize pulse to unit energy
A = 1/sqrt(sum(pulse.^2));
pulse = pulse.*A;
% plot(t,pulse);