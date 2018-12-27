  %% Time specifications:
   Fs = 44000;                      % samples per second
   dt = 1/Fs;                     % seconds per sample
   StopTime = 1;                  % seconds
   t = (0:dt:StopTime-dt)';
   N = size(t,1);
   %% Sine wave:
   Fc = 1000;                       % hertz
   x = sin(2*pi*Fc*t);
   %% Fourier Transform:
   X = fftshift(fft(x));
   %% Frequency specifications:
   dF = Fs/N;                      % hertz
   f = -Fs/2:dF:Fs/2-dF;           % hertz
   %% Plot the spectrum:
   figure(1);
   plot(f,abs(X)/N);
   axis([-1500 1500 0 1])
   xlabel('Frequency (in hertz)');
   title('Spectrum of transmitted cosine wave');
   wavplay(x,Fs,'async');
   r = wavrecord(1*Fs,Fs);
   R = fftshift(fft(r));
   N2 = length(r);
   dF2 = Fs/N2;
   f2 = -Fs/2:dF2: Fs/2-dF2;
   figure(2);
   plot(f2,abs(R)/N2);
   axis([-1500 1500 0 0.3])
   xlabel('Frequency (in hertz)');
   title('Spectrum of recieved cosine wave');
   figure(3);
   plot(f2,abs(R)/N2);
   axis([995 1005 0 0.3])
   xlabel('Frequency (in hertz)');
   title('Zoomed in Magnitude Response');
   %t2 = (0:dt:length(r)/Fs-dt);
   %N2 = size(t2,1);
   %dF2 = Fs/N2;
   % figure;
   %plot(f2,abs(R)/N2);
   %axis([-5000 5000 0 5000])