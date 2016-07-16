%
% FUNCTION 3.1 : "cp0301_PPM_sin"
%
% Generation of a PPM-UWB signal in the case of a
% sinusoidal modulating signal and rectangular pulses
%
% Transmitted power is fixed at 'Pow'
% The signal is sampled with frequency 'fc'
% 'np' is the number of generated pulses
% 'Ts' is the average pulse repetition period
% Each rectangular pulse has time duration 'Tr'
% The modulating signal is a sinusoid with
% amplitude 'A' and frequency 'f0'
%
% The function returns the generated signal 'Stx'
% and the corresponding sampling frequency 'fc'
%
% Programmed by Guerino Giancola
%
function [Stx,fc]=cp0301_PPM_sin;
% ----------------------------
% Step Zero - Input parameters
% ----------------------------
Pow = -30; % average transmitted power (dBm)
fc = 1e11; % sampling frequency
np = 10000; % number of pulses
Tr = 0.5e-9;% time duration of the rectangular pulse [s]
Ts = 2e-9; % average pulse repetition period [s]
A = Ts/2; % maximum time shift provided by the
% modulation [s]
f0 = 5e7; % frequency of the modulating signal [Hz]
% ----------------------------------------
% Step One - Simulating transmission chain
% ----------------------------------------
dt = 1 / fc; % sampling period
sTs = floor(Ts/dt); % number of samples per frame
sTot = sTs * np; % total number of samples
Stx = zeros(1,sTot); % output vector
% pulse position modulation
j = (0:1:np-1);
M0 = A.*cos((2*pi*f0).*(j.*Ts));
M1 = j.*Ts;
Mtot = M0 + M1;
for k = 1 : np
    Stx(1+floor(Mtot(k)/dt))=1;
end
% shaping filter
sP = floor(Tr/dt); % number of samples per pulse
p0 = (1/sqrt(Tr)).*ones(1,sP); % energy normalized rect
power = (10^(Pow/10))/1000; % average transmitted power
% (watt)
Ex = power * Ts; % energy per pulse
ptx= p0 .* sqrt(Ex); % pulse waveform
Stx = conv(Stx,ptx);
Stx = Stx(1:sTot);