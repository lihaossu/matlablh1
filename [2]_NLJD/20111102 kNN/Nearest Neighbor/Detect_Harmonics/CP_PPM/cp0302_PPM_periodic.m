%
% FUNCTION 3.3 : "cp0302_PPM_periodic"
%
% Generation of a PPM-UWB signal in the case of a generic
% periodic modulating signal and rectangular pulses
% Modulating signal is chosen to be characterized by
% an exponential decay exp(-t)
%
% Transmitted power is fixed at 'Pow'
% The signal is sampled with frequency 'fc'
% 'np' is the number of generated pulses
% 'Ts' is the average pulse repetition period
% Each rectangular pulse has time duration 'Tr'
% The periodic signal is characterized by
% shape parameters 'A' and 'B', and period 'Tp'
%
% The function returns the generated signal 'Stx'
% and the corresponding sampling frequency 'fc'
%
% Programmed by Guerino Giancola
%
function [Stx,fc]=cp0302_PPM_periodic;
% ----------------------------
% Step Zero - Input parameters
% ----------------------------
Pow = -30; % average transmitted power (dBm)
fc = 1e11; % sampling frequency
np = 10000; % number of pulses
Tr = 0.5e-9; % time duration of the rectangular pulse [s]
Ts = 2e-9; % average pulse repetition period [s]
A = 1e-9; % first shape parameter
B = 10; % second shape parameter
Tp = 20e-9; % period of the modulating signal [s]
% ----------------------------------------
% Step One - Simulating transmission chain
% ----------------------------------------
dt = 1 / fc; % sampling period
sTs = floor(Ts/dt); % number of samples per frame
sTot = sTs * np; % total number of samples
Stx = zeros(1,sTot);% output vector
% PPM
j = (0:1:np-1);
M0 = A.*exp(-(B/Tp).*mod(j*Ts,Tp));
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
