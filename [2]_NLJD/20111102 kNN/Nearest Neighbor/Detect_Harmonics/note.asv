function tone = note(freq, dur, fs)
% Generates musical notes of:
% frequency: freq
% duration: dur
% sampled at: fs
% Time variable
t=0:1/fs:dur;
% Realistic note amplitude envelope
x=t/dur; envelope=x.*(1-x).*(exp(-8*x)+0.5*x.*(1-x));
% Realistic beating rato variable
beat=0.08;
% Generation of various tone harmonics
harmonic0=sin(2*pi*freq*t*(1-beat))+sin(2*pi*freq*t*(1+beat));
harmonic1=sin(2*pi*2*freq*t*(1-beat))+sin(2*pi*2*freq*t*(1+beat));
harmonic2=sin(2*pi*3*freq*t*(1-beat))+sin(2*pi*3*freq*t*(1+beat));
% Combination of envelope and harmonics
tone=envelope.*(harmonic0+0.2*harmonic1+0.05*harmonic2);
% Amplitude normalization
tone=tone/max(tone);
plot(t,tone);