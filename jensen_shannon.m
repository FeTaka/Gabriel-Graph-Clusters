function d_js = jensen_shannon(P, Q)
p1 = P.*log(2*P./(P+Q));
p1(isnan(p1)) = 1;
p2 = Q.*log(2*Q./(P+Q));
p2(isnan(p2)) = 1;
d_js = 0.5*(sum(p1)+sum(p2));
end