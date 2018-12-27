% CODE FOR PROB4
clear;
G = [1 1 1 1 0 0 0;
     1 0 1 0 1 0 0;
     0 1 1 0 0 1 0;
     1 1 0 0 0 0 1;];
 
H = [1 0 0 1 1 0 1;
     0 1 0 1 0 1 1;
     0 0 1 1 1 1 0];
 
r = [1 1 0 1 1 0 1];

S = r*H';
S = mod(S,2);
%disp(S); % Solotion for prob c

M = abs(dec2bin(0:(2^4-1), 4))-48;

U = M*G;

U2 = mod(U,2);
disp(U2);

W = [];
for i = 1:16
    for j = 1:16
        if i~=j
            W = [W;(xor(U2(i,:),U2(j,:)))];
        end
    end
end

D = [];
for i = 1:(16*15)
    sum = 0;
    for j = 1:7
        sum = sum + W(i,j);
    end
    D = [D;sum];
end

X = sprintf('dmin = %d',min(D));
disp(X);
% dmin = 3