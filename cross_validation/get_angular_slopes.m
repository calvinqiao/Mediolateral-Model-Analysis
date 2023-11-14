function [slopess, amplitudess, widthss] = ...
    get_angular_slopes(folders, static_trials, effec_trials_all)
    addpath('../theta_trunk_pelvis_regression/');

    n = length(folders);
    slopess.trunk_angle_abs = zeros(n * 14, 2);
    slopess.trunk_angle_rel = zeros(n * 14, 2);
    slopess.pelvis_angle = zeros(n * 14, 2);
    amplitudess.trunk_angle_abs = zeros(n * 14, 2);
    amplitudess.trunk_angle_rel = zeros(n * 14, 2);
    amplitudess.pelvis_angle = zeros(n * 14, 2);
    widthss = zeros(n * 14, 1);

    for i = 1:n
        progressbar((i - 1) / n);
        folderpath = folders{i};
        disp(['Collecting all angular slopes...']);
        disp(folderpath);
        effec_trials = effec_trials_all(i, :);
        static_trial = static_trials(i);

        stances = repelem([50, 75, 100, 125, 150, 175, 200], 2);
        [slopes, amplitudes, widths] = slopes_from_person(folderpath, effec_trials, stances, static_trial);
        widthss((i - 1) * 14 + 1 : (i - 1) * 14 + 14, 1) = widths;
        slopess.trunk_angle_abs((i - 1) * 14 + 1 : (i - 1) * 14 + 14, :) = ...
        slopes.trunk_angle_abs;

        slopess.trunk_angle_rel((i - 1) * 14 + 1 : (i - 1) * 14 + 14, :) = ...
        slopes.trunk_angle_rel;

        slopess.pelvis_angle((i - 1) * 14 + 1 : (i - 1) * 14 + 14, :) = ...
        slopes.pelvis_angle;

        amplitudess.trunk_angle_abs((i - 1) * 14 + 1 : (i - 1) * 14 + 14, :) = ...
        amplitudes.trunk_angle_abs;

        amplitudess.trunk_angle_rel((i - 1) * 14 + 1 : (i - 1) * 14 + 14, :) = ...
        amplitudes.trunk_angle_rel;

        amplitudess.pelvis_angle((i - 1) * 14 + 1 : (i - 1) * 14 + 14, :) = ...
        amplitudes.pelvis_angle;
    end

    slopess.trunk_angle_abs = meanOfTwoRows(slopess.trunk_angle_abs); % compress the slopes so one stance from a subject only gives one slop
    slopess.trunk_angle_rel = meanOfTwoRows(slopess.trunk_angle_rel);
    slopess.pelvis_angle = meanOfTwoRows(slopess.pelvis_angle);

    amplitudess.trunk_angle_abs = meanOfTwoRows(amplitudess.trunk_angle_abs); % compress the slopes so one stance from a subject only gives one slop
    amplitudess.trunk_angle_rel = meanOfTwoRows(amplitudess.trunk_angle_rel);
    amplitudess.pelvis_angle = meanOfTwoRows(amplitudess.pelvis_angle);

    widthss = meanOfTwoRows(widthss);
    
    disp('Plotting all slopes w.r.t. stance width')
    % do_plot(slopess, 'slope');

    disp('Plotting all peaks w.r.t. stance width')
    % do_plot(amplitudess, 'amplitude');
    
end

function do_plot(metrics, name)

    if strcmp(name, 'slope')
        yl = 'Slope (deg/deg)'; fn = 'slope';
    elseif strcmp(name, 'amplitude')
        yl = 'Amplitude (deg)'; fn = 'amplitude';
    end

    figure;
    % Plot the data points and regression line
    subplot(3,1,1);
    x = metrics.trunk_angle_abs(:,1);
    y = metrics.trunk_angle_abs(:,2);
    plot(x, y, 'o', 'MarkerSize', 8); % Plot data points as circles
    % Add labels and title
    xticks([50, 75, 100, 125, 150, 175, 200]);
    xlabel('Stance width'); ylabel(yl);
    title('Trunk Angle w.r.t. Earth-Z axis');

    subplot(3,1,2);
    x = metrics.trunk_angle_rel(:,1);
    y = metrics.trunk_angle_rel(:,2);
    plot(x, y, 'o', 'MarkerSize', 8); % Plot data points as circles
    % Add labels and title
    xticks([50, 75, 100, 125, 150, 175, 200]);
    xlabel('Stance width'); ylabel(yl);
    title('Trunk Pelvis Relative Angle');

    subplot(3,1,3);
    x = metrics.trunk_angle_abs(:,1);
    y = metrics.trunk_angle_abs(:,2);
    plot(x, y, 'o', 'MarkerSize', 8); % Plot data points as circles
    % Add labels and title
    xticks([50, 75, 100, 125, 150, 175, 200]);
    xlabel('Stance width'); ylabel(yl);
    title('Pelvis Angle');
    
    saveas(gcf, strcat(fn,'_plot.fig'));
    saveas(gcf, strcat(fn,'_plot.png'));
    close;

end