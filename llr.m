function [ val ] = llr( Z, D )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

C = sum(D==1);
sC = length(D);
cz = sum(Z==1);
sz = length(Z);
%muz =C/sz;
muz =sz*(C/sC);
Iz = cz/muz;
Oz = (C-cz)/(C - muz);

val = log(Iz^cz*Oz^(C-cz));
end

