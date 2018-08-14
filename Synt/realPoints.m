function dataR = realPoints(data, mu, sigma)
    dataR = diag((data - mu)*(data - mu)')  <= sigma(1,1)^2;
end