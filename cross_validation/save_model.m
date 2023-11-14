function save_model(model, folderpath, i)
% SAVE_MODEL  Saves model with specified folder path and model sequence number.
%   SAVE_MODEL(FOLDERPATH, I) returns equation with sepecifed number or
%   the best model.

    if (isstring(i) && strcmp(i, 'best'))
        model_name = 'best_model.mat';
    else
        model_name = strcat('model', num2str(i), '.mat');
    end
    filepath = fullfile(folderpath, model_name);
    save(filepath, 'model');
end
