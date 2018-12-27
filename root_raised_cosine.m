function [rr_cos_TD] = root_raised_cosine(r,Rs,Fs)

t_T=(-3:Rs/Fs:3)+1e-8;
rr_cos_TD=(cos((1+r)*pi*t_T)+sin((1-r)*pi*t_T)./(4*r*t_T))./(1-(4*r*t_T).^2);
rr_cos_TD=rr_cos_TD/max(rr_cos_TD);
%plot(t_T,rr_cos_TD)
%figure()
%omega_bin =Fs/2048;
%omega = -Fs/2:omega_bin:Fs/2-omega_bin;
%plot(omega,abs(fftshift(fft(rr_cos_TD,2048))));
end