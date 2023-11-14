function attributes = real_attributes(markers)
% REAL_ATTRIBUTES  Gets real attributes from markers data of a single trial.
%   ATTRIBUTES = REAL_ATTRIBUTES(MARKERS) gets trunk-to-z angle (theta_t), left
%   leg to ground angle, pelvis angle, and shoulder move and pelvis move in x 
%   direction and output as a structure array.
%
%   See also HJCESTIMATION 

    addpath('../calculate_com/kinematic_method_com');

    attributes = struct();
    [hjc_left, hjc_right, ~] = HJCEstimation(markers);
    
    attributes.l_psisx = markers.LPSIS; attributes.l_psisz = markers.VarName38;
	attributes.r_psisx = markers.RPSIS; attributes.r_psisz = markers.VarName32;
	attributes.l_asisx = markers.LASIS; attributes.l_asisz = markers.VarName44;
	attributes.r_asisx = markers.RASIS; attributes.r_asisz = markers.VarName41;
    attributes.l_hjcx = hjc_left(:,1); attributes.l_hjcz = hjc_left(:,3);
	attributes.r_hjcx = hjc_right(:,1); attributes.r_hjcz = hjc_right(:,3);

    % pelvis position
    attributes.pelvis_x = (hjc_left(:, 1) + hjc_right(:, 1)) / 2;
    % shoulder position
    attributes.shoulder_x = markers.Manub;
    % pelvis angle: theta_p
    hjc_vec = hjc_right - hjc_left;
    attributes.pelvis_angle = -atand(hjc_vec(:,3)./hjc_vec(:,1));
    % calculate trunk to pelvis angle
    trunk_vec = [attributes.shoulder_x, markers.VarName22, markers.VarName23] ...
                - (hjc_left + hjc_right) / 2;
    attributes.theta_rel = zeros(size(trunk_vec, 1), 1);
    for i = 1:size(trunk_vec, 1)
        % extract x,z components of each vector
        u = trunk_vec(i, :)';
        v = hjc_vec(i, :)';
        
        % compute angle between x,z components of vectors
        cos_theta = dot(u, v) / (norm(u) * norm(v));
        if cos_theta > 1
            cos_theta = 1;
        elseif cos_theta < -1
            cos_theta = -1;
        end
        theta = acosd(cos_theta);
        
        % store angle in array
        attributes.trunk_angle_rel(i) = theta;
    end
    attributes.trunk_angle_rel = attributes.trunk_angle_rel - mean(attributes.trunk_angle_rel);
    attributes.trunk_angle_rel = attributes.trunk_angle_rel';
    % theta_t
    % attributes.theta_t = 90 - (attributes.vertical_angles - attributes.pelvis_angle);
    attributes.trunk_angle_abs = atand(trunk_vec(:, 1) ./ trunk_vec(:, 3));
    attributes.trunk_angle_abs = attributes.trunk_angle_abs - mean(attributes.trunk_angle_abs);
    % leg angle
    left_heel = [markers.LHeel, markers.VarName115, markers.VarName116];
    l_leg_vec = left_heel - hjc_left;
    attributes.left_leg_angle = atand(l_leg_vec(:, 1) ./ l_leg_vec(:, 3));
    attributes.left_leg_angle = attributes.left_leg_angle - mean(attributes.left_leg_angle);
    % regularize values
    attributes.shoulder_x = attributes.shoulder_x - mean(attributes.shoulder_x);
    attributes.pelvis_angle = attributes.pelvis_angle - mean(attributes.pelvis_angle);
    attributes.pelvis_x = attributes.pelvis_x - mean(attributes.pelvis_x);
end
