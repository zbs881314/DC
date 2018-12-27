%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EECE545 Digital Communication PhaseII
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
clc;
%% Parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
A = 1; % Amplitude
N = 100; %Bit rate
Ts = 1/N; %Bit duration
Fs = 44000;
r=.35;
%% Data Receiving
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tx = wavrecord(10*Fs, Fs);
t = (0:(length(tx)-1))*1/Fs;
figure(1);
plot(t, tx);
grid on;
title('Received Signal')
xlabel('time')
ylabel('Amplitude')
%% Bandpass Demodulate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rrc = root_raised_cosine(r, N,Fs);
h_t = rrc;
%% Multiplication of carrier
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
carrier = cos(2*pi*1e3.*t);
carrier1 = sin(2*pi*1e3.*t);
tx = tx.';
rx = tx .* carrier;
rx1 = tx.* carrier1;
figure(2);
plot(t,rx);
grid on
title('Demodulated Signal')
xlabel('time')
ylabel('Amplitude')
r_data = filter(h_t,1,rx);
r_data1 = filter(h_t,1,rx1);
t1 = (0:(length(r_data)-1)).*1/Fs;
figure(3)
subplot(2,1,1)
plot(t1,r_data)
grid on
title('Received * carrier(cos)')
xlabel('time')
ylabel('Amplitude')
subplot(2,1,2)
plot(t1,r_data1)
grid on
title('Received * carrier(sin)')
xlabel('time')
ylabel('Amplitude')
%% Syncronization of phase difference
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
BarkerSq = [1 1 1 1 1 0 0 1 1 0 1 0 1];
base_pilot = conv(upsample(BarkerSq, Fs/N),h_t);
figure(4)
plot(base_pilot)
grid on;
title('Base Pilot')
xlabel('Samples')
ylabel('Amplitude')
co_result = xcorr((r_data(1:50*440)),base_pilot);
co_result1 = xcorr((r_data1(1:50*440)),base_pilot);
%% Syncronization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[value, peak_index] = max(abs(co_result));
phase = atan(co_result1(peak_index)/co_result(peak_index));
scal = sign(co_result(peak_index));
adjust_carrier = cos(2*pi*1e3.*t - phase);
rx = tx .* adjust_carrier;
r_data = filter(h_t,1,rx);
figure(5)
plot(r_data)
grid on;
title('Demodulated Signal')
xlabel('Samples')
%xlim([0 70000]);
ylabel('Amplitude')

%% Sampling
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K=150;
mag = zeros(1,Fs/N);
figure(6);
stem(r_data(1:Fs/N:K*Fs/N));
grid on;
title('Sampled Demodulated Signal')
xlabel('Samples')
ylabel('Amplitude')
for i = 1:Fs/N
    mag(i) = sum(abs(r_data(i+30*440:Fs/N:K*Fs/N)));
    mag(i) = mag(i)/K;
end
Pos = find(mag==max(mag));
%% Detecting
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
samples = r_data(Pos+30*440:Fs/N:length(r_data));
rx = zeros(1,length(samples));
threshold = 0.5;
k = 0;
if scal > 0
    for i = 1:length(samples)
        k = k+1;
        if samples(i)> threshold
            rx(k) = 1;
        elseif samples(i)<-1*threshold
            rx(k) = 0;
        end
        
    end
elseif scal < 0
    for i = 1:length(samples)
        k = k+1;
        if samples(i)> threshold
            rx(k) = 0;
        elseif samples(i)<-1*threshold
            rx(k) = 1;
        end
    end
end
rx = 1-rx;
figure(7)
stem(rx)
grid on;
title('Detected Signal')
xlabel('Samples')
ylabel('Amplitude')
%% Decoding
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
trellis = poly2trellis(3,[5 7]);
decoded = vitdec(rx,trellis,12,'term','hard');
figure(8);
grid on;
stem(decoded);
title('Decoded Singnal with Pilots and Barker Seq')
%% Pilot Removing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1:length(decoded)-12
        if(decoded(i:i+12) == BarkerSq)
           Message_start = i+13; 
           break;
        end
    end
    for i = Message_start:length(decoded)-12
        if(decoded(i:i+12) == BarkerSq)
           Message_end = i-1;
           break;
        end
    end
decoded_final = decoded(Message_start:Message_end);
figure(9);
stem(decoded_final);
grid on;
title('Final Decoded Signal');
figure(10);
stem(atob('Digital'));
title('Original Digits');
grid on;
%% Error Bit Rate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
EP = decoded_final - atob('Digital');
EN = 0;
for i =1:length(EP)
    if EP(i) == 0;
        EN = EN+1;
    end
end
BER = (length(EP)-EN)/length(EP);
%% SNR per Bit
Noise = wavrecord(200,Fs);
VarN = var(Noise);
Eb = mean(abs(tx).^2)*Ts/2;
SNR = Eb/VarN;
BER
SNR
btoa(decoded_final)
