%% Null hypothesis test
load('LLR_MonteCarlo.mat')
load('clusterData.mat')
load('PDF_function.mat')
L = length(llr);
LLR = zeros(L,1);
N = zeros(L,1);
Priority = zeros(L,1);
p_value = zeros(L,1);
[mllr, illr] = sort(llr, 'descend');
for i=1:L
    [ht,p,ci,stats] = ttest(llrN,mllr(i),'Tail','left', 'Alpha', 0.05);
    %% Table
    Priority(i) = clas_cluster(illr(i));
    LLR(i) = mllr(i);
    N(i) = sum(D==1&clusters'==illr(i));
    p_value(i) = p;
end
T = table(Priority,LLR, N, p_value);
