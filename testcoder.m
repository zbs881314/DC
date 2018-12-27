clear;

seq = [1 0 1 1 0 0 1 1 1 1 0];
g1 = [1 0 1]; 
g2 = [0 1 1];
seq_en = C_encoder(seq,g1,g2);
seq_en(5) = mod(seq_en(5)+1,2); %flip the 5th bit to test the robust 
seq_de = C_decoder(seq_en,g1,g2);
disp('Orignal sequence:');
disp(seq);
disp('Decoded sequence:');
disp(seq_de);
disp('Codeword:')
disp(seq_en);