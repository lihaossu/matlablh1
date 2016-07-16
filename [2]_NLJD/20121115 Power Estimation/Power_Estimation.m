clear all; close all; clc;

Fs = 10^3;
t = 0:1/Fs:1;
fc = 100;

W = 1; % 1: 30dBm (W = 0.001 = 0 dBm)
dBm = 10*log10(W) + 30;

Noise_dB = 50;
SNR = dBm-Noise_dB; % dB scale (Noise = Negative)
No = W ./ (10.^(SNR/10));

u = sqrt(1/2 * W) * cos(2*pi*fc*t) + sqrt(1/2 * W) * cos(2*pi*2*fc*t) + sqrt(1/2 * W) * cos(2*pi*3*fc*t);
n = sqrt(1/2 * No) * randn(size(t));

y = u + n;

%%
FIR_I = fir1(31,0.5);
d  = filter(FIR_I,1,u)+n;  % Desired signal
mu = 1/Fs;            % LMS step size. 
ha = adaptfilt.lms(16,mu); 
[y_Hat,e] = filter(ha,u,d); 

h = spectrum.welch;

%% Plot
% figure()
% 
% plot(t,u,'b:','LineWidth',2);
% 
% hold on
% 
% plot(t,n,'r:');
% 
% hold on
% 
% plot(t,y,'g-');
% 
% hold on
% 
% plot(t,y_Hat,'c-','LineWidth',2);
% 
% grid on

%% PSD
figure()

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
axis([0 400 -80 0])

%%
disp(['Tx Power = ', num2str(W), ' Watt (', num2str(dBm), ' dBm)'])
disp(['Noise Power = ', num2str(Noise_dB), ' dB'])