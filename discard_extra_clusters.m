%% This program is free software;
%% It consists of the third final step of the work discribed in...
%% Steps 1 and 2 are mde in function gg_probability_func
%% -*- texinfo -*-
%% @deftypefn {Function File} {@var{rsk_func} =} scanning_gg_clusters (@var{rsk_func})
%% Create an array containg the risk level and square delimiting the zone of
%% each detected cluster
%%
%% Input @var{rsk_func} an object of the gmdistribution class which represents the contagium risk
%% of a syndrome in a region
%% @end deftypefn
%%
function [clusters,threshold] = discard_extra_clusters(C, D, T)

ratioT = sum(D==1)/length(D);

U = unique(C);
U(1) = [];
remT = zeros(size(U));
for i = U
    ratioI = sum(C==i & D'==1)/sum(C==i);
    if ratioI <= ratioT
        C(C==i) = 0;
        remT(i)=1;
    end
end


T(remT==1)=[];
clusters = C;
threshold = T;