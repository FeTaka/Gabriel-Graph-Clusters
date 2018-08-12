function [borda,d,Gg] =Grafo_Gabriel(X,D) 


dt = delaunayTriangulation(X);

E = dt.edges; % Arestas de Delaunay.
d=dist(X'); %calculando matriz de distância.

Gg = zeros(size(X,1));

for i=1:size(E,1)
    v1=E(i,1); % v1 da aresta 1
    v2=E(i,2); % v2 da aresta 2    
    
    t= edgeAttachments(dt,v1,v2); 
     
    a1= v1~=dt(t{:},:);
    a2=v2~=dt(t{:},:);
    a1a2 = (a1.*a2);
    aux=dt(t{:},:);
    z=aux(a1a2==1); % vertices para serem comparados
    
    % Verificando se vai haver aresta entre v1 e v2.
    v1v2=d(v1,v2).^2 <= (d(v1,z).^2) + (d(v2,z).^2);
    
    if (sum(v1v2) == length(v1v2))
        Gg(v1,v2)=1;
        Gg(v2,v1)=1;
    end
end

borda = grafoBorda(Gg,D');
end
