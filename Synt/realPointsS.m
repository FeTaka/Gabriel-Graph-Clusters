function dataR = realPointsS(data, par)
    dataR = (data(:,1)>=par(1,1)) & (data(:,1)<=par(1,2)) & (data(:,2)>=par(2,1)) & (data(:,2)<=par(2,2));
end