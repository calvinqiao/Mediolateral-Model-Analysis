function [folders_train, folders_test, effec_trials_train, ...
    effec_trials_test, static_trials_train, static_trials_test] ...
    = train_test_split(folders, effec_trials, static_trials, fold_size, i)
% TRAIN_TEST_SPLIT  Separates all subjects into train and test suites.
%   [FOLDERS_TRAIN, FOLDERS_TEST, EFFEC_TRIALS_TRAIN, EFFEC_TRIALS_TEST,
%   STATIC_TRIALS_TRAIN, STATIC_TRIALS_TEST] = TRAIN_TEST_SPLIT(FOLDERS,
%   EFFEC_TRIALS, STATIC_TRIALS, I) uses LOOCV to split train/test test for
%   each iteration I from total set FOLDERS.

    select_train = true(1, length(folders));
    select_train(((i - 1) * fold_size + 1) : (i * fold_size)) = false;
    select_test = false(1, length(folders));
    select_test(((i - 1) * fold_size + 1) : (i * fold_size)) = true;

    folders_train = folders(select_train);
    folders_test = folders(select_test);

    effec_trials_train = effec_trials(select_train, :);
    effec_trials_test = effec_trials(select_test, :);
    static_trials_train = static_trials(select_train);
    static_trials_test = static_trials(select_test);
end
