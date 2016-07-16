%
% FUNCTION 3.4 : "cp0303_PPM_random"
%
% Generation of a PPM-UWB signal in the case of
% a random modulating signal and rectangular pulses
% The modulating signal is characterized by
% a normal distribution
%
% Transmitted Power is fixed at 'Pow'
% The signal is sampled with frequency 'fc'
% 'np' is the number of generated pulses
% 'Ts' is the average pulse repetition period
% Each rectangular pulse has time duration 'Tr'
% The random modulating signal is characterized
% by standard deviation 'sigma'
%
% The function returns the generated signal 'Stx',
% the corresponding sampling frequency 'fc',
% and vector 'M0' of all the PPM time shifts
%
% Programmed by Guerino Giancola
%
function [Stx,fc,M0]=cp0303_PPM_random;
% ----------------------------
% Step Zero - Input parameters
% ----------------------------
Pow = -30; % average transmitted power (dBm)
fc = 1e11; % sampling frequency
np = 10000; % number of pulses
Tr = 0.5e-9; % time duration of the rectangular pulse [s]
Ts = 2e-9; % average pulse repetition period [s]
sigma = 0.1e-9; % standard deviation of the modulating
signal
% ----------------------------------------
% Step One - Simulating transmission chain
% ----------------------------------------
dt = 1 / fc; % sampling period
sTs = floor(Ts/dt); % number of samples per frame
sTot = sTs * np; % total number of samples
Stx = zeros(1,sTot); % output vector
% PPM
j = (0:1:np-1);
M0 = max(zeros(1,np), min((Ts -Tr).*...
ones(1,np),((Ts/2)+sigma.*randn(1,np))));
M1 = j.*Ts;
Mtot = M0 + M1;
for k = 1 : np
Stx(1+floor(Mtot(k)/dt))=1;
end
% shaping filter
sP = floor(Tr/dt); % number of samples per
% pulse
p0 = (1/sqrt(Tr)).*ones(1,sP); % energy normalized rect
power = (10^(Pow/10))/1000; % average transmitted power
% (Watt)
Ex = power * Ts; % energy per pulse
ptx= p0 .* sqrt(Ex); % pulse waveform
Stx = conv(Stx,ptx);
Stx = Stx(1:sTot);