Y = fft(i_w,1024)
 
an = real(Y)
 bn = imag (Y)
 [r,k]=size(an)
 

 n=50
 
 ann = an(1:n,k)
  bnn = bn(1:n,k)
  ampl = 2/1024*sqrt(ann.^2+bnn.^2)
  phi=atan(ann./(bnn+.000001));
  harm = 1:1:n
  bar(harm,ampl)
  xlabel('harmonics')
  ylabel('amplitude')
 