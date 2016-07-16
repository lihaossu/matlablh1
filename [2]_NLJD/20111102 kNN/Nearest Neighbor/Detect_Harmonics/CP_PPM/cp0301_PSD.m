%
% FUNCTION 3.2 : "cp0301_PSD"
%
% Evaluates the PSD of the
% signal represented by the input vector 'x'
% The input signal is sampled with frequency 'fc'
%
% This function returns the PSD ('PSD')
% and the corresponding frequency resolution ('df')
%
% Programmed by Guerino Giancola
%
function [PSD,df]=cp0301_PSD(x,fc)
% --------------------------------
% Step One - Evaluation of the PSD
% --------------------------------
dt=1/fc;
N=length(x);
T=N*dt;
df=1/T;
X = fft(x);
X = X / N;
mPSD=abs(X).^2/(df^2);
PSD = fftshift(mPSD);
PSD = (1/T).*PSD;
% -----------------------------------
% Step Two - Graphical representation
% -----------------------------------
frequency = linspace(-fc/2,fc/2,length(PSD));
PF=plot(frequency,PSD);
set(PF,'LineWidth',[2]);
AX=gca;
set(AX,'FontSize',12);
X=xlabel('Frequency [Hz]');
set(X,'FontSize',14);
Y=ylabel('Power Spectral Density [V^2/Hz]');
set(Y,'FontSize',14);
