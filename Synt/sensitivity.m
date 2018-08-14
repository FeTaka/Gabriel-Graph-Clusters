function sensitivity_val = sensitivity(dataR, dataE)
    sensitivity_val = sum(dataR==1 & dataE==1)/sum(dataR==1);
end