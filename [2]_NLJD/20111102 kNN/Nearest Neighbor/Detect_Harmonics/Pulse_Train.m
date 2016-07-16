clear all;
close all;
clc

%% Square Pulse
fs = 100E9;                    % sample freq
D1 = [5:7.5:125]' * 1e-9;     % pulse delay times
D2 = [5:10:125]' * 1e-9;     % pulse delay times
D3 = [5:20:125]' * 1e-9;     % pulse delay times
t = 0 : 1/fs : 12500/fs;        % signal evaluation time
w1 = 0.1e-9;                      % width of each pulse
w2 = 0.2e-9;
w3 = 0.3e-9;
yp1 = pulstran(t,D1,@rectpuls,w1);
yp2 = pulstran(t,D2,@rectpuls,w2);
yp3 = pulstran(t,D3,@rectpuls,w3);

figure();
plot(t*1e9,yp1,t*1e9,yp2,t*1e9,yp3);axis([0 130 -0.2 1.2])
xlabel('Time (ns)'); ylabel('Amplitude'); title('Rectangular Train')
set(gcf,'Color',[1 1 1]);

%% Gaussian Pulse
% fs = 100E9;
% pw = 0.5e-9;
% D = [5:7.5:125]' * 1e-9;
% yp1 = pulstran(fs,D,@UWB_Pulse,pw)
% plot(yp1);
% axis([0 130 -0.2 1.2])
% xlabel('Time (ns)'); ylabel('Amplitude'); title('Rectangular Train')
% set(gcf,'Color',[1 1 1]);

%% Sawtooth
% fs = 100E9;                    % sample freq
% D1 = [5:15:125]' * 1e-9;     % pulse delay times
% t = 0 : 1/fs : 12500/fs;        % signal evaluation time
% w1 = 0.5e-9;                      % width of each pulse
% yp1 = pulstran(t,D1,@tripuls,w1);
% 
% figure();
% plot(t*1e9,yp1);
% % axis([0 130 -0.2 1.2]);
% xlabel('Time (ns)'); ylabel('Amplitude'); title('Sawtooth Train')
% set(gcf,'Color',[1 1 1]);

%% PSD #1
figure();
h = spectrum.welch('hamming',64);

hpsd1 = psd(h,yp1,'fs',fs);
hpsd2 = psd(h,yp2,'fs',fs);
hpsd3 = psd(h,yp3,'fs',fs);

Pxx1 = hpsd1.Data;
Pxx2 = hpsd2.Data;
Pxx3 = hpsd3.Data;

W = hpsd1.Frequencies;

Hpsd = dspdata.psd([Pxx1,Pxx2,Pxx3],W,'fs',fs);
% Hpsd = dspdata.psd(Pxx1,W,'fs',fs);
plot(Hpsd);
grid on;
legend('PW = 0.1 ns','PW = 0.2 ns','PW = 0.3 ns');
axis([0 30 -160 -100]);

%% PSD #2
% figure();
% psd1=spectrum(yp1,1024);
% specplot(psd1,fs)
% hold on;
% grid on;
% axis([0 10e9 10^-7 10]);