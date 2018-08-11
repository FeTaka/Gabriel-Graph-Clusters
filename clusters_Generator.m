%% This program is free software;
%% 
%% 
%% -*- texinfo -*-
%%

load('PDF_function.mat')

fprintf('\n:: Scanning Clusters...')
[C, T, llr] = scanning_gg_clusters (obj, X, D, Gg);
fprintf('\n:: Discarding Clusters...\n')
[clusters, threshold, llr] = discard_extra_clusters(C, D, T, llr);
[~, ~, ci, ~] = normfit(llr, 0.05);
clusters2 = zeros(size(clusters));
clas_cluster = ones(size(llr));
clas_cluster = clas_cluster + (llr < ci(1)) + (llr < ci(2));
U = unique(clusters);
U(1) = [];
for i=1:length(U)
    clusters2(clusters==U(i))=clas_cluster(i);
end

save('clusterData.mat', 'clusters2', 'clusters', 'threshold', 'clas_cluster')


% %% Null hypothesis test
% N = 5;
% llrN = monte_carlo_llr_nh(X, D,N);
% [mllr, illr] = max(llr);
% [ht,p,ci,stats] = ttest(llrN,mllr,'Alpha',0.05);
% %% Table
% Method = {'GGScan'};
% LLR = [mllr];
% N = [sum(D==1&clusters2'==illr)];
% p_value = [p];
% 
% T = table(LLR, N, p_value, 'RowNames', Method);