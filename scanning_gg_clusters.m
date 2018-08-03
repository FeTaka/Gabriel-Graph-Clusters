%% This program is free software;
%% It consists of the third final step of the work discribed in...
%% Steps 1 and 2 are mde in function gg_probability_func
%% -*- texinfo -*-
%% @deftypefn {Function File} {@var{rsk_func} =} scanning_gg_clusters (@var{rsk_func})
%% Create an array containg the risk level and square delimiting the zone of
%% each detected cluster
%%
%% Input @var{rsk_func} an object of the gmdistribution class which represents the contagium risk
%% of a syndrome in a region
%% @end deftypefn
%%
function cluster_zones = scanning_gg_clusters (rsk_func, X, D, GG)

Z = pdf(rsk_func,X); %risk estimates

%% Find peaks
neighbours = bsxfun(@times,GG,Z');
is_greater = all(bsxfun(@lt,neighbours,Z));
peaksX = X(is_greater);
peaksZ = Z(is_greater);
peaksI = find(is_greater);

dt = delaunayTriangulation(X);
E = dt.edges; % Arestas de Delaunay.
%A = full(sparse([E(:,1);E(:,2)],[E(:,2);E(:,1)],1));
A = sparse([E(:,1)],[E(:,2)],1);

[I,J,~] = find(A);
med_pts = (X(I,:)+X(J,:))./2;
%pdf_med = zeros(length(Z));
%pdf_med(sub2ind(I,J)) = pdf(rsk_func,med_pts);
pdf_med = zeros(nnz(A),1);
pdf_med = pdf(rsk_func,med_pts);

AP = sparse([E(:,1);E(:,2)],[E(:,2);E(:,1)],[pdf_med;pdf_med]);

threshold = peaksZ(1)*0.9;
peak =  peaks(1);


%% Create mask above threshold
 mask = threshold_mask (AP, Z, threshold);
 
 bins = conncomp(graph(mask));
%% Detect connnected
% connected_graph = detect_connected_graph (mask, peak)
%% Calculate scan
% scan_statistic_val = scan_statistic_graph (connected_graph)

%cluster = scan_statistic(O, Ox, D, polyX, polyY);


cluster_zones = 0;