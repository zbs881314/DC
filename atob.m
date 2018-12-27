function dn = atob(txt)
dec = double(txt);
p2=2.^(0:-1:-7);
b=mod(floor(p2'*dec),2);
dn=reshape(b,1,numel(b));


