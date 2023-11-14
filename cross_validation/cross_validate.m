function [best_model, errors] = cross_validate(folders, effec_trials, ...
                    static_trials, fold_size)
% CROSS_VALIDATE  Calculates the regression models for prediction.
%   [BEST_MODEL, ERRORS] = CROSS_VALIDATE(FOLDERS, EFFEC_TRIALS, STATIC_TRIALS)
%   fits models with specified folders (one subject one folder), and a trials
%   matrix (EFFEC_TRIALS) which has each row representing effective trials and
%   STATIC_TRIALS for each subjects, finally return the best model while saving
%   each model using cross-validation by LOOCV.
% 
%   @NOTE: folders is a cell array.
% 
%   See also TRAIN_TEST_SPLIT, FIT, TEST, SAVE_MODEL, PROCESS_ERROR.

    assert(length(folders) == size(effec_trials, 1));
    assert(length(folders) == length(static_trials));
    progressbar;

    min_error = Inf;
    best_model = struct();
    errors.shoulder = zeros(length(folders), 7);
    errors.pelvis = zeros(length(folders), 7);
    fold_num = floor(length(folders) / fold_size);

    for i = 1:fold_num
        [folders_train, folders_test, effec_trials_train, ...
            effec_trials_test, static_trials_train, static_trials_test] ...
            = train_test_split(folders, effec_trials, static_trials, fold_size, i);
        model = fit(folders_train, static_trials_train, ...
                    effec_trials_train, '2nd-order', i);
        error = test(model, folders_test, static_trials_test, effec_trials_test);

        % errors(i) = process_error(error);
        errors.shoulder(i , :) = error.shoulder;
        errors.pelvis(i , :) = error.pelvis;
        % if (errors(i) < min_error)
        %     best_model = model;
        %     min_error = errors(i);
        % end

        % save_model(model, './models/', i);
        progressbar(i/length(folders));
    end
    
    % save_model(best_model, './models/', 'best');
end

function total_error = process_error(error)
% PROCESS_ERROR  Calculates the total error as a number.
%   TOTAL_ERROR = PROCESS_ERROR(ERROR) calculates TOTOL_ERROR as a number based
%   on error list ERROR.

    % error_shoulder = abs(error.shoulder - 1);
    % error_pelvis = abs(error.pelvis - 1);
    % total_error = mean(error_shoulder + error_pelvis);
end
