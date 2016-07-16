close all;
clear all;
clc;
%% Defining the Constants
Spow = 1;
SNR = 0:2:30;
N = 1200;
frame = 1000;
%% BPSK Initiation
M = 2;
k_bit = log2(M);
map = [-1 1];
%% Normalization Factor
norm_factor = sqrt(1/(map*map'/M));
sym = map .* norm_factor;
input_sym = zeros(1,N/k_bit);
receive_sym = zeros(2,length(input_sym)/2);
err_bit = zeros(1,frame);
acc_bit = zeros(1,length(SNR));
for idx_dB = 1:length(SNR)
    % noise power
    noise_pow = Spow ./ (10.^(SNR(idx_dB)/10)) ./ k_bit;
    for idx_frame = 1:frame
        % Generating Random Bit stream
        input_bit = rand(1,N) > 0.5;
        output_bit = zeros(1,N);
        % QAM Constellation Mapping (Binary Gray Code)
        for idx = 1:N/k_bit
            input_sym(idx) = sym(bi2de(input_bit(idx*k_bit-(k_bit-1):idx*k_bit),2,'left-msb')+1);
        end;
        % Generate Codewords
        for idx_code = 1:length(input_sym)/2
            STBC_code1 = [input_sym(2*idx_code-1) input_sym(2*idx_code)];
            STBC_code2 = [-conj(input_sym(2*idx_code)) conj(input_sym(2*idx_code-1))];
            STBC_code = [STBC_code1; STBC_code2];
            h = norm_factor .* (randn(1,2) + i*randn(1,2));
            H = reshape(h,2,1);
            Hvec(1:2,idx_code:idx_code) = H;
            % add AWGN
            noise1 = sqrt(1/2 * noise_pow).*(randn + i*randn);
            noise2 = sqrt(1/2 * noise_pow).*(randn + i*randn);
            Noise = 2*[noise1; noise2];
            receive_sym(1:2,idx_code:idx_code) = STBC_code * H + Noise;
        end;
        %% Demodulation
        for idx_dem = 1:length(receive_sym)
            % decision
            r0 = receive_sym(1,idx_dem);
            r1 = receive_sym(2,idx_dem);
            h0si = Hvec(1,idx_dem).*sym;
            h1si = Hvec(2,idx_dem).*sym;
            h0sicon = Hvec(1,idx_dem).*conj(sym);
            h1sicon = Hvec(2,idx_dem).*conj(sym);
            [min_dist_val1 min_dist_idx1] = min(((r0-h0si) .* conj(r0-h0si)) + ((r1-h1sicon) .* conj(r1-h1sicon)));
            [min_dist_val2 min_dist_idx2] = min(((r0-h1si) .* conj(r0-h1si)) + ((r1+h0sicon) .* conj(r1+h0sicon)));
            output_bit(2*idx_dem-1) = de2bi(min_dist_idx1-1,k_bit,'left-msb');
            output_bit(2*idx_dem) = de2bi(min_dist_idx2-1,k_bit,'left-msb');
        end;
        err_bit(idx_frame) = sum(xor(input_bit,output_bit));
        acc_bit(idx_dB) = sum(err_bit) + err_bit(idx_frame);
    end;

    ber = acc_bit / (N * frame);
    ber_ref = berfading(SNR,'psk',2,1);

end;
%% Graph
semilogy(SNR,ber_ref,'b-','Linewidth',2);
hold on;
semilogy(SNR,ber,'bs-','Linewidth',2);
hold on;
%% Graph Property
legend('No diversity','STBC (2Tx,1Rx) Linear ML');
axis([0 50 10^-5 1]);
xlabel('Eb/N0 (dB)');
ylabel('Bit Error Rate (log)');
title('Bit Error Ratio Curve of STBC at BPSK');
grid on;