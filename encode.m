function [encoded] = encode(message)
% SAM Phase II 
% append zeros to flush  register
K = 3;
m = [message zeros(1,K-1)];
g1 = [1 0 1];
g2 = [1 1 1];

code_sofar = cell(1);
reg = zeros(1,K);
for i=1:length(m)
	reg = [m(i) reg(2:end)];
	u1 = mod(sum(reg*g1'),2);
	u2 = mod(sum(reg*g2'),2);
	code_sofar = [code_sofar u1 u2];
	reg = [0 reg(1:2)];
end	
encoded = cell2mat(code_sofar);
end