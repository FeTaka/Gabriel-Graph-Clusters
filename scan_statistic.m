function cluster = scan_statistic(O, X, D, polyX, polyY)
    cluster = 'NULL';
    C = sum(D==1);%total cases
    %Level curves to separate the regions
    oLR = -Inf;
    [in,on] = inpolygon(X(:,1),X(:,2),polyX,polyY);
    Z = in | on;
    l = linspace(min(O(Z)),max(O(Z)), 21);
    for i = 1:20
        level = l(i);
        Sz = sum(Z& O>=level);
        %disp(Sz)
        Cz = sum(Z&(D==1)& O>=level);
        %disp(Cz)
        Mz = Sz*(Cz/length(C));
        Iz = Cz/Mz;
        Oz = (C-Cz)/(C - Mz);
        LR = log( (Iz)^Cz * (Oz)^(C-Cz));
        if LR > oLR
            oLR = LR;
            cluster = level;
            disp(i)
        end
    end
    
    
    
