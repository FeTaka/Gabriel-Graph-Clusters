%% GENERATE DISTRIBUTION OF NULL HYPOTHESIS
function llr = monte_carlo_llr_nh(X, D, N)
nc = sum(D==1);
llr = zeros(N,1);
parfor i =1:N
    Dd = zeros(size(D));
    diseased = randperm(length(D), nc);
    Dd(diseased) = 1;
    [obj, gg] = gg_probability_func (X, Dd, 10);
    [~, ~, Allr] = scanning_gg_clusters (obj, X, Dd, gg);
    llr(i) = max(Allr);
end

