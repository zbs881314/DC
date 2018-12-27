clear all;
%%%Receiver II
%%%Parameter Setting
Rs=100;
Ts=1/Rs;
Amplitude=1;
Fs=44000;
Es=Amplitude^2*Ts/2; % Bit Energy
Fc=1000;
%%%BandPass Filter
r=.35;
h_t= root_raised_cosine(r,Rs,Fs);
%%%Received Data
Receivers=audiorecorder(Fs,8,1);
recordblocking(Receivers,5.5);       %Choose t=3.9911 to be close to the tranmitter sample
ReceivedSignal=getaudiodata(Receivers)';
t1=0:(length(ReceivedSignal)-1);
t1=t1*1/Fs;
figure(5)
plot(t1,ReceivedSignal);
title("Received Signal")
%%%Demodulation Process
CarrierS1=cos(2*pi*Fc.*t1);
CarrierS2=sin(2*pi*Fc.*t1);
BPDemoSignal1=ReceivedSignal.*CarrierS1;
BPDemoSignal2=ReceivedSignal.*CarrierS2;
figure(6)
subplot(2,1,1)
plot(t1,BPDemoSignal1);
title("Signal after BandPass Demodulation (cos)")
figure(6)
subplot(2,1,2)
plot(t1,BPDemoSignal2);
title("Signal after BandPass Demodulation (sin)")
BBDemoSignal1=filter(h_t,1,BPDemoSignal1);
BBDemoSignal2=filter(h_t,1,BPDemoSignal2);
t2=(0:(length(BBDemoSignal1)-1)).*1/Fs;
figure(7)
subplot(2,1,1)
plot(t2,BBDemoSignal1);
title("Signal after BaseBand Demodulation(cos)")
figure(7)
subplot(2,1,2)
plot(t2,BBDemoSignal2);
title("Signal after BaseBand Demodulation(sin)")
%%%Cross-Corelation and Phase Syncronization
BS=[1 1 1 1 1 0 0 1 1 0 1 0 1];
BasePilot=conv(upsample(BS, Fs/Rs),h_t);
figure(8)
plot(BasePilot);
title("Base Pilot")
CCorelation1=xcorr(BBDemoSignal1(1:50*440),BasePilot);  
CCorelation2=xcorr(BBDemoSignal2(1:50*440),BasePilot);
%%% Signal after Adjustment
[value,peakIndex]=max(abs(CCorelation1));
phase=atan(CCorelation2(peakIndex)/CCorelation1(peakIndex)); % Return tan^(-1) of x
Scal=sign(CCorelation1(peakIndex));
CarrierAdjustment = cos(2*pi*Fc.*t1 - phase);
CarrierS=ReceivedSignal.*CarrierAdjustment;
BBDemoSignal=filter(h_t,1,CarrierS);
figure(9)
plot(BBDemoSignal);
title('Demodulated Signal')
%%%Sampling
K=150;
Magnitude=zeros(1,Fs/Rs);
figure(10)
DemoSignal=BBDemoSignal(1:Fs/Rs:K*Fs/Rs);
stem(DemoSignal);
for i=1:Fs/Rs
    Sample=BBDemoSignal(i+30*440:Fs/Rs:K*Fs/Rs);
    Magnitude(i)=sum(abs(Sample));
    Magnitude(i)=Magnitude(i)/K;
end
%%%
MaxMag=find(Magnitude==max(Magnitude));
Sample=BBDemoSignal(MaxMag+30*440:Fs/Rs:length(BBDemoSignal));
Count1=zeros(1,length(Sample));
Threshold=.5;
k=0;
if Scal>0
    for i=1:length(Sample)
        k=k+1;
        if Sample(i)>Threshold
            Count1(k)=1;
        elseif Sample(i)<(-1*Threshold)
            Count1(k)=0;
        end
    end
elseif Scal<0
    for i=1:length(Sample)
        k=k+1;
        if Sample(i)>Threshold
            Count1(k)=0;
        elseif Sample(i)<(-1*Threshold)
            Count1(k)=1;
        end
    end
end
Count1=1-Count1;
figure(11)
stem(Count1)
title('Regulated Signal')
%%%Remove Pilot & Decode
for i = 1:length(Count1)-12
    if(Count1(i:i+12)==BS)
       MessStart=i+13; 
       break;
    end
end
for i = MessStart:length(Count1)-12
    if(Count1(i:i+12)==BS)
       MessEnd=i-1;
       break;
    end
end
Signal=Count1(MessStart:MessEnd);
figure(12)
stem(Signal);
title("Signal After Removing Pilots")

trellis=poly2trellis(3,[5 7]);
DecodeS=vitdec(Signal,trellis,12,'term','hard');
figure(13)
stem(DecodeS);
title("Signal After Decoding (Final Signal)")
%%%EBR & SNR
CorrDecodeS=upsample(DecodeS,2);
Correlation=CorrDecodeS-atob('Hello');
Count2=0;
for i=1:length(Correlation)
    if Correlation(i)==1
        Count2=Count2+1;
    end
end
BER=Count2/length(Correlation)

Receivers=audiorecorder(Fs,8,1);
recordblocking(Receivers,2);       %Choose t=3.9911 to be close to the tranmitter sample
Noise=getaudiodata(Receivers)';
VarianceN=var(Noise);
Eb=mean(abs(ReceivedSignal).^2)*Ts/2;
SNR=Eb/VarianceN
%%%The Detected Signal
btoa(DecodeS)








