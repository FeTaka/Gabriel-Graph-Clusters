function ppv_val = ppv(dataR, dataE)
    ppv_val = sum(dataR==1 & dataE==1)/sum(dataE==1);
end