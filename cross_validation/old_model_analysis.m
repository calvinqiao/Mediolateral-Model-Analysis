function [errors] = old_model_analysis(folders, effec_trials, static_trials)
    addpath('../calculate_com/kinematic_method_com/');
    addpath('../calculate_attributes/');
    addpath('../theta_trunk_pelvis_regression/');
    addpath('../theta_earthz_regression/');
    addpath('../calculate_com/double_integration_com/');
    
    errors = struct();
    errors.shoulder = zeros(length(folders), 7, "double");
    errors.pelvis = zeros(length(folders), 7, "double");

    for iFolder = 1:length(folders)
        folderpath = folders{iFolder};
        static_trial = static_trials(iFolder);
        com_length = get_com_length(folderpath, static_trial);
        
        effec_trials_subject = effec_trials(iFolder,:);
        l = length(effec_trials_subject);
        error = struct();
        error.shoulder = zeros(l, 1);
        error.pelvis = zeros(l, 1);

        for iTrial = 1:l
            disp(['Subject',num2str(iFolder),'Trial', num2str(iTrial)]);
            trial_num = effec_trials_subject(iTrial);
            markers = importfile(strcat(folderpath, 'Trial', ...
                            num2str(trial_num), '.csv'));
            real = real_attributes(markers);

            [prediction] = get_old_prediction(...
                                    folderpath, static_trial, trial_num);

            theta_com = get_double_com(folderpath, trial_num) / com_length;
            % get error
            [error.shoulder(iTrial), error.pelvis(iTrial)] = get_error(...
                            theta_com, ...
                            real.shoulder_x, real.pelvis_x, ...
                            prediction.x_shoulder_mid, ...
                            prediction.x_pelvis_mid);
        end
        error.shoulder = mean_metrics(error.shoulder);
        error.pelvis = mean_metrics(error.pelvis);
        errors.shoulder(iFolder, :) = error.shoulder;
        errors.pelvis(iFolder, :) = error.pelvis;
    end

end

function [error_shoulder, error_pelvis] = get_error(theta_com, real_shoulder, real_pelvis, ...
                    predict_shoulder, predict_pelvis)
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
end





