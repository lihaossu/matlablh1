%%%%%%% 2nd, 3rd Harmonics of 900 MHz %%%%%%%
% clear all; close all; clc;
%% Initialize
% Center Frequency
fc1 = 1.8E9; fc2 = 2.7E9;
% Sample Frequency
fs=60E9;
% Pulse delay times
D = [10:10:70]' * 1e-9;
% Width of each pulse
tc1 = gmonopuls('cutoff',fc1);
tc2 = gmonopuls('cutoff',fc2);
% Signal evaluation time
t1 = 0 : 1/fs : 400*tc1;
t2 = 0 : 1/fs : 400*tc2;
%% Generate Pulse
yp_1 = 2*pulstran(t1,D,@gmonopuls,fc1);
yp_2 = 3*pulstran(t2,D,@gmonopuls,fc2);
figure();
plot(t1,yp_1);
figure();
plot(t2,yp_2);
%% Generate Interference & Noise
yp_noise_1 = sqrt(1/2).*randn(1,length(t1));
yp_noise_2 = sqrt(1/2).*randn(1,length(t2));
Interference_1 = sqrt(1/2).*randn(1,length(t1)).*yp_1 + sqrt(1/2).*randn(1,length(t1));
Interference_2 = sqrt(1/2).*randn(1,length(t2)).*yp_2 + sqrt(1/2).*randn(1,length(t2));
% yp_noise_1 = 0;
% yp_noise_2 = 0;
%% Received Signal
yp_received_1 = yp_1 + Interference_1 + yp_noise_1;
yp_received_2 = yp_2 + Interference_2 + yp_noise_2;
% Construct a Welch spectrum object.
h = spectrum.welch('hamming',64);

hpsd1 = psd(h,yp_received_1,'fs',fs);
hpsd2 = psd(h,yp_received_2,'fs',fs);

Pxx1 = hpsd1.Data;
Pxx2 = hpsd2.Data;

W1 = hpsd1.Frequencies;
W2 = hpsd2.Frequencies;

hpsd = dspdata.psd([Pxx1,Pxx2],W1,'fs',fs);
plot(hpsd);
% hold on;
% plot(hpsd2);
hold on
legend('1.8 GHz','2.7 GHz');

axis([0 20 -130 -100]);