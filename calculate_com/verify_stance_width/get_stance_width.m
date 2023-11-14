function width = get_stance_width(folder, trial_num)
% GET_STANCE_WIDTH  Calculates real stance width.
%   WIDTH = GET_STANCE_WIDTH(FOLDER, TRIAL_NUM) Get real stance width
%   percentage from specified subject (FOLDER) with its TRIAL_NUM.
% 
%   See also IMPORTFILE, GET_HJC_DISTANCE.

    addpath('../kinematic_method_com/');
    first_file = strcat(folder, 'Trial', num2str(2), '.trc');
    first_trial = import_file_first(first_file);
    r_ankle_medial = first_trial.RAnkleMedial;
    r_ankle_lateral = first_trial.RAnkle;
    l_ankle_medial = first_trial.LAnkleMedial;
    l_ankle_lateral = first_trial.LAnkle;
    l_offset = nanmean(abs(l_ankle_lateral-l_ankle_medial))/2;
    r_offset = nanmean(abs(r_ankle_lateral-r_ankle_medial))/2;

    csv_file = strcat(folder, 'Trial', num2str(trial_num), '.csv');
    trial = importfile(csv_file);
    % static_trial = importfile(strcat(folder, 'Trial', num2str(static_trial_num), '.csv'));
    hjc_distance = get_hjc_distance(trial);

    l_ankle_x = trial.LAnkle; r_ankle_x = trial.RAnkle;
    % ankle_distance = abs(mean(l_heel_x - r_heel_x, 'omitnan'));
    ankle_distance = abs((l_ankle_x - r_ankle_x)) - l_offset - r_offset;

    width = ankle_distance / hjc_distance;
end
