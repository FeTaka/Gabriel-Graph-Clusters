

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

[obj, gg] = gg_probability_func (X, D, 10);


figure;
hold on
[h]=ezcontour(@(x,y)pdf(obj,mapstd('apply',[x y]',ps)'),[0 -700],[0 700],100);
%clabel([], h);
title('')
plot(Ox(D==1,1),Ox(D==1,2),'MarkerFaceColor',[1 0 0],'MarkerSize',3,'Marker','o','LineStyle','none','Color',[1 0 0]);
set(gca, 'Visible', 'off')
set(gca, 'color', 'none');
set(gcf, 'color', 'none');
[h]=ezcontour(@(x,y)pdf(obj, [x, y]),[0 -700],[0 800],1000);
alpha(0.8); 
saveas(h,'testes','png')

C = scanning_gg_clusters (obj, X, D, gg);
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