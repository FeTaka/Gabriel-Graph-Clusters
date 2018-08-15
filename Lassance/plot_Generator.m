%% This program is free software;
%% File for Plotting the level curves and clusters 
%% 
%% -*- texinfo -*-
%%

%% Load Varaibles
load('PDF_function.mat')
load('ZMatrix')
load('clusterData.mat')

%% Create a Color Vector
colorvec = [[1 0 0]; [1 .5 0]; [1 1 0]];

%% Plot Level Curves and Points
figure;
[h]=ezcontour(@(x,y)pdf(obj,mapstd('apply',[x y]',ps)'),[0 -700],...
    [0 700],100);
hold on

    %[h] = fcontour(@(x,y)pdf(obj,mapstd('apply',[x y]',ps)'),...
    %[xmin, xmax, ymin, ymax], 'LevelList', [threshold(1)],... 
    %'LineColor','r');
    
plot(Ox(clusters2==0, 1), Ox(clusters2==0, 2), '.k')
plot(Ox(clusters2==1, 1), Ox(clusters2==1, 2), '.', 'color', colorvec(1,:))
plot(Ox(clusters2==2, 1), Ox(clusters2==2, 2), '.', 'color', colorvec(2,:))
plot(Ox(clusters2==3, 1), Ox(clusters2==3, 2), '.', 'color', colorvec(3,:))

%% Plot Clusters Borders
step = 1;
U = unique(clusters);
U(1) = [];
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
contour(-700:step:0, 0:step:700, (Z.*M)', [threshold(i), threshold(i)], 'lineWidth', 3, 'color', colorvec(l,:))
%[h] = ezcontour(@(x,y)pdf(obj,mapstd('apply',[x y]',ps)'),[xmin, xmax, ymin, ymax]);
end
hold off

%% SAve Images
saveas(h,'clusterDengue_data.eps','epsc')
savefig('clusterDengue_data')