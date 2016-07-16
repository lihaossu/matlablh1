Fs = 32e3;   t = 0:1/Fs:2.96;
             x  = cos(2*pi*t*10e3)+cos(2*pi*t*1.24e3)+ randn(size(t));
             X  = fft(x);
             P  = (abs(X).^2)/length(x)/Fs;  % Calculate power and scale to form PSD.
   
             hpsd = dspdata.psd(P,'Fs',Fs,'SpectrumType','twosided');
             plot(hpsd);                     % Plot the PSD.