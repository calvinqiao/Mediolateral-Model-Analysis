function [slopes] = trunk_pelvis_angle_stats(folders, effec_trials)

    addpath('../calculate_com/kinematic_method_com/');
    addpath('../calculate_attributes/');
    addpath('../theta_relative_regression/');
    addpath('../theta_z_regression/');
    addpath('../calculate_com/double_integration_com/');

    slopes = zeros(length(folders), 7, "double");

    for iFolder = 1:length(folders)
        folderpath = folders{iFolder};
        effec_trials_subject = effec_trials(iFolder,:);
        l = length(effec_trials_subject);
        slopes_subject = zeros(l, 1);

        for iTrial = 1:l
            disp(['Subject',num2str(iFolder),'Trial', num2str(iTrial)]);
            trial_num = effec_trials_subject(iTrial);
            trial_path = strcat(folderpath, 'Trial', ...
                            num2str(trial_num), '.csv');
            [slopes, ~, ~] = slope_from_trial(trial_path, trial_num);

            slopes_subject(iTrial, 1) = slopes.trunk_angle_rel;
        end
        % error.shoulder = meanOfTwoRows(error.shoulder);
        % slopes.shoulder(iFolder, :) = error.shoulder;
    end

end