% Usage: input is the sequence to be encoded, g1 and g2 are generate matrix
% Example: code = C_encoder([1 1 1 0 1 1],[1 1 0],[1 0 1]);
% notice: the length of output U is 2*(input+15)

function [U] = C_encoder(input,g1,g2) 
trellis = poly2trellis(3,[g1(1)*4+g1(2)*2+g1(3)*1,g2(1)*4+g2(2)*2+g2(3)*1]);
U = convenc([input zeros(1,15)],trellis);
end