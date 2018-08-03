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
function connected_graph = detect_connected_graph (mask, peak)