function errors = test(model, folders, static_trials, effec_trials)
    % Initialize the errors structure to store results for each folder
    num_folders = length(folders);
    l = floor(size(effec_trials, 2) / 2);
    errors = struct();
    errors.shoulder = zeros(l, 1);
    errors.pelvis = zeros(l, 1);

    for i = 1:num_folders
        error = test_single_folders(model, folders{i}, static_trials(i), effec_trials(i, :));
        errors.shoulder = errors.shoulder + error.shoulder;
        errors.pelvis = errors.pelvis + error.pelvis;
    end

    errors.shoulder = errors.shoulder / num_folders;
    errors.pelvis = errors.pelvis / num_folders;
end



function error = test_single_folders(model, folder, static_trial, effec_trials)
% TEST  Gets error from a specified subject.
%   ERROR = TEST(MODEL, FOLDER, STATIC_TRIAL, EFFEC_TRIALS) Gets error from a
%   subject (FOLDER) by testing all its EFFEC_TRIALS.
% 
%   See also GET_ERROR.

    addpath('../calculate_com/kinematic_method_com/');
    addpath('../calculate_attributes/');
    addpath('../theta_relative_regression/');
    addpath('../theta_z_regression/');
    addpath('../calculate_com/double_integration_com/');

    l = length(effec_trials);

    error = struct();
    error.shoulder = zeros(l, 1);
    error.pelvis = zeros(l, 1);

    com_length = get_com_length(folder, static_trial);
    
    for i = 1:l
        trial_num = effec_trials(i);
        markers = importfile(strcat(folder, 'Trial', ...
                        num2str(trial_num), '.csv'));
        real = real_attributes(markers);
        [~, prediction] = theta_relative_regression(folder, static_trial, ...
                                trial_num, model.eq);
        % get com for calculating errors
        theta_com = get_double_com(folder, trial_num) / com_length;
        % get error
        [error.shoulder(i), error.pelvis(i)] = get_error(theta_com, ...
                        real.shoulder_x, real.pelvis_x, ...
                        prediction.x_shoulder_mid, prediction.x_pelvis_mid, ...
                        trial_num, folder);
    end

    error.shoulder = meanOfTwoRows(error.shoulder);
    error.pelvis = meanOfTwoRows(error.pelvis);
end

function [error_shoulder, error_pelvis] = get_error(theta_com, real_shoulder, real_pelvis, ...
                    predict_shoulder, predict_pelvis, trial_num, folderpath)
% GET_ERROR  calculates error based on prediction and real data.
%   [ERROR_SHOULDER, ERROR_PELVIS] = GET_ERROR(THETA_COM, REAL_SHOULDER,
%   REAL_PELVIS, PREDICT_SHOULDER, PREDICT_PELVIS) calculates shoulder and
%   pelvis differences from reality and prediction for a trial.

    assert(length(real_shoulder) == length(predict_shoulder));
    assert(length(real_pelvis) == length(predict_pelvis));
    assert(length(real_shoulder) == length(real_pelvis));
    assert(length(real_shoulder) == length(theta_com));

    num_pieces = 10;
    n = length(theta_com) / num_pieces;

    % Shoulder
    real_shoulder_slope = zeros(num_pieces, 1);
    for i = 0 : (num_pieces - 1)
        coeff = polyfit(theta_com((i * n + 1):((i + 1) * n)), ...
                    real_shoulder((i * n + 1):((i + 1) * n)), 1);
        real_shoulder_slope(i + 1) = coeff(1);
    end

    predict_shoulder_slope = zeros(num_pieces, 1);
    for i = 0 : (num_pieces - 1)
        coeff = polyfit(theta_com((i * n + 1):((i + 1) * n)), ...
                    predict_shoulder((i * n + 1):((i + 1) * n)), 1);
        predict_shoulder_slope(i + 1) = coeff(1);
    end

    % Pelvis
    real_pelvis_slope = zeros(num_pieces, 1);
    for i = 0 : (num_pieces - 1)
        coeff = polyfit(theta_com((i * n + 1):((i + 1) * n)), ...
                    real_pelvis((i * n + 1):((i + 1) * n)), 1);
        real_pelvis_slope(i + 1) = coeff(1);
    end

    predict_pelvis_slope = zeros(num_pieces, 1);
    for i = 0 : (num_pieces - 1)
        coeff = polyfit(theta_com((i * n + 1):((i + 1) * n)), ...
                    predict_pelvis((i * n + 1):((i + 1) * n)), 1);
        predict_pelvis_slope(i + 1) = coeff(1);
    end

    % calculate errors
    error_shoulder = mean(predict_shoulder_slope ./ real_shoulder_slope);
    error_pelvis = mean(predict_pelvis_slope ./ real_pelvis_slope);

    figure;
    plot(theta_com, real_shoulder, 'b.'); hold on;
    plot(theta_com, predict_shoulder, 'r-');
    title(strcat('Trial-', num2str(trial_num))); xlabel('\theta_{com}'); ylabel('\theta_{vertical}');
    s = strsplit(folderpath, '/');
    saveas(gcf, strcat('./plot/trunk_results/', s{end - 1}, 'Trial-', num2str(trial_num), '.png'));
    close;

    figure;
    plot(theta_com, real_pelvis, 'b.'); hold on;
    plot(theta_com, predict_pelvis, 'r-');
    title(strcat('Trial-', num2str(trial_num))); xlabel('\theta_{com}'); ylabel('\theta_{vertical}');
    s = strsplit(folderpath, '/');
    saveas(gcf, strcat('./plot/pelvis_results/', s{end - 1}, 'Trial-', num2str(trial_num), '.png'));
    close;
end
