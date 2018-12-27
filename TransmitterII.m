clear all
%%%Receiver II
%%%Parameter Setting
Rs=100;
Ts=1/Rs;
Amplitude=100;
Fs=44000;
Es=Amplitude^2*Ts/2; % Bit Energy
Fc=1000;
Pilot=zeros(1,218);
%%%Barker Sequence
BSequence = [1 1 1 1 1 0 0 1 1 0 1 0 1];
%%%Singal Data
message=atob('Hello');
NewMess=[Pilot BSequence message BSequence Pilot]; %Add Pilot and Barker Sequence to signal
k=length(NewMess); % Must be 2^(8)-(8)-1
n=511; % Must be 2^(8)-1 
encdata = encode(NewMess,n,k,'hamming/binary');
data=encdata*2-1;
Signal=upsample(data,Fs/Rs);
figure(1)
plot(Signal);
title('Signal')
%%%BaseBand Modulation
r=.35;
rh_t = root_raised_cosine(r,Rs,Fs); 
Output1 = conv(rh_t,Es^.5.*Signal);
figure(2)
plot(Output1)
title('Signal after BaseBand Modulation')
%%%Passband Modulation
t=0:(length(Output1)-1);
t=t*1/Fs;
CarrierSignal=Rs^.5.*sin(1000*2*pi.*t);
figure(3)
Output2 = (1+Output1).*CarrierSignal;
plot(t,Output2)
title('Signal after Passband Modulation')
%%%Signal Generation
p=audioplayer(Output2,Fs);
play(p);
figure(4)
stem(NewMess)
title('Transmission Data')

% for i=1:4
%    close(figure(i));
% end
