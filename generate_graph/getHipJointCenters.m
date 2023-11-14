function [hjc_left, hjc_right] = getHipJointCenters(mid_asis, mid_psis, rasis, measures)
% GETHIPJOINTCENTERS  Calculates hip joint centers.
%   [HJC_LEFT, HJC_RIGHT] = GETHIPJOINTCENTERS(MID_ASIS, MID_PSIS, RASIS,
%   MEASURES) calculates the subject's left hip joint centers (HJC) and right
%   HJC.

    hjc_left = zeros(length(mid_asis), 3); hjc_right = zeros(length(mid_asis), 3);
    for i = 1:length(mid_asis)
            this_asis_right = rasis(i, :);
            this_asis_mid = mid_asis(i, :);
            this_psis_mid = mid_psis(i, :);
            x = this_asis_right - this_asis_mid;
            y = this_asis_mid - this_psis_mid;
            z = cross(x,y); 
            x = x/norm(x); y = y/norm(y); z = z/norm(z);

            thisT = frame(x, y, z, this_asis_mid);
            this_hjc_left = [-measures.xhat, measures.yhat, measures.zhat];
            this_hjc_right = [measures.xhat, measures.yhat, measures.zhat];
            this_hjc_left = [this_hjc_left, 1];
            this_hjc_left = (thisT*this_hjc_left')';
            this_hjc_left(:, 4) = [];
            this_hjc_right = [this_hjc_right, 1];
            this_hjc_right = (thisT*this_hjc_right')';
            this_hjc_right(:, 4) = [];

            hjc_left(i, :) = this_hjc_left;
            hjc_right(i, :) = this_hjc_right;
    end

end

