

[Ix, Iy] = dataRead(0);
D=Iy;
D(D==0)=-1;
Ix(:,1)=-Ix(:,1);
Ox=Ix;
[Ix, ps]=mapstd(Ix'); %normalizando media 0 desvio padrao 1.
[X, m, n]=unique(Ix','rows','last'); % retirando amostras repetidas.
dt = delaunayTriangulation(X);
D=D(m);
Ox=Ox(m,:);
%[pX, pYd] = runGrid(0.25, 0.50, Ix', Iy);

[obj, Gg] = gg_probability_func (X, D, 0.1);

gg_graph = graph(sparse(Gg));
figure;
h=plot(gg_graph, 'xData', Ox(:,1), 'yData', Ox(:,2));
hold on
plot(Ox(D==-1, 1), Ox(D==-1, 2), '.k')
plot(Ox(D==1, 1), Ox(D==1, 2), '.r','MarkerSize',10)
hold off
saveas(h,'ggDengue.eps','epsc')
savefig('ggDengue')

% figure;
% hold on
% [h]=ezcontour(@(x,y)pdf(obj,mapstd('apply',[x y]',ps)'),[0 -700],[0 700],100);
% %clabel([], h);
% title('')
% plot(Ox(D==1,1),Ox(D==1,2),'MarkerFaceColor',[1 0 0],'MarkerSize',3,'Marker','o','LineStyle','none','Color',[1 0 0]);
% set(gca, 'Visible', 'off')
% set(gca, 'color', 'none');
% set(gcf, 'color', 'none');
% [h]=ezcontour(@(x,y)pdf(obj, [x, y]),[0 -700],[0 800],1000);
% alpha(0.8); 
% saveas(h,'testes','png')
fprintf("\n:: Scanning Clusters...")
[C, T, llr] = scanning_gg_clusters (obj, X, D, Gg);
fprintf("\n:: Discarding Clusters...\n")
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
% 
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

colorvec = [[1 0 0]; [1 .5 0]; [1 1 0]];
figure;
[h]=ezcontour(@(x,y)pdf(obj,mapstd('apply',[x y]',ps)'),[0 -700],[0 700],100);
hold on
%[h] = fcontour(@(x,y)pdf(obj,mapstd('apply',[x y]',ps)'),[xmin, xmax, ymin, ymax], 'LevelList', [threshold(1)], 'LineColor', 'r');
plot(Ox(clusters2==0, 1), Ox(clusters2==0, 2), '.k')
plot(Ox(clusters2==1, 1), Ox(clusters2==1, 2), '.', 'color', colorvec(1,:))
plot(Ox(clusters2==2, 1), Ox(clusters2==2, 2), '.', 'color', colorvec(2,:))
plot(Ox(clusters2==3, 1), Ox(clusters2==3, 2), '.', 'color', colorvec(3,:))
for i = 1:length(U)
xmin = min(Ox(clusters==U(i),1));
xmin = xmin - 10;
ymin = min(Ox(clusters==U(i),2));
ymin = ymin - 10;
xmax = max(Ox(clusters==U(i),1));
xmax = xmax + 10;
ymax = max(Ox(clusters==U(i),2));
ymax = ymax + 10;
[h] = fcontour(@(x,y)pdf(obj,mapstd('apply',[x y]',ps)'),[xmin, xmax, ymin, ymax], 'LevelList', [threshold(i)], 'LineColor', colorvec(clas_cluster(i),:), 'LineWidth', 1.5);
end
hold off
saveas(h,'clusterDengue_data.eps','epsc')
savefig('clusterDengue_data')




% 
% x = [-509, -389];
% y = [550, 700];
% polyX = [x(1), x(2), x(2), x(1), x(1)];
% polyY = [y(1), y(1), y(2), y(2), y(1)];
% plot(polyX,polyY, 'r')
% 
% x = [-445, -290];
% y = [7, 148];
% polyX2 = [x(1), x(2), x(2), x(1), x(1)];
% polyY2 = [y(1), y(1), y(2), y(2), y(1)];
% plot(polyX2,polyY2, 'k')
% hold off
% 
% saveas(h,strcat('clustersDengue_',num2str(1)),'png')
% savefig(strcat('clustersDengue_',num2str(1)))
% 
% O = pdf(obj,mapstd('apply',Ox',ps)');
% cluster = scan_statistic(O, Ox, D, polyX, polyY);
% cluster2 = scan_statistic(O, Ox, D, polyX2, polyY2);
% 
% figure;
% [h]=ezcontour(@(x,y)pdf(obj,mapstd('apply',[x y]',ps)'),[0 -700],[0 700],100);
% hold on
% [h] = fcontour(@(x,y)pdf(obj,mapstd('apply',[x y]',ps)'),[-700, 0,0 700], 'LevelList', [cluster], 'LineColor', 'r');
% hold off
% saveas(h,strcat('clusterRDengue_',num2str(1)),'png')
% savefig(strcat('clusterRDengue_',num2str(1)))
% figure;
% [h]=ezcontour(@(x,y)pdf(obj,mapstd('apply',[x y]',ps)'),[0 -700],[0 700],100);
% hold on
% [h] = fcontour(@(x,y)pdf(obj,mapstd('apply',[x y]',ps)'),[-700, 0,0 700], 'LevelList', [cluster2], 'LineColor', 'k')
% hold off
% saveas(h,strcat('clusterKDengue_',num2str(1)),'png')
% savefig(strcat('clusterRDengue_',num2str(1)))
% 
% 
% figure;
% [h]=ezcontour(@(x,y)pdf(obj,mapstd('apply',[x y]',ps)'),[0 -700],[0 700],100);
% hold on
% [h] = fcontour(@(x,y)pdf(obj,mapstd('apply',[x y]',ps)'),[-509, -389,550, 700], 'LevelList', [cluster], 'LineColor', 'r');
% [h] = fcontour(@(x,y)pdf(obj,mapstd('apply',[x y]',ps)'),[-445, -290,7, 148], 'LevelList', [cluster2], 'LineColor', 'k')
% hold off
% saveas(h,strcat('clustersLevelDengue_',num2str(1)),'png')
% savefig(strcat('clustersLevelDengue_',num2str(1)))