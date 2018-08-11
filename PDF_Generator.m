%% This program is free software;
%% Main File of the First Part of the Paper
%% Implementation of the PDF according to Gabriel Graphs Method
%% -*- texinfo -*-
%%

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

[obj, Gg] = gg_probability_func (X, D, 0.1);

fprintf('\n');

gg_graph = graph(sparse(Gg));
figure;
h=plot(gg_graph, 'xData', Ox(:,1), 'yData', Ox(:,2));
hold on
plot(Ox(D==-1, 1), Ox(D==-1, 2), '.k')
plot(Ox(D==1, 1), Ox(D==1, 2), '.r','MarkerSize',10)
hold off
saveas(h,'ggDengue.eps','epsc')
savefig('ggDengue')

save('PDF_function.mat', 'obj', 'Gg', 'Ox', 'X', 'D', 'ps')




