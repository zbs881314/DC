%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EECE545 Digital Communication PhaseII
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameters
Amp = 100; % Amplitude
N = 100; %Transmission Data Rate
TS = 1/N; %Bit duration
Fs = 44000; %Sampling Frequency in Hz
E_s = Amp^2*TS/2; %bit energy
r = .35;
rh_t = root_raised_cosine(r,N,Fs); %root raised cosine filter
BarkerS = [1 1 1 1 1 0 0 1 1 0 1 0 1]; %Barker sequence, zeros will be changes to negative ones
pilot = zeros(1,200);
%% Date Packet
datai = [pilot BarkerS atob('Digital') BarkerS pilot]; %add pilot signals and Barker Sequence to message signal
dencoded = encode(datai);
data = dencoded*2-1;
dw0 = upsample(data,Fs/N); %Insert Zeros
figure(1)
plot(dw0);
title 'Encoded Data after Inserting Zeros'
%% Baseband Modulation
BMdata = conv(rh_t,E_s^.5.*dw0);
figure(2)
plot(BMdata)
title 'Baseband Modulated Signal'
%% Passband Modulation
t = (0:(length(BMdata)-1))*1/Fs;
carrier = (1/TS)^.5.*cos(1000*2*pi.*t);
figure(3)
PMdata = BMdata.*carrier;
plot(t,PMdata)
title 'Bandpass Modulated Signal'
xlabel 'Time in Seconds'
ylabel 'Amplitude'
%% Signal Transmittion
wavplay(PMdata,Fs,'async');
i= i + 1;
figure(4)
stem(datai)
title('Data Before Encoding')
grid on;


