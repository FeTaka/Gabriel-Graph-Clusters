%% This program is free software
%%
%% -*- texinfo -*-
%% @deftypefn {Function File} {@var{rsk_func} =} gg_probability_func (@var{X}, @var{D})
%% @deftypefnx {Function File} {@var{rsk_func} =} gg_probability_func (@var{X}, @var{D}, @var{A})
%% Create an object of the gmdistribution class which represents the contagium risk
%% of a syndrome in a region
%%
%% Input @var{X} is a n-by-2 matrix specifying the geographical coordinates
%% of every individual
%%
%% Input @var{D} is an array of length n that specifies the classification of 
%% the individuals valued 1 infected indiviual and -1 control individuals
%%
%% If @var{A} is specified, it is a vector of length k specifying spread 
%% coefficients alpha ???????
%% DX
%%
%% @end deftypefn
%%
function [rsk_func, Gg] = gg_probability_func (X, D, varargin)
%% Inputs
Defaults = {0.1};
idx = ~cellfun('isempty',varargin);
Defaults(idx) = varargin(idx);
[A] = Defaults{:};
%%
%% Gabriel Graph
fprintf('\n:: Building Gabriel Graph...')
%randomazing input
random_order = randperm(length(D));
X = X(random_order, :);
D = D(random_order);
[edge,d,Gg]=Grafo_Gabriel(X,D);
vertices_edges=find(edge==1);
%%
%% Mixture Model
fprintf('\n:: Calculating Mixture...')
sigma=cat(3,zeros(2));
% Centers
mu = zeros(length(vertices_edges),2);
dist_between_centers=zeros(length(vertices_edges),1);
dist_center_total=zeros(length(vertices_edges),1);
dist_center_infect=zeros(length(vertices_edges),1);
dist_centers = d.*Gg;

for i=1:length(vertices_edges)
    c = vertices_edges(i);
    r = min(dist_centers(c,dist_centers(c,:)>0));
    %r = sum(dist_centers(c,:));
    mu(i,:) = [X(c,1), X(c,2)];
    sigma(:,:,i) = eye(2).*r;
    dist_between_centers(i) = (sum(d(c,vertices_edges(vertices_edges~=c))));
    %i_dist =(1./(d(c,:)));
    %i_dist(i_dist == Inf) = 10;
    %dist_center_total(i) = (i_dist)*Gg(:,c);
    %dist_center_infect(i) = (i_dist)*((Gg(:,c)).*((D+1)/2)); 
    dist_center_total(i) = sum((d(c,:))*Gg(:,c));
    dist_center_infect(i) = sum((d(c,:))*((Gg(:,c)).*((D+1)/2))); 
    %dist_between_centers_infect(i) = d(c,vertices_edges(vertices_edges~=c))*((D(vertices_edges(vertices_edges~=c))+1)/2);
end
%%
%% Using k spread coefficients ???????
for i=1:length(A)    
    %% Weighting the gmms
    alfa = A(i);
    w = exp(-(1./dist_between_centers).^2/(2*alfa^2));
    w = w./sum(w);%.*(((dist_center_infect)./(dist_center_total)));
    obj = gmdistribution(mu,sigma,w);
end
%%
%% Output
[~,reorder] = sort(random_order);
Gg = Gg(reorder,reorder);
rsk_func = obj;
end