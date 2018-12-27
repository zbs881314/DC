% Usage: input is the sequence to be dencoded, g1 and g2 are generate matrix
% Example: decode = C_decoder([1 1 1 0 1 1],[1 1 0],[1 0 1]);

function [decode] = C_decoder(input,g1,g2) 
trellis = poly2trellis(3,[g1(1)*4+g1(2)*2+g1(3)*1,g2(1)*4+g2(2)*2+g2(3)*1]);
tblen = 15;
decode = vitdec(input,trellis,tblen,'cont','hard');
decode = decode(tblen+1:length(decode));
end