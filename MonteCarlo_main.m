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
%[pX, pYd] = runGrid(0.25, 0.50, Ix', Iy);

[obj, Gg] = gg_probability_func (X, D, 10);

%% Null hypothesis test
N = 5;
llrN = monte_carlo_llr_nh(X, D, N);
[mllr, illr] = max(llr);

