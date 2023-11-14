clear; clc; close all;

folderpath = '../../data/MLBAL02/';
model_path = './';

% fit(folderpath, model_path);
predict(folderpath, 8, 27, model_path);

function fit(folderpath, model_path)
    effec_trials = [9:12, 18:21, 27:30, 36:39];
    stances = repelem([200, 150, 100, 50], 4);
    slopes = slopes_from_person(folderpath, effec_trials, stances);

    plot(slopes(:, 1), slopes(:, 2), 'o'); hold on;
    p = polyfit(slopes(:, 1), slopes(:, 2), 2);
    eq = @(x) p(1) * x.^2 + p(2) * x + p(3);
    save_model(eq, model_path);

    y = zeros(150, 1);
    for i = 50:200
        y(i - 49) = polyval(p, i);
    end
    plot(50:200, y);
    plot(50:200, eq(50:200));
end

function save_model(eq, folderpath)
    filepath = strcat(folderpath, 'model.mat');
    save(filepath, 'eq');
end

function eq = load_model(folderpath)
    filepath = strcat(folderpath, 'model.mat');
    eq = load(filepath);
    eq = eq.eq;
end

function predict(folderpath, static_trial, trial_num, model_path)
    addpath('../calculate_com/kinematic_method_com/');
    markers = importfile(strcat(folderpath, 'Trial', num2str(trial_num),'.csv'));

    % load function
    f = load_model(model_path);

    % Calculations
    addpath('../calculate_attributes/');
    real = real_attributes(markers);
    [predict_old, predicted_new] = model_prediction(folderpath, static_trial, trial_num, f);

    % Graphs
    figure; sgtitle('Shoulder and Pelvis X Analysis');

    subplot(1, 2, 1);
    plot(predict_old.x_shoulder_mid - mean(predict_old.x_shoulder_mid)); hold on;
    plot(predicted_new.x_shoulder_mid - mean(predicted_new.x_shoulder_mid));
    plot(real.shoulder_x - mean(real.shoulder_x));
    legend('old model', 'new model', 'real');
    title('shoulder x');
    hold off;

    subplot(1, 2, 2);
    plot(predict_old.x_pelvis_mid - mean(predict_old.x_pelvis_mid)); hold on;
    plot(predicted_new.x_pelvis_mid - mean(predicted_new.x_pelvis_mid));
    plot(real.pelvis_x - mean(real.pelvis_x));
    legend('old model', 'new model', 'real');
    title('pelvis x');
    hold off;
end
