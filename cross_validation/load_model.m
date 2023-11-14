function eq = load_model(folderpath, i)
% LOAD_MODEL  Loads model with specified folder path and model sequence number.
%   EQ = LOAD_MODEL(FOLDERPATH, I) returns equation with sepecifed number or
%   the best model.

    if (isstring(i) && strcmp(i, 'best'))
        filepath = fullfile(folderpath, 'best_model.mat');
    else
        model_name = strcat('model', num2str(i), '.mat');
        filepath = fullfile(folderpath, model_name);
    end

    % load the model input workspace and extract the equation
    load(filepath, 'model');
    eq = model.eq;
end
