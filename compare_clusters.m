function [llrO, llrE] = compare_clusters (obj,OX, Do)
%creating sick and sane inputs with input model
[X, px]= mapstd(OX');
X = X';
F = pdf(obj,X);
[F, ps]=mapminmax(F', 0, 1);
D = -1*ones(size(F));
R = rand(size(F));
D(R < F) = 1;

Ur = unique(OX(:,1));
Uc = unique(OX(:,2));
nr = length(Ur);
nc = length(Uc);
dtr = (Ur(2)-Ur(1))/4;
dtc = (Uc(2)-Uc(1))/4;
dr = Ur(10)-Ur(1)+2*dtr;
dc = Uc(10)-Uc(1)+2*dtc;

%figure;
%scatter(OX(:,1), OX(:,2), '.k')
hold on
llrO = zeros(10);
llrE = zeros(10);
for i=1:10:nr
    for j=1:10:nc
        x = Ur(i)-dtr;
        y = Uc(j)-dtc;
        polyX = [x, x+dr, x+dr, x, x];
        polyY = [y, y, y+dc, y+dc, y];
        [in,on] = inpolygon(OX(:,1),OX(:,2),polyX,polyY);
        Z = Do(:,in|on);
        %scatter(OX(in | on,1), OX(in | on,2), 'xr')
        llrO(ceil(i/10),ceil(j/10)) = sum(Z==1);%llr(Z, Do);
        %llrO(ceil(i/10),ceil(j/10)) = length(Z);
        Z = D(in|on);
        llrE(ceil(i/10),ceil(j/10)) = sum(Z==1);%llr(Z, D);
        %plot(polyX,polyY)
    end
end

hold off

