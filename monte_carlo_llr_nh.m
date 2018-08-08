%% GENERATE DISTRIBUTION OF NULL HYPOTHESIS
function llr = monte_carlo_llr_nh(obj, X, D, gg, N)
nc = sum(D==1);
Dd = zeros(size(D));
llr = zeros(N,1);
for i =1:N
    Dd(:) = 0;
    diseased = randperm(length(D), nc);
    Dd(diseased) = 1;
    [obj, Gg] = gg_probability_func (X, Dd, 10);
    [C, T, Allr] = scanning_gg_clusters (obj, X, Dd, gg);
    llr(i) = max(Allr);
end
