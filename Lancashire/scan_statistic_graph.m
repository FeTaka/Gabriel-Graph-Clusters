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
function scan_statistic_val = scan_statistic_graph (connected_graph, D)

C = sum(D==1);%total cases
N = length(D);
Nz = sum(connected_graph);%population in zone
Cz = sum(D(connected_graph)==1); %cases in zone
scan_statistic_val = 0;
Iz = Cz/Nz; 
Oz = (C - Cz)/(N - Nz);
if Iz > Oz
    scan_statistic_val = Cz*log(Iz) + Cz*log(1/Oz) + (C - Cz)*log(Oz) + (C - Cz)*log(N/C);
end

%scan_statistic_val = log( (Iz)^Cz * (Oz)^(C-Cz));