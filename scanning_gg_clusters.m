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
function [cluster_bin, saved_threshold, llr] = scanning_gg_clusters (rsk_func, X, D, GG)

Z = pdf(rsk_func,X); %risk estimates

minZ = min(Z);

%% Find peaks
neighbours = bsxfun(@times,GG,Z');
is_greater = all((Z>neighbours),2)';
peaksZ = Z(is_greater);
peaksI = find(is_greater);

dt = delaunayTriangulation(X);
E = dt.edges; % Arestas de Delaunay.
%A = full(sparse([E(:,1);E(:,2)],[E(:,2);E(:,1)],1));
A = sparse(E(:,1),E(:,2),1);

[I,J,~] = find(A);
med_pts = (X(I,:)+X(J,:))/2;

%pdf_med = zeros(length(Z));
%pdf_med(sub2ind(I,J)) = pdf(rsk_func,med_pts);
%pdf_med = zeros(nnz(A),1);

pdf_med = pdf(rsk_func,med_pts);
AP = sparse([I;J],[J;I],[pdf_med;pdf_med]);
[~,I] = sort(peaksZ, 'descend');

saved_threshold = zeros(size(peaksZ));
llr = zeros(size(peaksZ));
valid = is_greater;
cluster_bin = zeros(size(is_greater));
cluster = 1;
for l=1:length(I)
    id = I(l);
    peak =  peaksI(id);
    if valid(peak)
        threshold = peaksZ(id);
        step = threshold*0.1;
    %% Create mask above threshold
        mask = threshold_mask (AP, Z, threshold);
        mask(cluster_bin~=0, :) = 0;
        mask(:, cluster_bin~=0) = 0;
        %% Detect connnected
        connected_graph = detect_connected_graph (mask, peak);
        %% Calculate scan
         scan_statistic_val = scan_statistic_graph (connected_graph, D);
         llr(l) = scan_statistic_val;
        while (threshold > minZ)
            %% Save greater llr
            if scan_statistic_val > llr(l)
                cur_graph = connected_graph;
                saved_threshold(l)= threshold;
                llr(l) = scan_statistic_val;
            end
            threshold = threshold - step;
            %% Create mask above threshold
            mask = threshold_mask (AP, Z, threshold);
            mask(cluster_bin~=0, :) = 0;
            mask(:, cluster_bin~=0) = 0;
            %% Detect connnected
            connected_graph = detect_connected_graph (mask, peak);
            %% Calculate scan
            scan_statistic_val = scan_statistic_graph (connected_graph, D);
        end
        if saved_threshold(l)
            used = (is_greater & cur_graph);
            cluster_bin(cur_graph & cluster_bin==0) = cluster;
            valid = (valid & ~used);
            cluster = cluster + 1;
        end  
    end  
end
llr(saved_threshold==0) = [];
saved_threshold(saved_threshold==0) = [];
