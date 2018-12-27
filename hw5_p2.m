% MATLAB CODE TO SOLVE THE PROB C
clear;
G = [1 1 1 1 1 0 0 0 0;
     1 0 1 1 0 1 0 0 0;
     0 1 1 1 0 0 1 0 0;
     1 1 0 1 0 0 0 1 0;
     1 1 1 0 0 0 0 0 1;];

M = abs(dec2bin(0:(2^5-1), 5))-48;

U = M*G;

U2 = mod(U,2);

W = [];
for i = 1:32
    for j = 1:32
        if i~=j
            W = [W;(xor(U2(i,:),U2(j,:)))];
        end
    end
end

D = [];
for i = 1:992
    sum = 0;
    for j = 1:9
        sum = sum + W(i,j);
    end
    D = [D;sum];
end

X = sprintf('dmin = %d',min(D));
disp(X);
% THE OUTPUT IS dmin = 3