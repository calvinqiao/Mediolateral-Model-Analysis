function slope = slope_from_trial(folderpath, static_trial_num,  trial_num)
% SLOPE_FROM_TRIAL  Calculates slopes of vert_angles vs theta_com of one trial.
%   SLOPE = SLOPE_FROM_TRIAL(FOLDERPATH, STATIC_TRIAL_NUM, TRIAL_NUM) gets
%   slope of theta_t vs theta_com for a subject (FOLDERPATH) of one TRIAL_NUM.

    % imports
    addpath('../calculate_com/kinematic_method_com/');
    addpath('../calculate_attributes/');
    addpath('../calculate_com/double_integration_com/');

    % load data
    filepath = strcat(folderpath, 'Trial', num2str(trial_num), '.csv');
    markers = importfile(filepath);

    % get attributes
    real = real_attributes(markers);
    theta_t = deg2rad(real.theta_t);
    theta_com = get_double_com(folderpath, trial_num) / get_com_length(folderpath, static_trial_num);

    % split in pieces
    num_pieces = 10;
    n = length(theta_com) / num_pieces;
    coeff = zeros(num_pieces, 2);
    for i = 0 : (num_pieces - 1)
        coeff(i + 1, :) = regress(theta_t((i * n + 1):((i + 1) * n)), [theta_com((i * n + 1):((i + 1) * n)), ones(n, 1)]);
    end

    slope = mean(coeff(:, 1));
    % coeff = regress(theta_t, [theta_com, ones(size(theta_com))]);
    % slope = coeff(1);

    % Plot the data with curve
    plot(theta_com, theta_t, 'b.'); hold on;
    plot(theta_com, slope * theta_com, 'r-');
    [~, filename, ~] = fileparts(filepath);
    title(filename); xlabel('\theta_{com}'); ylabel('\theta_{t}');
    hold off;
    close;
end
