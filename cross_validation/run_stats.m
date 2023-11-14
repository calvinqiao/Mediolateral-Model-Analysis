function [pvalues] = run_stats(slopes_subjects)
    NCOND = 7;
    pvalues = zeros(NCOND, 1);
    for iCond = 1:NCOND
        slopes = slopes_subjects(:, iCond);
        pvalue = run_stats_for_cond(slopes);
        pvalues(iCond) = pvalue;
    end

end

function [pvalue] = run_stats_for_cond(slopes)
    NSAMPLE = 10000;
    sampled = bootstrp(NSAMPLE,@median,slopes);
    measured = mean(slopes);
    if 0 > measured
        pvalue = sum(sampled > 0)/NSAMPLE;
    else
        pvalue = sum(sampled < 0)/NSAMPLE;
    end
    
end

% [fi,xi] = ksdensity(sampled);
% plot(xi,fi)