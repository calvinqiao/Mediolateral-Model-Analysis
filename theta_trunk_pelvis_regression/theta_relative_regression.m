function [predicted_old, predicted_new] = theta_relative_regression(folderpath, static_trial, trial_num, f)
% THETA_RELATIVE_REGRESSION  Predicts the subject's movements.
%   [PREDICTED_OLD, PREDICTED_NEW] = THETA_RELATIVE_REGRESSION(FOLDERPATH,
%   STATIC_TRIAL, TRIAL_NUM, F) is the same but just a interface for
%   model_prediction to get regression from theta_vertical vs theta_com.
% 
%   See also MODEL_PREDICTION.

    [predicted_old, predicted_new] = model_prediction(folderpath, static_trial, trial_num, f);
end
