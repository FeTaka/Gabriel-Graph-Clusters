load('plotData.mat')
colorvec = [[1 0 0]; [1 .5 0]; [1 1 0]];

zfun = @(x,y)pdf(obj,mapstd('apply',[x y]',ps)');
[p,q] = meshgrid(-700:1:0, 0:1:700);
Z = zeros(71,71);
step = 5;
for i=0:step:700
    for j=0:step:700
        Z(i/step+1,j/step+1) = zfun(-700+i,j);
    end
end
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
xmin = round((xmin+700)/step);
ymin = min(Ox(clusters==U(i),2));
ymin = ymin - 10;
ymin = round(ymin/step);
xmax = max(Ox(clusters==U(i),1));
xmax = xmax + 10;
xmax = round((xmax+700)/step);
ymax = max(Ox(clusters==U(i),2));
ymax = ymax + 10;
ymax = round(ymax/step);
M = ones(size(Z));
M(1:xmin, :) = 0;
M(xmax:end, :) = 0;
M(:, 1:ymin) = 0;
M(:, ymax:end) = 0;
l = clas_cluster(U(i));
contour(-700:10:0, 0:10:700, (Z.*M)', threshold(i), 'lineWidth', 3, 'color', colorvec(l,:))
%[h] = ezcontour(@(x,y)pdf(obj,mapstd('apply',[x y]',ps)'),[xmin, xmax, ymin, ymax]);
end
hold off

saveas(h,'clusterDengue_data.eps','epsc')
savefig('clusterDengue_data')
save(data, obj, ps, Ox, clusters2, clusters)