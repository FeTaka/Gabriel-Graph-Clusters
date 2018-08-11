%% This program is free software;
%% 
%% 
%% -*- texinfo -*-
%%

load('PDF_function.mat')

zfun = @(x,y)pdf(obj,mapstd('apply',[x y]',ps)');
[p,q] = meshgrid(-700:1:0, 0:1:700);
Z = zeros(71,71);
step = 1;
for i=0:step:700
    for j=0:step:700
        Z(i/step+1,j/step+1) = zfun(-700+i,j);
    end
end

save('ZMatrix.mat', 'Z')

