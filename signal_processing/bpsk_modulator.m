close;
clear;
clc;

num_syms = 1000;
snr = 10;
bits = randi([0 1], num_syms, 1);
bpsk_syms = 2*bits - 1;

sig_pow = mean(abs(bpsk_syms).^2);
noise_pow = sig_pow / 10^(snr/10);
noise = sqrt(noise_pow/2)*randn(num_syms, 2)*[1; 1i];

y = bpsk_syms + noise;

figure();
plot(real(y), imag(y), '.');
grid on;
title('BPSK Constellation');
xlabel('In-Phase');
ylabel('Quadrature');