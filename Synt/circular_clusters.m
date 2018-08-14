

%% Sample parameters
N = 10;
%nd = randi([2 5], 1, N); %number of functions

x1 = -9:0.5:9; x2 = -9:0.5:9;
[X1,X2] = meshgrid(x1,x2);
Sigma = [3 0; 0 3];
mu = [0 0];

%% Outputs
r_js = zeros(2,N);%resultado jensen shannon
cluster_qlt = zeros(3,N);

%% Test loop
for i =1:N
    
    OX = [X1(:) X2(:)];
    [X, px]= mapstd(OX');
    X = X';

    %creating sick and sane inputs with generated model
    F = mvnpdf(OX,mu,Sigma);
    [F,~]=mapminmax(F', 0, 1);
    D = -1*ones(size(F));
    R = rand(size(F));
    D(R < F) = 1;

    %method
    [obj, Gg] = gg_probability_func(X, D');
    rsk_func = @(X)(pdf(obj, X')/10);

    pdfO = mvnpdf(OX, mu, Sigma);
    pdfE = rsk_func(mapstd('apply', OX', px));
    d_js = jensen_shannon(pdfO, pdfE);
    %d_js1 = jensen_shannon(pdfO, ones(size(pdfO)));
    %d_js0 = jensen_shannon(pdfO, zeros(size(pdfO)));
    d_jsR = jensen_shannon(pdfO, rand(size(pdfO)));
    %r_js(:,i) = [d_js; d_js1; d_js0; d_jsR];
    r_js(:,i) = [d_js;d_jsR];
    
    fprintf('\n:: Scanning Clusters...')
    [C, T, L] = scanning_gg_clusters (obj, X, D, Gg);
    fprintf('\n:: Discarding Clusters...\n')
    [clusters, threshold, llr] = discard_extra_clusters(C, D, T, L);
    [~, id] = max(llr);
    dataE = clusters'==id;
    dataR = realPoints(OX, mu, Sigma);
    ppv_val = ppv(dataR, dataE);
    sensitivity_val = sensitivity(dataR, dataE);
    specificity_val = specificity(dataR, dataE);
    cluster_qlt(:,i) = [ppv_val; sensitivity_val; specificity_val];
end
save('data_circular_cluster','r_js', 'cluster_qlt')

[h,p,ci,stats] = ttest(r_js(1,:), r_js(2,:),'Tail','left');

%% Plots
x1 = -9:0.5:9; x2 = -9:0.5:9;
[X1,X2] = meshgrid(x1,x2);
selX = randperm(numel(X1));
Sigma = [3 0; 0 3];
mu = [0 0];

OX = [X1(:) X2(:)];
OX = OX(selX(1:1000),:);
[X, px]= mapstd(OX');
X = X';

%creating sick and sane inputs with generated model
F = mvnpdf(OX,mu,Sigma);
[F,~]=mapminmax(F', 0, 1);
D = -1*ones(size(F));
R = rand(size(F));
D(R < F) = 1;

%method
obj = gg_probability_func(X, D');
rsk_func = @(X)(pdf(obj, X')/10);

figure;
plot(OX(D==1,1), OX(D==1,2), '.k')
hold on
h(2)=ezcontour(@(x,y)mvnpdf([x y],mu,Sigma),[-10 10],[-10 10],100);
        %set(h,'edgecolor','none')
        colormap winter
hold off

figure;
plot(OX(D==-1,1), OX(D==-1,2), '.r')
hold on
plot(OX(D==1,1), OX(D==1,2), '.k')

h(2)=ezcontour(@(x,y)rsk_func(mapstd('apply',[x y]',px)),[-10 10],[-10 10],100);
        %set(h,'edgecolor','none')
        colormap autumn
hold off

%
figure;
Z=arrayfun(@(x,y)mvnpdf([x y],mu,Sigma),X1, X2);
plot(max(Z)', 'b')
hold on
Z=arrayfun(@(x,y)rsk_func(mapstd('apply',[x y]',px)),X1, X2);
plot(max(Z)', 'r')

pdfO = mvnpdf(OX,mu,Sigma);
pdfE = rsk_func(mapstd('apply', OX', px));
d_js = jensen_shannon(pdfO, pdfE);