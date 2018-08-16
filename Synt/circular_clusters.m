

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
    [obj, Gg] = gg_probability_func(X, D', 100);
    rsk_func = @(X)(pdf(obj, X')*sqrt(px.gain'*px.gain)/2);
    
    pdfO = mvnpdf(OX, mu, Sigma);
    pdfE = rsk_func(mapstd('apply', OX', px));
    d_js = jensen_shannon(pdfO, pdfE);
    %d_js1 = jensen_shannon(pdfO, ones(size(pdfO)));
    %d_js0 = jensen_shannon(pdfO, zeros(size(pdfO)));
    d_jsR = jensen_shannon(pdfO, rand(size(pdfO)));
    %r_js(:,i) = [d_js; d_js1; d_js0; d_jsR];
    r_js(:,i) = [d_js;d_jsR];
    
    fprintf('\n:: Scanning Clusters...')
    [C, T, L] = scanning_gg_clusters (rsk_func, X, D, Gg);
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
mean_qlt=[mean(cluster_qlt,2), std(cluster_qlt,0,2)];

save('stats_circular_cluster','h', 'p', 'ci', 'stats', 'mean_qlt')

% %% Plots
% x1 = -5:0.1:5; x2 = -5:0.1:5;
% [X1,X2] = meshgrid(x1,x2);
% selX = randperm(numel(X1));
% Sigma = [1 0; 0 1];
% mu = [0 0];
% 
% OX = [X1(:) X2(:)];
% OX = OX(selX(1:500),:);
% [X, px]= mapstd(OX');
% X = X';
% 
% %creating sick and sane inputs with generated model
% F = mvnpdf(OX,mu,Sigma);
% [F,~]=mapminmax(F', 0, 1);
% D = -1*ones(size(F));
% R = rand(size(F));
% D(R < F) = 1;
% 
% %method
% [obj, Gg] = gg_probability_func(X, D', 100);
% rsk_func = @(X)(pdf(obj, X')*sqrt(px.gain'*px.gain)/2);
% 
% zfun = @(x,y)rsk_func(mapstd('apply',[x y]',px));
% xi = -5:0.1:5; xj = -5:0.1:5;
% Zp = zeros(length(xi),length(xj));
% Zo = zeros(length(xi),length(xj));
% step = 1;
% for i=1:step:length(xi)
%     for j=1:step:length(xj)
%         Zp(i,j) = zfun(xi(i),xj(j));
%         Zo(i,j) = mvnpdf([xi(i),xj(j)],mu,Sigma);
%     end
% end
% 
% figure;
% h=plot(OX(D==-1,1), OX(D==-1,2), '.k', 'MarkerSize',5)
% hold on
% plot(OX(D==1,1), OX(D==1,2), '.r', 'MarkerSize',5)
% contour([-5:0.1:5], [-5:0.1:5],Zo);
% %set(h,'edgecolor','none')
% contourcmap('winter')
% caxis([0 max(max(Zo))])
% hold off
% %Save Image
% saveas(h,'cluster_circle_original.eps','epsc')
% savefig('cluster_circle_original')
% 
% figure;
% h=plot(OX(D==-1,1), OX(D==-1,2), '.k', 'MarkerSize',5);
% hold on
% plot(OX(D==1,1), OX(D==1,2), '.r', 'MarkerSize',5);
% contour(-5:0.1:5, -5:0.1:5,Zp);
% %set(h,'edgecolor','none')
% contourcmap('autumn')
% caxis([0 max(max(Zp))])
% hold off
% %Save Image
% saveas(h,'cluster_circle_estimate.eps','epsc')
% savefig('cluster_circle_estimate')
% 
% figure;
% Z=arrayfun(@(x,y)mvnpdf([x y],mu,Sigma),X1, X2);
% h=plot(max(Z)', 'b');
% hold on
% Z=arrayfun(@(x,y)rsk_func(mapstd('apply',[x y]',px)),X1, X2);
% plot(max(Z)', 'r')
% %Save Image
% saveas(h,'cluster_circle_sec.eps','epsc')
% savefig('cluster_circle_sec')
% 
% pdfO = mvnpdf(OX,mu,Sigma);
% pdfE = rsk_func(mapstd('apply', OX', px));
% d_js = jensen_shannon(pdfO, pdfE);
% 
% fprintf('\n:: Scanning Clusters...')
% [C, T, L] = scanning_gg_clusters (rsk_func, X, D, Gg);
% fprintf('\n:: Discarding Clusters...\n')
% [clusters, threshold, llr] = discard_extra_clusters(C, D', T, L);
% [~, id] = max(llr);
% dataE = clusters'==id;
% dataR = realPoints(OX, mu, Sigma);
% ppv_val = ppv(dataR, dataE);
% sensitivity_val = sensitivity(dataR, dataE);
% specificity_val = specificity(dataR, dataE);
% 
% figure
% %plot(OX(clusters~=id, 1), OX(clusters~=id, 2), 'ok', 'MarkerSize', 5)
% %plot(OX(clusters==id, 1), OX(clusters==id, 2), 'or', 'MarkerSize', 5)
% h=plot(OX(D==-1,1), OX(D==-1,2), '.k', 'MarkerSize',5);
% hold on
% plot(OX(D==1,1), OX(D==1,2), '.r', 'MarkerSize',5);
% contour(-5:0.1:5, -5:0.1:5, (Zp), [threshold(id),threshold(id)] , 'lineWidth', 3, 'color', 'r');
% %Save Image
% saveas(h,'cluster_circle_cluster.eps','epsc')
% savefig('cluster_circle_cluster')
