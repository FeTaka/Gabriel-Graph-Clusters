%% This program is free software;
%% 
%% 
%% -*- texinfo -*-
%%

%% Load Varaibles
load('PDF_function.mat')

%% Null hypothesis test
N = 1000;
llrN = monte_carlo_llr_nh(X,D,N);

%% Save Variables
save('LLR_MonteCarlo.mat', 'llrN')