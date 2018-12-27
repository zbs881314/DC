% CODE FOR PROB5
clear;
G = [1 1 1 0 1 0 0 0;
     1 0 1 1 0 1 0 0;
     0 1 1 1 0 0 1 0;
     1 1 0 1 0 0 0 1];

H = [1 0 0 0 1 1 0 1;
     0 1 0 0 1 0 1 1;
     0 0 1 0 1 1 1 0;
     0 0 0 1 0 1 1 1];

r1 = [1 0 1 0 1 0 1 0];
r2 = [0 1 0 1 1 1 0 0];

M = abs(dec2bin(0:(2^4-1), 4))-48;

U = M*G;

U2 = mod(U,2);

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

disp(mod(r1*H',2));
disp(mod(r2*H',2));