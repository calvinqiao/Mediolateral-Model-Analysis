function com_length = get_com_length(folderpath, static_trial_num)
% GET_COM_LENGTH  Calculates distance between center of mass to swing center.
%   COM_LENGTH = GET_COM_LENGTH(FOLDERPATH, STATIC_TRIAL_NUM) gets center of
%   mass data and calculate its distance to the swing center to the ground for
%   a subject (FOLDERPATH) from its quiet standing trial STATIC_TRIAL_NUM.
%
%   See also GET_DOUBLE_COM, GET_COM_Z.

    addpath('../calculate_com/double_integration_com');

    % get CoM_x
    com_x = get_double_com(folderpath, static_trial_num);

    com_z = get_com_z(folderpath, static_trial_num);

    com_length = mean(sqrt(com_x .^ 2 + com_z .^ 2), 'omitnan');
end

function com_z = get_com_z(folderpath, static_trial_num)
% GET_COM_Z  Gets center of mass in z direction
%   COM_Z = GET_COM_Z(FOLDERPATH, STATIC_TRIAL_NUM) gets a subject's
%   (FOLDERPATH) center of mass in z direction from its quiet staning trial
%   with STATIC_TRIAL_NUM.
%
%   See also IMPORTFILE, HJCESTIMATION.

    % load data
    filepath = strcat(folderpath, 'Trial', num2str(static_trial_num), '.csv');
    Trial = importfile(filepath);

    % calculate com_z for each body part
    % Pelvis
    [hjc_left, hjc_right, total_com_pelvis] = HJCEstimation(Trial);
    com_pelvis = total_com_pelvis(:, 3);
    % Trunk
    com_trunk = mean([Trial.VarName23, (hjc_left(:, 3) + hjc_right(:, 3)) / 2], 2);
    % Shank
    com_shanks = (Trial.VarName113 * 0.433 + Trial.VarName98 * 0.567) + (Trial.VarName74 * 0.433 + Trial.VarName59 * 0.567);
    % Thigh
    com_thighs = (Trial.VarName98 * 0.433 + hjc_left(:, 3) * 0.567) + (Trial.VarName59 * 0.433 + hjc_right(:, 3) * 0.567);
    % Feet
    com_feet = Trial.VarName113 + Trial.VarName74;
    % Head
    com_head = mean([Trial.VarName14 Trial.VarName8], 2);

    com_z = [0.142 * com_pelvis, 0.455 * com_trunk, 0.0465 * com_shanks ...
            0.10 * com_thighs, 0.0145 * com_feet, 0.081 * com_head];
    com_z = sum(com_z, 2);

    com_z = com_z - com_feet;
end
