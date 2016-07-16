clear all; close all; clc;
%% Create signal.
F1 = 2E3; F2 = 3E3;
Fs = 10E3;
t = 0:1/Fs:.296;

frame = 20;
progressbar;
for idx_frame = 1:frame
    Simulation_No = 10;
    % Decision = zeros(1,Simulation_No);
    % Estimation = zeros(1,Simulation_No);
    % Err = zeros(1,Simulation_No);
    
    for idx_simulation = 1:Simulation_No
        
        A1 = ceil(10*rand);
        A2 = ceil(10*rand);
        
        while A2 == A1
            A2 = ceil(10*rand);
        end;
        
        if A1 > A2
            Decision(idx_simulation) = 0; % NLJD
        elseif A1 < A2
            Decision(idx_simulation) = 1; % Metal
        end;
        
        
        %% Generate Noise and Interference
        % % Generate Noise
        % Noise1 = sqrt(2).*(randn(1,length(t))).*a;
        % Noise2 = sqrt(2).*(randn(1,length(t))).*a;
        
        % Generate Interference
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
        
        Second_Harmonics(idx_simulation) = sum(psd(410:412,1)) / 10E3;
        Third_Harmonics(idx_simulation) = sum(psd(614:616,1)) / 10E3;
        
        if Second_Harmonics(idx_simulation) > Third_Harmonics(idx_simulation)
            Estimation(idx_simulation) = 0; % NLJD
        elseif Second_Harmonics(idx_simulation) < Third_Harmonics(idx_simulation)
            Estimation(idx_simulation) = 1; % Metal
        end;
        
        Err(idx_simulation) = xor(Decision(idx_simulation),Estimation(idx_simulation));
        
    end;
    
    BER = sum(Err) / Simulation_No;
    
    for idx_Class = 1:Simulation_No
        if Second_Harmonics(idx_Class) > Third_Harmonics(idx_Class)
            NLJD(idx_Class,:) = [Second_Harmonics(idx_Class) Third_Harmonics(idx_Class)];
        elseif Second_Harmonics(idx_Class) < Third_Harmonics(idx_Class)
            Metal(idx_Class,:) = [Second_Harmonics(idx_Class) Third_Harmonics(idx_Class)];
        end;
        hold on;
    end;
    
    % kNN Factor
    k = 7;
    
    knn_simulation_no = 1000;
    
    for idx_knn = 1:knn_simulation_no
        
        A1 = ceil(10*rand);
        A2 = ceil(10*rand);
        
        while A2 == A1
            A2 = ceil(10*rand);
        end;
        
        if A1 > A2
            Decision = 0; % NLJD
        elseif A1 < A2
            Decision = 1; % Metal
        end;
        
        
        %% Generate Noise and Interference
        % % Generate Noise
        % Noise1 = sqrt(2).*(randn(1,length(t))).*a;
        % Noise2 = sqrt(2).*(randn(1,length(t))).*a;
        
        % Generate Interference
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
        
        Second_Harmonics = sum(psd(410:412,1)) / 10E3;
        Third_Harmonics = sum(psd(614:616,1)) / 10E3;
        
        if Second_Harmonics > Third_Harmonics
            Estimation = 0; % NLJD
        elseif Second_Harmonics < Third_Harmonics
            Estimation = 1; % Metal
        end;
        
        Measured = [Second_Harmonics Third_Harmonics];
        class = kNN(k,Measured,NLJD,Metal);
        
        Err_knn(idx_knn) = xor(class,Estimation);
        
        progress_count = idx_knn/knn_simulation_no;
        % Do something important
        pause(0.01)
        % Update figure
        progressbar(((idx_frame-1)+progress_count)/frame);
    end;
    
    percent_knn(idx_frame) = (sum(Err_knn) / knn_simulation_no) * 100;
    
end;

Training_10_k_7 = sum(percent_knn) / frame

% save Training_50_k_7.mat Training_50_k_7
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
