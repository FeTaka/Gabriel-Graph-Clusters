%% This program is free software;
%% File for Generating the Z Matrix
%% Generates a matrix with the values of the PDF function for all domain
%%
%% -*- texinfo -*-
%%

%% Load Variables
load('PDF_function.mat')

%% Generate Z matrix
zfun = @(x,y)pdf(obj,mapstd('apply',[x y]',ps)');
[p,q] = meshgrid(-700:1:0, 0:1:700);
Z = zeros(71,71);
step = 1;
for i=0:step:700
    for j=0:step:700
        Z(i/step+1,j/step+1) = zfun(-700+i,j);
    end
end

%% Save Variables
save('ZMatrix.mat', 'Z')

