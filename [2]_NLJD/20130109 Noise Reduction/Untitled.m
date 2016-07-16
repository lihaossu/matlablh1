clear all; close all; clc;

%% Initialize the Frequency (Fundamental Frequency)
Fs = 10^3; t = 0:1/Fs:0.3; fc = 100;

%% Phase #1 (Problem and Solution of #1)

% Power (Watt)
W = 1;
% Watt -> dBm
dBm = 10*log10(W) + 30; 
% Noise Power (dB)
Noise_dB = 20;
% Signal Power
SNR = dBm-Noise_dB; % dB scale (Noise = Negative)
No = W ./ (10.^(SNR/10));
% Tx Second Harmonics
S = W * cos(2*pi*2*fc*t);
N = sqrt(1/2 * No) * randn(size(t));
% Received Signal
R = S + N;


%% Phase #2
W2 = 0.1;
dBm_2 = 10*log10(W2) + 30;
SNR2 = dBm_2-Noise_dB;
S_Hat = W2 * cos(2*pi*2*fc*t); % Real Harmonics
No_Hat = W2 ./ (10.^(SNR2/10));
N_Hat = sqrt(1/2 * No_Hat) * randn(size(t));
% Received Signal
R_Hat = S_Hat + N_Hat;


%% Phase #3
Sum_Sig = R + R_Hat;
Abs_Sig = Sum_Sig - R;

% Filter Coefficient
FIR_I = fir1(31,0.5);
d  = filter(FIR_I,1,Abs_Sig)+N_Hat;  % Desired signal
mu = 1/Fs;            % LMS step size. 
ha = adaptfilt.lms(16,mu); 

% LMS Filtered Signal
[y_Hat,err] = filter(ha,S,d);


%%
figure()

a = welch(S,length(S),0.5,1);
plot(10*log10(a/fc),'b:','Linewidth',1)
hold on;

aa = welch(N,length(N),0.5,1);
plot(10*log10(aa/fc),'r:','Linewidth',2)

aaa = welch(R,length(R),0.5,1);
plot(10*log10(aaa/fc),'b-','Linewidth',1)


legend('Tx Harmonics','AWGN','Tx Harmonics w/ AWGN')

axis([0 400 -60 40])
grid on;
xlabel('Frequency [Hz]');
ylabel('Power / Frequency [dB/Hz]');

%%
figure()

b = welch(S_Hat,length(S_Hat),0.5,1);
plot(10*log10(b/fc),'b:','Linewidth',2)
hold on;

bb = welch(N_Hat,length(N_Hat),0.5,1);
plot(10*log10(bb/fc),'r:','Linewidth',2)

bbb = welch(R_Hat,length(R_Hat),0.5,1);
plot(10*log10(bbb/fc),'b-','Linewidth',1)


legend('Real Harmonics','AWGN','Real Harmonics w/ AWGN')

axis([0 400 -60 40])
grid on;
xlabel('Frequency [Hz]');
ylabel('Power / Frequency [dB/Hz]');

%% 
figure()

a = welch(S,length(S),0.5,1);
plot(10*log10(a/fc),'b:','Linewidth',1)
hold on;

b = welch(S_Hat,length(S_Hat),0.5,1);
plot(10*log10(b/fc),'r:','Linewidth',2)
hold on;


c = welch(Sum_Sig,length(Sum_Sig),0.5,1);
plot(10*log10(c/fc),'g-','Linewidth',1)
hold on;

d = welch(Abs_Sig,length(Abs_Sig),0.5,1);
plot(10*log10(d/fc),'m:','Linewidth',1)

f = welch(y_Hat,length(y_Hat),0.5,1);
plot(10*log10(f/fc),'m-','Linewidth',1)

legend('Tx Harmonics w/o AWGN','Real Harmonics w/o AWGN','Sum Harmonics w/ AWGN','Abstract Harmonics w/ AWGN')
legend('Tx Harmonics w/o AWGN','Real Harmonics w/o AWGN','Sum Harmonics w/ AWGN','Abstract Harmonics w/ AWGN','LMS Filter')

axis([0 400 -60 40])
grid on;
xlabel('Frequency [Hz]');
ylabel('Power / Frequency [dB/Hz]');


% disp(['Tx 2nd Harmonics = ', num2str(W), ' Watt (', num2str(dBm), ' dBm)'])
disp(['Noise Power = ', num2str(Noise_dB), ' dB'])