
%------------------------------------------------------------------
% Algoritmo para encontrar a borda entre duas classes de um grafo.
%------------------------------------------------------------------



% E = matriz de adjacencia do grafo.
% borda = vertices da borda do grafo.
% D = Label das amostras.

function [borda] = grafoBorda(E,D)

E = E + diag(ones(size(E,1),1));
mask=repmat(D,size(D,2),1);
result=mask.*E;
result = abs(sum(result,2));
E=abs(sum(E,2));
borda = (result~=E);

end