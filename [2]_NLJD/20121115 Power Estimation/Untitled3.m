clear all; close all; clc;

%% Generate Pulse
fc = 2.4E9;  Fs=100E9;             % Center freq, sample freq
D = [1 2 3 4 5 6 7 8 9 10]' * 1e-9;       % Pulse delay times
tc = gmonopuls('cutoff',fc);     % Width of each pulse
t  = 0 : 1/Fs : 150*tc;          % Signal evaluation time
u = pulstran(t,D,@gmonopuls,fc);

%%
W = 1; % 1: 30dBm (W = 0.001 = 0 dBm)
dBm = 10*log10(W) + 30;

Noise_dB = 50;
SNR = dBm-Noise_dB; % dB scale (Noise = Negative)
No = W ./ (10.^(SNR/10));
n = sqrt(1/2 * No) * randn(size(u));

y = u + n;

%%
FIR_I = fir1(31,0.5);
d  = filter(FIR_I,1,u)+n;  % Desired signal
mu = 1/Fs;            % LMS step size. 
ha = adaptfilt.lms(64,mu); 
[y_Hat,e] = filter(ha,u,d); 

%% PSD
h = spectrum.welch;

Hpsd_Original=psd(h,u,'Fs',Fs);
p1 = plot(Hpsd_Original);
set(p1,'Color','b','LineStyle',':','LineWidth',1)

hold on;

Hpsd_Noise=psd(h,n,'Fs',Fs);
p2 = plot(Hpsd_Noise);
set(p2,'Color','r','LineStyle',':','LineWidth',1)

hold on

Hpsd_Received=psd(h,y,'Fs',Fs);
p3 = plot(Hpsd_Received);
set(p3,'Color','g','LineWidth',2)

hold on

Hpsd_LMS=psd(h,y_Hat,'Fs',Fs);
p4 = plot(Hpsd_LMS);
set(p4,'Color','c','LineWidth',2)

legend('Original','AWGN','w/ AWGN','LMS Filter')
axis([0 20 -350 -50])