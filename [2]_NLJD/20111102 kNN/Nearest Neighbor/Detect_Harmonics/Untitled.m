% www.pudn.com > UWB-matlab-file.rar > UWB_BPSK_Analysis.m, change:2007-08-19,size:18067b




%   Title: UWB BPSK Analysis
%   Author: J C
%   Summary: Models an UWB TX and RX using BPSK.
%   MATLAB Release: R13
%   Description: This m file models an UWB system using BPSK.
%   The receiver is a correlation receiver with a LPF integrator
%   and comparators for threshhold selection.

%UWB-Run from editor debug(F5)-BPSK modulation and link analysis of
%UWB monocycle and doublet waveforms.Revised 1/2/05-JC
%This m file plots the time and frequency waveforms for BPSK 1st and 2nd derivative
%equations used in UWB system analysis. Adjustment factors are required to
%correct for inaccuracies in the 1st and 2nd derivative equations.
%Tail to tail on the time wave forms should be considered as the actual pulse width.
%7*PW1 has about 99.9% of the signal power. The frequency spreads and center
%frequencies(fc=center of the spread)are correct as you can verify(fc~1/pw1).
%Change pw(adjustment factor)and t for other entered(pw1) pulse widths and
%zooming in on the waveforms.A basic correlation receiver is constructed
%with an integrator(low pass filter-uses impulse response)showing the demodulated output
%information from a comparator(10101). Perfect sync is assumed in the correlation receiver.
%Noise is added with a variance of 1 and a mean of 0.
%See SETUP and other info at end of program.
%The program is not considered to be the ultimate in UWB analysis, but is
%configured to show basic concepts of the new technology. I would suggest that
%you review the previous files I published in the Mathworks file exchange concerning
%UWB to enhance your understanding of this technology. PPM(pulse position
%modulation) was analyzed in earlier files. PPM is an orthogonal waveform
%and not as efficient as BPSK which is an antipodal waveform with helpful
%properties in UWB usage. My assumption in this analysis is that the transmitting antenna
%produces a 2nd derivative doublet and that the receiving antenna passes
%the doublet thru to the mixer without integrating or differentating the signal, leaving
%a doublet. I believe the doublet also has helpful properties in UWB
%systems. I have included a reference at the end which is a must read.
%================================================
pw1=.2e-9;%pulse width in nanosec,change to desired width
pw=pw1/1.24;%Adjustment factor for inaccurate PWs(approx. 3-5 for 1st der. and
%approx. 1-3 for 2nd der.)
Fs=100e9;%sample frequency
Fn=Fs/2;%Nyquist frequency
t=-1e-9:1/Fs:30e-9;%time vector sampled at Fs Hertz. zoom in/out using (-1e-9:1/Fs:xxxx)
%================================================
% EQUATIONS
%================================================
%y=A*(t/pw).*exp(-(t/pw).^2);%1st derivative of Gaussian pulse=Gaussian monocycle
y =1*(1 - 4*pi.*((t)/pw).^2).* exp(-2*pi.*((t)/pw).^2);%2nd derivative of Gaussian
%pulse=doublet(two zero crossings)
%================================================
%NOISE SETUP FOR BER AND SNR
%================================================

noise=(1e-50)*(randn(size(t)));%Noise-AWGN(0.2 gives approx Eb/No=Es/No=SNR= 7DB)
%for 2 volt peak to peak BPSK signal.Set to 1e-50 to disable

%================================================
%BPSK OR BI-PHASE MODULATION
%================================================
%The following series of equations sets the pulse recurring frequency(PRF)
%at 156MHz(waveform repeats every 6.41e-9 sec and a
%modulated bit stream(bit rate=156Mb/s)of 10101 (5 pulses,can add more)
%where a {1=0 degrees(right side up) and a 1 bit} and a {-1=180
%degrees(upside down) a 0 bit.}
%One could expand the # of pulses and modulate for a series of
%111111000000111111000000111111 which would give a lower bit rate. You could just
%change the PRF also.This series of redundent pulses also improves the processing gain
%of the receiver(under certain conditions)by giving more voltage out of the integrator
%in a correlation receiver. The appropriate sequence when using BPSK can also produce
%nulls in the spectrum which would be useful for interference rejection or to keep
%the UWB spectrum from interfering with other communication systems.
%For loops or some other method could be used to generate these pulses but for
%myself, I would get lost. This is a brute force method and I can easily copy and paste.
%I will leave other methods for more energetic souls. Since we have the transmitter
%implemented it's time to move on to the correlation receiver design and
%see if we can demodulate and get 10101 bits out at the 156Mb/s bit rate.

%==================================================
% 1ST DERIVATIVE MONOCYCLE(PPM WITH 5 PULSES)
%==================================================
%yp=y+ ...
%A*((t-2.5e-9-.2e-9)/pw).*exp(-((t-2.5e-9-.2e-9)/pw).^2)+A*((t-5e-9)/pw).*exp(-((t-5e-9)/pw).^2)+ ...
%A*((t-7.5e-9-.2e-9)/pw).*exp(-((t-7.5e-9-.2e-9)/pw).^2)+A*((t-10e-9)/pw).*exp(-((t-10e-9)/pw).^2);
%==================================================
% 2ND DERIVATIVE DOUBLET(BPSK) WITH 5 PULSES)
%==================================================
%BPSK modulated doublet(yp)
yp=1*y+ ...
    -1*(1-4*pi.*((t-6.41e-9)/pw).^2).*exp(-2*pi.*((t-6.41e-9)/pw).^2)+ ...
    1*(1-4*pi.*((t-12.82e-9)/pw).^2).*exp(-2*pi.*((t-12.82e-9)/pw).^2)+ ...
    -1*(1-4*pi.*((t-19.23e-9)/pw).^2).*exp(-2*pi.*((t-19.23e-9)/pw).^2)+ ...
    1*(1-4*pi.*((t-25.64e-9)/pw).^2).*exp(-2*pi.*((t-25.64e-9)/pw).^2);

%unmodulated doublet(yum)
B=1;
yum=B*y+ ...
    B*(1-4*pi.*((t-6.41e-9)/pw).^2).*exp(-2*pi.*((t-6.41e-9)/pw).^2)+ ...
    B*(1-4*pi.*((t-12.82e-9)/pw).^2).*exp(-2*pi.*((t-12.82e-9)/pw).^2)+ ...
    B*(1-4*pi.*((t-19.23e-9)/pw).^2).*exp(-2*pi.*((t-19.23e-9)/pw).^2)+ ...
    B*(1-4*pi.*((t-25.64e-9)/pw).^2).*exp(-2*pi.*((t-25.64e-9)/pw).^2);

ym=yp+noise;%BPSK modulated doublet with noise

yc=ym.*yum;%yc(correlated output)=ym(modulated)times yum(unmodulated) doublet.
%This is where the correlation occurs in the receiver and would be the
%mixer in the receiver.
%==================================================
% FFT
%==================================================
%new FFT for BPSK modulated doublet(ym)
NFFYM=2.^(ceil(log(length(ym))/log(2)));
FFTYM=fft(ym,NFFYM);%pad with zeros
NumUniquePts=ceil((NFFYM+1)/2);
FFTYM=FFTYM(1:NumUniquePts);
MYM=abs(FFTYM);
MYM=MYM*2;
MYM(1)=MYM(1)/2;
MYM(length(MYM))=MYM(length(MYM))/2;
MYM=MYM/length(ym);
f=(0:NumUniquePts-1)*2*Fn/NFFYM;

%new FFT for unmodulated doublet(yum)
NFFYUM=2.^(ceil(log(length(yum))/log(2)));
FFTYUM=fft(yum,NFFYUM);%pad with zeros
NumUniquePts=ceil((NFFYUM+1)/2);
FFTYUM=FFTYUM(1:NumUniquePts);
MYUM=abs(FFTYUM);
MYUM=MYUM*2;
MYUM(1)=MYUM(1)/2;
MYUM(length(MYUM))=MYUM(length(MYUM))/2;
MYUM=MYUM/length(yum);
f=(0:NumUniquePts-1)*2*Fn/NFFYUM;

%new FFT for correlated pulses(yc)
%yc is the time domain signal output of the multiplier
%(modulated times unmodulated) in the correlation receiver. Plots
%in the time domain show that a simple comparator instead of high speed A/D's
%may be used to recover the 10101 signal depending on integrator design and level of
%peak voltage into mixer.
NFFYC=2.^(ceil(log(length(yc))/log(2)));
FFTYC=fft(yc,NFFYC);%pad with zeros
NumUniquePts=ceil((NFFYC+1)/2);
FFTYC=FFTYC(1:NumUniquePts);
MYC=abs(FFTYC);
MYC=MYC*2;
MYC(1)=MYC(1)/2;
MYC(length(MYC))=MYC(length(MYC))/2;
MYC=MYC/length(yc);
f=(0:NumUniquePts-1)*2*Fn/NFFYC;

%===================================================
% PLOTS
%===================================================
%plots for modulated doublet(ym)
figure(1)
subplot(2,2,1); plot(t,ym);xlabel('TIME');ylabel('AMPLITUDE');
title('Modulated pulse train');
grid on;
%axis([-1e-9,27e-9 -1 2])
subplot(2,2,2); plot(f,MYM);xlabel('FREQUENCY');ylabel('AMPLITUDE');
%axis([0 10e9 0 .1]);%zoom in/out
grid on;
subplot(2,2,3); plot(f,20*log10(MYM));xlabel('FREQUENCY');ylabel('20LOG10=DB');
%axis([0 20e9 -120 0]);
grid on;

%plots for unmodulated doublet(yum)
figure(2)
subplot(2,2,1); plot(t,yum);xlabel('TIME');ylabel('AMPLITUDE');
title('Unmodulated pulse train');
grid on;
axis([-1e-9,27e-9 -1 1])
subplot(2,2,2); plot(f,MYUM);xlabel('FREQUENCY');ylabel('AMPLITUDE');
axis([0 10e9 0 .1]);%zoom in/out
grid on;
subplot(2,2,3); plot(f,20*log10(MYUM));xlabel('FREQUENCY');ylabel('20LOG10=DB');
%axis([0 20e9 -120 0]);
grid on;

%plots for correlated pulses(yc)
figure(3)
subplot(2,2,1); plot(t,yc);xlabel('TIME');ylabel('AMPLITUDE');
title('Receiver correlator output-no LPF');
grid on;
%axis([-1e-9,27e-9 -1 1])
subplot(2,2,2); plot(f,MYC);xlabel('FREQUENCY');ylabel('AMPLITUDE');
%axis([0 7e9 0 .025]);%zoom in/out
grid on;
subplot(2,2,3); plot(f,20*log10(MYC));xlabel('FREQUENCY');ylabel('20LOG10=DB');
%axis([0 20e9 -120 0]);
grid on;
%===========================================================
%CORRELATION RECEIVER COMPARATOR(before lowpass filter)
%===========================================================
pt=.5%sets level where threshhold device comparator triggers
H=5;%(volts)
L=0;%(volts)
LEN=length(yc);
for ii=1:LEN;
    if yc(ii)>=pt;%correlated output(y2) going above pt threshold setting
        pv(ii)=H;%pulse voltage
    else;
        pv(ii)=L;
    end;
end ;
po=pv;%pulse out=pulse voltage

subplot(2,2,4);
plot(t,po);
axis([-1e-9 27e-9 -1 6])
title('Comparator output');
xlabel('Frequency');
ylabel('Voltage');
grid on;
%===================================================
%SETUP and INFO
%===================================================
%Check axis settings on plots
%Enter desired pulse width in pw1(.5e-9)or(.2e-9).
%Change t=-1e-9:1/Fs:(xxxx) to 1e-9 or proper value for viewing
%Press F5 or run.
%With waveform in plot 2,2,1(Figure 1), set pulse width with adjustment factor to
%.2e-9 using adjustment #s corresponding to chosen waveform. Set from tail to tail.
%Change t=-1e-9:1/Fs:(xxx) to something like 30e-9.Zoom out. I would
%comment in all plot axis and use them for zooming in and out.
%Press F5 and observe waveforms. Print or observe waveforms to compare with next set of
%wave forms.


%When you compare the waveforms you will see that the second derivative
%doublet has a center frequency in the spread twice that of the first
%derivative monocycle.
%You would expect this on a second derivative. Picking a doublet waveform
%for transmission (by choice of UWB antenna design) pushes the fc center frequency
%spread out by (two) allowing relief from the difficult design of narrower pulse
%generating circuits in transmitters and receivers. If you chose a monocycle, you would
%need to design your pulse circuits with a much narrower(factor of two)pulse width to
%meet the tough FCC spectral mask from ~3 to 10GHz at-41.3Dbm/1MHz. The antenna choice at
%the receiver could integrate the doublet to a monocycle so a waveform for the modulated
%monocycle is included. You would need to construct a modulated and unmodulated version
%of the monocycle.



%Processing gains of greater than 20DB can be achieved by selection of the
%PRF and integrator using high information bit rates. This, when doing a
%link budget, should give enough link margin for multipath conditions with
%a fixed transmitter power at ranges of 1 to 10 meters.A link budget will
%be shown to see if this is true.

%I didn't include BER checking with noise in the program because I beleive many more
%pulses would be required to get more accurate results. I have included a rough
%estimate of Eb/No in DB.

%Perfect sync is assumed in the correlation receiver. You could delay the
%unmodulated doublet waveform and check the correlation properties of the
%waveforms at the receiver and observe how the signal and BER degrades when not in
%perfect sync.

%Things to add
%A.more pulses
%B.integrator(completed)
%C.noise(completed)
%D.BER calculations-rough estimate(completed)
%E.Link budget calculations(preliminary)


%=======================================================================
%  CORRELATION RECEIVER LOW PASS FILTER(INTEGRATOR)
%=======================================================================
rc=.2e-9;%time constant
ht=(1/rc).*exp(-t/rc);%impulse response
ht=.2e-9*ht;%I'm not sure about this.Reduces integrated output voltage greatly.
ycfo=filter(yc,1,ht)/Fs;%use this instead of ycfo=conv(yc,ht)/Fs for proper dimension.
%The #=1 allows this. The LPF RC time constant(integrates over this time).
%Theory states that it should be set to the pulse width but should be set
%to a value that gives the best error free operation at the highest noise
%levels. Different filter types(butterworth,etc) may give different
%results.I don't have the butter function.
%The 3DB or 1/2 power bandwidth on the RC LPF is f=1/(2*pi*RC). The noise
%bandwith is f=1/(4*rc).
yn=filter(noise,1,ht)/Fs;%looks at filtered noise only(Figure 5)

%new FFT for filtered correlated pulses(ycfo)
NFFYCFO=2.^(ceil(log(length(ycfo))/log(2)));
FFTYCFO=fft(ycfo,NFFYCFO);%pad with zeros
NumUniquePts=ceil((NFFYCFO+1)/2);
FFTYCFO=FFTYCFO(1:NumUniquePts);
MYCFO=abs(FFTYCFO);
MYCFO=MYCFO*2;
MYCFO(1)=MYCFO(1)/2;
MYCFO(length(MYCFO))=MYCFO(length(MYCFO))/2;
MYCFO=MYCFO/length(ycfo);
f=(0:NumUniquePts-1)*2*Fn/NFFYCFO;

%new FFT for filtered noise(yn)
NFFYN=2.^(ceil(log(length(yn))/log(2)));
FFTYN=fft(yn,NFFYN);%pad with zeros
NumUniquePts=ceil((NFFYN+1)/2);
FFTYN=FFTYN(1:NumUniquePts);
MYN=abs(FFTYN);
MYN=MYN*2;
MYN(1)=MYN(1)/2;
MYN(length(MYN))=MYN(length(MYN))/2;
MYN=MYN/length(yn);
f=(0:NumUniquePts-1)*2*Fn/NFFYN;

%plots for filtered correlated pulses(ycfo)
figure(4)
subplot(2,2,1); plot(t,ycfo);xlabel('TIME');ylabel('AMPLITUDE');
title('Receiver filtered correlator output');
grid on;
%axis([-1e-9,27e-9 -1 1])
subplot(2,2,2); plot(f,MYCFO);xlabel('FREQUENCY');ylabel('AMPLITUDE');
%axis([0 7e9 0 .25]);%zoom in/out
grid on;
subplot(2,2,3); plot(f,20*log10(MYCFO));xlabel('FREQUENCY');ylabel('20LOG10=DB');
%axis([0 20e9 -120 0]);
grid on;

%=========================================================
%  CORRELATION RECEIVER COMPARATOR(after low pass filter)
%=========================================================
pt1=.1e-8%sets level where threshhold device comparator triggers
H=5;%(volts)
L=0;%(volts)
LEN=length(ycfo);
for ii=1:LEN;
    if ycfo(ii)>=pt1;%correlated output(ycfo) going above pt threshold setting
        pv1(ii)=H;%pulse voltage
    else;
        pv1(ii)=L;
    end;
end ;
po1=pv1;%pulse out=pulse voltage
subplot(2,2,4);
plot(t,po1);
axis([-1e-9 27e-9 -1 6])
title('Comparator output');
xlabel('Frequency');
ylabel('Voltage');
grid on;

%plots for filtered noise(yn)
figure(5)
subplot(2,2,1);plot(t,yn);xlabel('TIME');ylabel('AMPLITUDE');
title('Receiver filtered noise output');
grid on;
%axis([-1e-9,27e-9 -1 1])
subplot(2,2,2); plot(f,MYN);xlabel('FREQUENCY');ylabel('AMPLITUDE');
%axis([0 7e9 0 .25]);%zoom in/out
grid on;
subplot(2,2,3); plot(f,20*log10(MYN));xlabel('FREQUENCY');ylabel('20LOG10=DB');
%axis([0 20e9 -120 0]);
grid on;
subplot(2,2,4);plot(t,ht);xlabel('TIME');ylabel('AMPLITUDE');
title('impulse response(ht)');
grid on;
axis([0,1e-9 0 1])
%=========================================================
%BER CALCULATIONS
%=========================================================

%I'm going to calibrate the noise generator and roughly determine the Eb/No or SNR in DB
%that allows the system to operate almost error free(1e-3) in a noise environment.
%This value of Eb/No is the number in DB that can be used in link
%calculations. The calibration is required because in an actual TX-RX the received
%voltage into the correlation receiver at the mixer will be in the low millivolt
%region due to the FCC spectral mask at -41.3dBm/MHz and low transmitter power.
%It will not be the 2 volt peak-peak BPSK used here and must be recalibrated if
%different than 2 volt peak-peak.

%The Eb/No value in DB is calculated as follows. Doing numerous runs by hand and
%observing the LPF comparator output in figure 4, determine the proper
%setting of the comparator threshold setting, RC filter time constant and
%level of multiplier(0.1 to 1) in AWGN noise generator that gives almost error
%free operation. This will be considered Eb/No in DB.For BPSK theory this value is 7DB for BER of 1e-3.
%For a SNR of 7 DB, 20*LOG10(ratio of Vsig/Vnoise=1/.446)=7DB.
%You can do your own calibration method if you don't think
%this is correct. Remember to recalibrate for new pulse widths and amplitude changes
%into the mixer and pay attention to axis settings. There are a few to keep track of.

%Comment
%The one area I am wondering about is the noise removal after the mixer and
%before the LPF. The correlation(multication) removes some noise and then the LPF
%removes more noise as seen from the plots. Would a Xcorr give different results?

%I did some preliminary link caculations with this set up and determined that approx 0.6mv p-p
%would be present on the mixer input for the following conditions.(0.3mvpeak
%for 0 and 180 degrees)
%========================================================
%FCC spectral mask -41.3dBm/MHz+10LOG10(4000)=~-5dBm
%antenna gains 0DB(50 ohms)
%lna 20DB gain
%NF 10 DB
%distance 1 meter
%path loss~45DB
%156Mbit rate
%BW~800Mhz 3DB BW(LPF)(RC=.2e-9)
%N(receiver noise level)=KTB=-114dBm+NF=-104dBm
%3DB spread of pulse ~4GHz
%pw=.2e-9
%fc=~5Ghz
%C(carrierless carrier)/N=Eb/No*10LOG10(bit rate/BW)=7DB-2.74DB=4.26DB
%C=(C/N)+N=4.26DB-104DB=~-100dBm
%power received @ant=-5dBm-45DB(PL)=-50dBm over 4GHz.This value may be
%-41.3dBm/MHz-45DB=-86.3dBm which would give a much lower p-p voltage into
%mixer. Seems like this would be very low.
%link margin=-41.3dBm-45DB+100dBm=13.7DB.
%Emixerp-p=sqrt(1e-5*50)=2.23e-2mvrms*1.41=0.03mvpeak*20DB(lna)gain=0.3mvpeak or 0.6mvp-p


%Reference-Why Such Uproar Over Ultrawideband,John McCorkle
%URL:http:/www.commsdesign.com/showArticle.jhtml?articleID=16504218



