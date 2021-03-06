

%% Sample parameters
N = 1000;
%nd = randi([2 5], 1, N); %number of functions

x1 = -5:0.1:5; x2 = -5:0.1:5;
[X1,X2] = meshgrid(x1,x2);
pdf_par = [-1 1; -1 1];


count_fail = 0;
nn=[];
%% Outputs
r_js = zeros(2,N);%resultado jensen shannon
cluster_qlt = zeros(3,N);

%% Test loop
for i =1:N
    OX = [X1(:) X2(:)];
    selX = randperm(numel(X1));
    OX = OX(selX(1:500),:);
    [X, px]= mapstd(OX');
    X = X';
    
    
    %creating sick and sane inputs with generated model
    pdf_func = @(X,par)(pdf(makedist('Uniform','lower',par(1,1),'upper',par(1,2)),X(:,1)).*pdf(makedist('Uniform','lower',par(2,1),'upper',par(2,2)),X(:,2)));
    F = pdf_func(OX,pdf_par);
    D = -1*ones(size(F));
    R = rand(size(F));
    D(R < F*2) = 1;
    D=D';
    
    %method
    [obj, Gg] = gg_probability_func(X, D', 10);
    rsk_func = @(X)(pdf(obj, X')*sqrt(px.gain'*px.gain)/2);
    
    
    pdfO = pdf_func(OX,pdf_par);
    pdfE = rsk_func(mapstd('apply', OX', px));
    d_js = jensen_shannon(pdfO, pdfE);
    %d_js1 = jensen_shannon(pdfO, ones(size(pdfO)));
    %d_js0 = jensen_shannon(pdfO, zeros(size(pdfO)));
    d_jsR = jensen_shannon(pdfO, rand(size(pdfO)));
    %r_js(:,i) = [d_js; d_js1; d_js0; d_jsR];
    r_js(:,i) = [d_js;d_jsR];
    
    fprintf('\n:: Scanning Clusters...')
    [C, T, L] = scanning_gg_clusters (rsk_func, X, D, Gg);
    if ~isempty(L)
        fprintf('\n:: Discarding Clusters...\n')
        [clusters, threshold, llr] = discard_extra_clusters(C, D', T, L);
        [~, id] = max(llr);
        dataE = clusters'==id;
        dataR = realPointsS(OX, pdf_par);
        ppv_val = ppv(dataR, dataE);
        sensitivity_val = sensitivity(dataR, dataE);
        specificity_val = specificity(dataR, dataE);
        cluster_qlt(:,i) = [ppv_val; sensitivity_val; specificity_val];
    else
        cout_fail = count_fail+1;
        nn=[nn,i];
    end
end
save('data_square_cluster','r_js', 'cluster_qlt')


[h,p,ci,stats] = ttest(r_js(1,:), r_js(2,:),'Tail','left');

mean_qlt = [mean(cluster_qlt,2), std(cluster_qlt,0,2)];
save('stats_square_cluster','h','p','ci','stats', 'mean_qlt')
% %% Plots
% x1 = -5:0.1:5; x2 = -5:0.1:5;
% [X1,X2] = meshgrid(x1,x2);
% selX = randperm(numel(X1));
% pdf_par = [-1 1; -1 1];
% 
% OX = [X1(:) X2(:)];
% OX = OX(selX(1:500),:);
% [X, px]= mapstd(OX');
% X = X';
% 
% %creating sick and sane inputs with generated model
% pdf_func = @(X,par)(pdf(makedist('Uniform','lower',par(1,1),'upper',par(1,2)),X(:,1)).*pdf(makedist('Uniform','lower',par(2,1),'upper',par(2,2)),X(:,2)));
% F = pdf_func(OX,pdf_par);
% D = -1*ones(size(F));
% R = rand(size(F));
% D(R < F*2) = 1;
% D=D';
% 
% %method
% [obj, Gg] = gg_probability_func(X, D', 10);
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
%         Zo(i,j) = pdf_func([xi(i),xj(j)],pdf_par);
%     end
% end
% 
% 
% 
% figure;
% h=plot(OX(D==-1,1), OX(D==-1,2), '.k', 'MarkerSize',5);
% hold on
% plot(OX(D==1,1), OX(D==1,2), '.r', 'MarkerSize',5)
% contour([-5:0.1:5], [-5:0.1:5],Zo);
% %set(h,'edgecolor','none')
% contourcmap('winter')
% caxis([0 max(max(Zo))])
% hold off
% %Save Image
% saveas(h,'cluster_square_original.eps','epsc')
% savefig('cluster_square_original')
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
% saveas(h,'cluster_square_estimate.eps','epsc')
% savefig('cluster_square_estimate')
% 
% figure;
% Z=arrayfun(@(x,y)pdf_func([x y],pdf_par),X1, X2);
% h=plot(max(Z)', 'b');
% hold on
% Z=arrayfun(@(x,y)rsk_func(mapstd('apply',[x y]',px)),X1, X2);
% plot(max(Z)', 'r')
% hold off
% %Save Image
% saveas(h,'cluster_square_sec.eps','epsc')
% savefig('cluster_square_sec')
% 
% pdfO = pdf_func(OX,pdf_par);
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
% figure;
% %plot(OX(clusters~=id, 1), OX(clusters~=id, 2), 'ok', 'MarkerSize', 5)
% %plot(OX(clusters==id, 1), OX(clusters==id, 2), 'or', 'MarkerSize', 5)
% h=plot(OX(D==-1,1), OX(D==-1,2), '.k', 'MarkerSize',5);
% hold on
% plot(OX(D==1,1), OX(D==1,2), '.r', 'MarkerSize',5)
% contour(-5:0.1:5, -5:0.1:5, (Zp), [threshold(id),threshold(id)] , 'lineWidth', 3, 'color', 'r')
% %Save Image
% saveas(h,'cluster_square_cluster.eps','epsc')
% savefig('cluster_square_cluster')