%% This program is free software;
%% Main File of the First and Second Parts of the Paper
%% Implementation of the PDF according to Gabriel Graphs Method
%%
%% -*- texinfo -*-
%%

%% Load Data
[Ix, Iy] = dataRead(0);
D=Iy;
D(D==0)=-1;
Ix(:,1)=-Ix(:,1);
Ox=Ix;

%% Data treatment
[Ix, ps]=mapstd(Ix'); %normalizando media 0 desvio padrao 1.
[X, m, n]=unique(Ix','rows','last'); % retirando amostras repetidas.
D=D(m);
Ox=Ox(m,:);

%% Delaunay Triagulation
dt = delaunayTriangulation(X);

%% Gabriel Graph PDF
[obj, Gg] = gg_probability_func (X, D, 0.1);
fprintf('\n');

%% Plotting Gabriel Graph
%%% Create Graph from adjacency matrix
gg_graph = graph(sparse(Gg)); 
%%% Generate Figure
figure;
h=plot(gg_graph, 'xData', Ox(:,1), 'yData', Ox(:,2));
hold on
plot(Ox(D==-1, 1), Ox(D==-1, 2), '.k')
plot(Ox(D==1, 1), Ox(D==1, 2), '.r','MarkerSize',10)
hold off
%%% Save Figure
saveas(h,'ggDengue.eps','epsc')
savefig('ggDengue')

%% Save Variables
save('PDF_function.mat', 'obj', 'Gg', 'Ox', 'X', 'D', 'ps')




