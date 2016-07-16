% Wide-band noise cancellation

mu = 0.01;  % adaptation parameter
M = 11;     % filter length
delay = -10;    % delay may be + or - 
N = 400;
s = sin(2*pi*500*(0:N-1)/10000);    % signal
noise = 0.2*randn(1,N);             % noise
y = s + noise;
h = zeros(M,1);     % initial filter coefficients

for n = M+1+delay:N-M,  % adaptive algorithm
   x = y(n-delay-M+1:n-delay)';
   q(n) = h'*x;
   e(n) = y(n) - q(n);
   h = h + mu * e(n) * x;
end

hold off
plot(e)
hold on
plot(q,'r')
