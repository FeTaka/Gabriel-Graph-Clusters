function specificity_val = specificity(dataR, dataE)
    specificity_val = sum(dataR==0 & dataE==0)/sum(dataR==0);
end