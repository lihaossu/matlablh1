clear all; close all; clc;
%% Create signal.
F1 = 2E3; F2 = 3E3;
Fs = 10E3;
t = 0:1/Fs:.296;

training = 80;

knn_simulation_no = 100;
frame = 100;

%% Dummy
Decision = zeros(1,training);
Second_Harmonics = zeros(1,training);
Third_Harmonics = zeros(1,training);
Estimation_real = zeros(1,training);
NLJD = zeros(training,2);
Metal = zeros(training,2);

for idx_training = 1:training
    
    A1 = ceil(10*rand);
    A2 = ceil(10*rand);
    
    while A2 == A1
        A2 = ceil(10*rand);
    end;
    
    if A1 > A2
        Decision(idx_training) = 0; % NLJD
    elseif A1 < A2
        Decision(idx_training) = 1; % Metal
    end;
    
    %% Generate Noise and Interference
    
    % Generate Noise
    InterNoise1 = sqrt(1/2).*randn(1,length(t));
    InterNoise2 = sqrt(1/2).*randn(1,length(t));
    
    % F1 Hz Interferences
    Inter1 = 10*rand.*cos(2*pi*t*F1);
    
    % F2 Hz Interferences
    Inter2 = 10*rand.*cos(2*pi*t*F2);
    
    %% A cosine of F1 Hz and F2 Hz
    a = A1*cos(2*pi*t*F1) + A2*cos(2*pi*t*F2);
    x = a + Inter1 + Inter2;
    
    %% Spectrum Analysis #1
    p = spower(x);
    psd = spectrum(x,2048);
    
    %     specplot(psd,Fs);
    
    Second_Harmonics(idx_training) = sum(psd(410:412,1)) / 10E3;
    Third_Harmonics(idx_training) = sum(psd(614:616,1)) / 10E3;
    
    if Second_Harmonics(idx_training) > Third_Harmonics(idx_training)
        Estimation_real(idx_training) = 0; % NLJD
    elseif Second_Harmonics(idx_training) < Third_Harmonics(idx_training)
        Estimation_real(idx_training) = 1; % Metal
    end;
    
end;

for idx_Class = 1:training
    if Second_Harmonics(idx_Class) > Third_Harmonics(idx_Class)
        NLJD(idx_Class,:) = [Second_Harmonics(idx_Class) Third_Harmonics(idx_Class)];
    elseif Second_Harmonics(idx_Class) < Third_Harmonics(idx_Class)
        Metal(idx_Class,:) = [Second_Harmonics(idx_Class) Third_Harmonics(idx_Class)];
    end;
end;

progressbar;

% kNN Factor
k = 5;

for idx_frame = 1:frame
    
    for idx_simulation = 1:knn_simulation_no
        
        
        Measured = 10*rand(1,2);
        class = kNN(k,Measured,NLJD,Metal);
        
        if Measured(1) > Measured(2)
            Estimation_2 = 0; % NLJD
        elseif Measured(1) < Measured(2)
            Estimation_2 = 1; % Metal
        end;
        
        Err_knn(idx_simulation) = xor(class,Estimation_2);
        
        progress_count = idx_simulation/knn_simulation_no;
        % Do something important
        pause(0.01)
        % Update figure
        progressbar(((idx_frame-1)+progress_count)/frame);
        
    end;
    
    
    err(idx_frame) = sum(Err_knn);
    
end;

Training_80_k_5 = (sum(err) / (knn_simulation_no * frame)) * 100

save Training_80_k_5.mat Training_80_k_5;

%     grid on;
%     axis([1500 3500 10^-10 10^5]);
%     hold on;


%% Spectrum Analysis #2
%     Pxx0 = spectrum.welch;
%     psd(Pxx0,a,'Fs',Fs);

% Received Signal
% Interference

%% Spectrum Analysis #3
%     Hs = spectrum.welch;
%     psd(Hs,x,'Fs',Fs)
%     hold on
% axis([1 4 -35 -10]);
