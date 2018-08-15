

%% Sample parameters
N = 1000;
%nd = randi([2 5], 1, N); %number of functions

x1 = -5:0.1:5; x2 = -5:0.1:5;
[X1,X2] = meshgrid(x1,x2);

Sigma = [1 0; 0 1];
mu = [0 0];

%% Outputs
r_js = zeros(2,N);%resultado jensen shannon
cluster_qlt = zeros(3,N);

%% Test loop
for i =1:N
    selX = randperm(numel(X1));
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
x1 = -5:0.1:5; x2 = -5:0.1:5;
[X1,X2] = meshgrid(x1,x2);
selX = randperm(numel(X1));
Sigma = [1 0; 0 1];
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
[obj, Gg] = gg_probability_func(X, D');
rsk_func = @(X)(pdf(obj, X')*sqrt(px.gain'*px.gain)/2);

zfun = @(x,y)rsk_func(mapstd('apply',[x y]',px));
xi = -5:0.5:5; xj = -5:0.5:5;
Zp = zeros(length(xi),length(xj));
Zo = zeros(length(xi),length(xj));
step = 1;
for i=1:step:length(xi)
    for j=1:step:length(xj)
        Zp(i,j) = zfun(xi(i),xj(j));
        Zo(i,j) = mvnpdf([xi(i),xj(j)],mu,Sigma);
    end
end

figure;
plot(OX(D==-1,1), OX(D==-1,2), '.k', 'MarkerSize',5)
hold on
plot(OX(D==1,1), OX(D==1,2), '.r', 'MarkerSize',5)
hold on
h=contour([-5:0.5:5], [-5:0.5:5],Zo);
        %set(h,'edgecolor','none')
        contourcmap('winter')
hold off

figure;
plot(OX(D==-1,1), OX(D==-1,2), '.k', 'MarkerSize',5)
hold on
plot(OX(D==1,1), OX(D==1,2), '.r', 'MarkerSize',5)

h=contour(-5:0.5:5, -5:0.5:5,Zp);
        %set(h,'edgecolor','none')
        contourcmap('autumn')
hold off


figure;
Z=arrayfun(@(x,y)mvnpdf([x y],mu,Sigma),X1, X2);
plot(max(Z)', 'b')
hold on
Z=arrayfun(@(x,y)rsk_func(mapstd('apply',[x y]',px)),X1, X2);
plot(max(Z)', 'r')

pdfO = mvnpdf(OX,mu,Sigma);
pdfE = rsk_func(mapstd('apply', OX', px));
d_js = jensen_shannon(pdfO, pdfE);

 fprintf('\n:: Scanning Clusters...')
 [C, T, L] = scanning_gg_clusters (rsk_func, X, D, Gg);
 fprintf('\n:: Discarding Clusters...\n')
 [clusters, threshold, llr] = discard_extra_clusters(C, D', T, L);
 [~, id] = max(llr);
 dataE = clusters'==id;
 dataR = realPoints(OX, mu, Sigma);
 ppv_val = ppv(dataR, dataE);
 sensitivity_val = sensitivity(dataR, dataE);
 specificity_val = specificity(dataR, dataE);

figure
plot(OX(clusters~=id, 1), OX(clusters~=id, 2), 'ok', 'MarkerSize', 10)
hold on
plot(OX(clusters==id, 1), OX(clusters==id, 2), 'or', 'MarkerSize', 10)

plot(OX(D==-1,1), OX(D==-1,2), '.k', 'MarkerSize',5)
plot(OX(D==1,1), OX(D==1,2), '.r', 'MarkerSize',5)

xmin = min(OX(clusters==id,1));
%xmin = xmin - 1;
xmin = round((xmin+5)/0.5);
ymin = min(OX(clusters==id,2));
%ymin = ymin - 1;
ymin = round((ymin+5)/0.5);
xmax = max(OX(clusters==id,1));
%xmax = xmax + 1;
xmax = round((xmax+5)/0.5);
ymax = max(OX(clusters==id,2));
%ymax = ymax + 1;
ymax = round(ymax+5/step);
M = ones(size(Zp));
M(1:xmin, :) = 0;
M(xmax:end, :) = 0;
M(:, 1:ymin) = 0;
M(:, ymax:end) = 0;
M=M+1;
contour(-5:0.5:5, -5:0.5:5, (Zp.*M)', threshold(id), 'lineWidth', 3)

