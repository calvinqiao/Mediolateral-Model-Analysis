function CoMx = KinematicMethod(folderpath, trial_num)
% KINEMATICMETHOD  Calculates center of mass in x direction.
%   COMX = KINEMATICMETHOD(FOLDERPATH, TRIAL_NUM) calculates center of mass in
%   x direction for one subject of one trial given data's FOLDERPATH for a
%   specific TRIAL_NUM using kinematic method.
%
%   See also HJCESTIMATION.

    % load data
    filepath = strcat(folderpath, 'Trial', num2str(trial_num), '.csv');
    Trial = importfile(filepath);

    % calculate com_x for each body part
    % Pelvis
    [hjc_left, hjc_right, total_com_pelvis] = HJCEstimation(Trial);
    com_pelvis = total_com_pelvis(:, 1);
    % Trunk
    com_trunk = mean([Trial.Manub (hjc_left(:, 1) + hjc_right(:, 1)) / 2], 2);
    % Shank
    com_shanks = (Trial.LAnkle * 0.433 + Trial.LKnee * 0.567) + (Trial.RAnkle * 0.433 + Trial.RKnee * 0.567);
    % Thigh
    com_thighs = (Trial.LKnee * 0.433 + hjc_left(:, 1) * 0.567) + (Trial.RKnee * 0.433 + hjc_right(:, 1) * 0.567);
    % Feet
    com_feet = Trial.LAnkle + Trial.RAnkle;
    % Head
    com_head = mean([Trial.LInfOrb Trial.RInfOrb], 2);

    CoMx = [0.142 * com_pelvis, 0.455 * com_trunk, 0.0465 * com_shanks ...
            0.10 * com_thighs, 0.0145 * com_feet, 0.081 * com_head];
    CoMx = sum(CoMx, 2);

    CoMx = CoMx - mean(CoMx);
end
