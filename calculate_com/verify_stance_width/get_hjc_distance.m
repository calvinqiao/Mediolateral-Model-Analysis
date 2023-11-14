function HJC_distance = get_hjc_distance(markers)
% GET_HJC_DISTANCE  Gets distance between hip joint centers.
%   HJC_DISTANCE = GET_HJC_DISTANCE(MARKERS) uses MARKERS data to calculate
%   distance left and right hip join center with projection on x-y plane.

    lasis_x = markers.LASIS; lasis_y = markers.VarName43; lasis_z = markers.VarName44;
    lasis = [lasis_x lasis_y lasis_z];
    rasis_x = markers.RASIS; rasis_y = markers.VarName40; rasis_z = markers.VarName41;
    rasis = [rasis_x rasis_y rasis_z];
    lpsis_x = markers.LPSIS; lpsis_y = markers.VarName37; lpsis_z = markers.VarName38;
    lpsis = [lpsis_x lpsis_y lpsis_z];

    pelvis_depth = mean(sqrt(sum((lasis(:, 2) - lpsis(:, 2)).^2, 2)), 'omitnan');
    pelvis_width = mean(sqrt(sum((lasis(:, 1) - rasis(:, 1)).^2, 2)), 'omitnan');
    xhat = 0.28 * pelvis_depth + 0.16 * pelvis_width + 7.9;
    HJC_distance = xhat * 2;
end
