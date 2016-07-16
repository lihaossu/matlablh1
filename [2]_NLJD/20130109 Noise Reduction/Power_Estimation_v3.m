clear all; close all; clc;

%% Initialize the Frequency (Fundamental Frequency)
Fs = 10^3; t = 0:1/Fs:0.3; fc = 100;

%% Phase #1 (Problem and Solution of Tx Harmonics)

% Tx Harmonicss Power (Watt)
W = 1;
% Watt -> dBm
dBm = 10*log10(W) + 30; 
% Noise Power (dB)
Noise_dB = 30;
% Signal Power
SNR = dBm-Noise_dB; % dB scale (Noise = Negative)
No = W ./ (10.^(SNR/10));
% Tx Second Harmonics
S = W * cos(2*pi*2*fc*t);
N = sqrt(1/2 * No) * randn(size(t));
R = S + N;

% Filter Coefficient
FIR_I = fir1(31,0.5);
d  = filter(FIR_I,1,S)+N;  % Desired signal
mu = 1/Fs;            % LMS step size. 
ha = adaptfilt.lms(32,mu); 

% LMS Filtered Signal
[y_Hat,err] = filter(ha,S,d);
y_Hat = y_Hat - N;

%%%%%%%%%%%%%
% Figure #1 % TX Second Harmonics
%%%%%%%%%%%%%

g = welch(S,length(S),0.5,1);
plot(10*log10(g/fc),'b-','Linewidth',1)
hold on;

% Noise Signal
h = welch(N,length(N),0.5,1);
plot(10*log10(h/fc),'r:','Linewidth',1)
hold on;

i = welch(R,length(R),0.5,1);
plot(10*log10(i/fc),'g-','Linewidth',1)
hold on;

legend('Tx Harmonics','AWGN','Tx Harmonics w/ AWGN');

axis([0 400 -60 20])
grid on;
xlabel('Frequency [Hz]');
ylabel('Power / Frequency [dB/Hz]');


%%%%%%%%%%%%%
% Figure #2 %
%%%%%%%%%%%%%


figure(2)
plot(0:50,y_Hat(1:51),'b:')
hold on
plot(0:50,err(1:51),'r:')

axis([0 50 -1 1])

%%%%%%%%%%%%%
% Figure #3 % Tx Harmonics w/ LMS Filter
%%%%%%%%%%%%%
figure(3);

% Original Signal
a = welch(S,length(S),0.5,1);
plot(10*log10(a/fc),'b-','Linewidth',1)
hold on;

% Noise Signal
b = welch(R,length(R),0.5,1);
plot(10*log10(b/fc),'r:','Linewidth',1)
hold on;

c = welch(y_Hat,length(y_Hat),0.5,1);
plot(10*log10(c/fc),'g-','Linewidth',1)
hold on;

legend('Tx Harmonics','Harmonics w/ AWGN','LMS Filter');

axis([0 400 -60 20])
grid on;
xlabel('Frequency [Hz]');
ylabel('Power / Frequency [dB/Hz]');

%% Phase #2 (Problem and Solution of Tx Harmonics w/ Noise)

% Real Power (Watt)
W2 = .7;
dBm_2 = 10*log10(W2) + 30;
SNR2 = dBm_2-Noise_dB;
% Real Harmonics
S_Hat = W2 * cos(2*pi*2*fc*t);
No_Hat = W2 ./ (10.^(SNR2/10));
N_Hat = sqrt(1/2 * No_Hat) * randn(size(t));

S_Hat_1 = S_Hat + S + N;


d_1 = filter(FIR_I,1,S_Hat);  % Desired signal
[y_Hat_1,err1] = filter(ha,S_Hat,d_1);


%%%%%%%%%%%%%
% Figure #4 %
%%%%%%%%%%%%%

figure(4)

aaa = welch(y_Hat_1,length(y_Hat_1),0.5,1);
plot(10*log10(aaa/fc),'b:','Linewidth',1)
hold on;

% legend('Original','AWGN','Tx Harmonics','Real Harmonics','Detection');
legend('Real Harmonics');

axis([0 400 -60 20])
grid on;
xlabel('Frequency [Hz]');
ylabel('Power / Frequency [dB/Hz]');



d_2  = filter(FIR_I,1,S_Hat_1)+N;  % Desired signal
[y_Hat_2,err2] = filter(ha,S_Hat_1,d_1);

y_Hat_2 = y_Hat_1 - y_Hat ;

%%%%%%%%%%%%%
% Figure #5 %
%%%%%%%%%%%%%

figure(5)

d = welch(S,length(S),0.5,1);
plot(10*log10(d/fc),'b:','Linewidth',1)
hold on;

e = welch(y_Hat_1,length(y_Hat_1),0.5,1);
plot(10*log10(e/fc),'r:','Linewidth',1)
hold on;

% Filter @ Receiver w/ Tx Harmonics + Real Harmonics
f = welch(y_Hat_2,length(y_Hat_2),0.5,1);
plot(10*log10(f/fc),'g-','Linewidth',1)


% legend('Original','AWGN','Tx Harmonics','Real Harmonics','Detection');
legend('Tx Harmonics','Real Harmonics','LMS Filter');

axis([0 400 -60 20])
grid on;
xlabel('Frequency [Hz]');
ylabel('Power / Frequency [dB/Hz]');


% disp(['Tx 2nd Harmonics = ', num2str(W), ' Watt (', num2str(dBm), ' dBm)'])
disp(['Noise Power = ', num2str(Noise_dB), ' dB'])