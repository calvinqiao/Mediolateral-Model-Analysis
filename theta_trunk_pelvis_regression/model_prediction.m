function [predicted_old, predicted_new] = model_prediction(folderpath, static_trial, ...
                                                           trial_num, f)
% MODEL_PREDICTION  Predicts the subject's movements.
%   [PREDICTED_OLD, PREDICTED_NEW] = MODEL_PREDICTION(FOLDERPATH, STATIC_TRIAL,
%   TRIAL_NUM, F) predicts subject's (FOLDERPATH) of a specific TRIAL_NUM by
%   its STATIC_TRIAL and regression function F.
% 
%   See also IMPORTFILE, INITPREDICTION, GET_PREDICTION.

    % imports
    addpath('../calculate_com/kinematic_method_com/');
    addpath('../calculate_com/double_integration_com');

    % get markers in static movement
    csv_file = strcat(folderpath, 'Trial', num2str(trial_num), '.csv');

    % static motion data
    static_csv = strcat(folderpath, 'Trial', num2str(static_trial), '.csv');
    markers = importfile(static_csv);

    % Get measures from quiet standing markers data
    measures = struct();
    measures.mass = get_mass(folderpath, static_trial);
    lasis_x = markers.LASIS; lasis_y = markers.VarName43; lasis_z = markers.VarName44;
    lasis = [lasis_x lasis_y lasis_z];
    rasis_x = markers.RASIS; rasis_y = markers.VarName40; rasis_z = markers.VarName41;
    rasis = [rasis_x rasis_y rasis_z];
    lpsis_x = markers.LPSIS; lpsis_y = markers.VarName37; lpsis_z = markers.VarName38;
    lpsis = [lpsis_x lpsis_y lpsis_z];
    manub_x = markers.Manub; manub_y = markers.VarName22; manub_z = markers.VarName23;
    manub = [manub_x manub_y manub_z];
    lank_x = markers.LAnkle; lank_y = markers.VarName112; lank_z = markers.VarName113;
    lank = [lank_x lank_y lank_z];

    measures.pelvis_depth = mean(sqrt(sum((lasis(:, 2) - lpsis(:, 2)).^2, 2)), 'omitnan');
    measures.pelvis_width = mean(sqrt(sum((lasis(:, 1) - rasis(:, 1)).^2, 2)), 'omitnan');
    measures.leg_len = mean(sqrt(sum((lasis(:, [1, 3]) - lank(:, [1, 3])).^2, 2)), 'omitnan');
    measures.yhat = -0.24 * measures.pelvis_depth - 9.9;
    measures.zhat = -0.16 * measures.pelvis_width - 0.04 * measures.leg_len - 7.1;
    measures.xhat = 0.28 * measures.pelvis_depth + 0.16 * measures.pelvis_width + 7.9;
    measures.HJC_distance = measures.xhat * 2;
    [lhjc, ~, ~] = HJCEstimation(markers);

    measures.leg_len = mean(sqrt(sum((lhjc(:, [1,3]) - lank(:, [1,3])).^2, 2)), 'omitnan');
    measures.trunk_len = mean(sqrt(sum((lhjc(:, [1,3]) - manub(:, [1,3])).^2, 2)), 'omitnan');
    measures.leg_CoM = 0.567 * measures.leg_len;
    measures.pelvis_CoM = 0.105 * measures.HJC_distance;
    measures.trunk_CoM = 0.626 * measures.trunk_len;

    measures.leg_mass = measures.mass * (0.161 - 0.0145); measures.leg_CoM_ratio = 0.567;
    measures.pelvis_mass = measures.mass * 0.142; measures.pelvis_CoM_ratio = 0.105;
    measures.trunk_mass = measures.mass * (0.678 - 0.142); measures.trunk_CoM_ratio = 0.626;

    % get com_length
    measures.com_length = get_com_length(folderpath, static_trial);

    % get data from trial we want to predict
    clear markers;
    markers = importfile(csv_file);

    % pelvis_ang = -atand(hjc_vec(:, 3) ./ hjc_vec(:, 1));

    CoM_x = get_double_com(folderpath, trial_num);

    % Calculate Ankle distance
    stance_width = get_stance_width(folderpath, trial_num);
    getZeroCrossings = @(var) find(var(:).*circshift(var(:), [-1, 0]) <= 0);
    zeroCrosses = getZeroCrossings(CoM_x);
    ankle_distance = nanmean(stance_width(zeroCrosses));

    % Prediction
    [measures.A, measures.B, measures.pend_mass] = initPrediction(measures, ankle_distance);

    [predicted_old, predicted_new] = get_prediction(measures, CoM_x, ankle_distance, f);
end
