function dataR = realPoints(data, mu, sigma)
    dataR = diag((data - repmat(mu,size(data,1),1))*(data - repmat(mu,size(data,1),1))')  <= sigma(1,1)^2;
end