% matlab script sho.m
% finite difference scheme for simple harmonic oscillator

%%%%%% begin global parameters

SR = 44100;                         % sample rate (Hz)
f0 = 200;                           % fundamental frequency (Hz)
TF = 0.05;                             % duration of simulation (s)
u0 = 0.1;                           % initial displacement
v0 = 1;                             % initial velocity

%%%%%% end global parameters

% check that stability condition is satisfied

if(SR<=pi*f0)
    error('Stability condition violated');
end

% derived parameters

k = 1/SR;                           % time step
u1 = u0+k*v0;                       % derive value of time series at n=1;
coef = 2-k^2*(2*pi*f0)^2;           % scheme update coefficient
NF = floor(TF*SR);                  % duration of simulation (samples)

% initialize state of scheme

u=0;                                % current value of time series
u_last = u1;                        % last value of time series
u_last2 = u0;                       % one before last value of time series

% initialize readout

out = zeros(NF,1); out(1) = u0; out(2) = u1;

%%%%% start main loop

for n=3:NF
    u=coef*u_last-u_last2;          % difference scheme calculation
    out(n) = u;                     % read value to output vector
    u_last2 = u_last; u_last = u;   % update state of difference scheme
end

%%%%% end main loop

% plot output waveform

plot([0:NF-1]*k, out, 'k'); 
xlabel('t'); ylabel('u'); title('SHO: Difference Scheme Output');
axis tight

% play sound

soundsc(out,SR);
