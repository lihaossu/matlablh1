clear all; close all; clc;
%% Create signal.
F1 = 2E3; F2 = 3E3;
Fs = 10E3;
t = 0:1/Fs:.296;

knn_simulation_no = 100;
frame = 50;

load training_database_1000.mat

progressbar;
% kNN Factor
k = [3 5 7 9 11 13 15];

for idx_k = 1:length(k)
    
    for idx_frame = 1:frame
        
        for idx_simulation = 1:knn_simulation_no
            
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
            Inter1 = 10*rand;
            
            % F2 Hz Interferences
            Inter2 = 10*rand;
            
            %% A cosine of F1 Hz and F2 Hz
            a = A1*cos(2*pi*t*F1) + A2*cos(2*pi*t*F2);
            x = a + Inter1.*cos(2*pi*t*F1) + Inter2.*cos(2*pi*t*F2);
            
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
            class = kNN(k(idx_k),Measured,NLJD,Metal);
            
            Err_knn_1(idx_simulation) = xor(class,Decision);
            Err_knn_2(idx_simulation) = xor(Estimation,Decision);
            
            progress_count = idx_simulation/knn_simulation_no;
            % Do something important
            pause(0.01)
            % Update figure
            progressbar(((idx_k-1)*frame+((idx_frame-1)+progress_count))/(length(k)*frame));
            
        end;
        
        err_1(idx_frame) = sum(Err_knn_1);
        err_2(idx_frame) = sum(Err_knn_2);
        
        
    end;
    
    Training_1000_original_1(idx_k) = (sum(err_1) / (knn_simulation_no * frame)) * 100;
    Training_1000_original_2(idx_k) = (sum(err_2) / (knn_simulation_no * frame)) * 100;
end;

% save Training_1000_original.mat Training_1000_original;

