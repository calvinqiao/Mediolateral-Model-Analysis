function fig = see_slopes_and_amplitudes(slopess,ampltiduess)
    fig = figure('Position', [10,10,3200,1200]);
    % Plot the data points and regression line
    subplot(2,3,1); 
    x = slopess.trunk_angle_abs(:,1);
    y = slopess.trunk_angle_abs(:,2);
    plot(x, y, 'o', 'MarkerSize', 8); hold on; % Plot data points as circles
    ymean = zeros(7,1);
    ymean(1) = nanmean(y(x == 50)); ymean(5) = nanmean(y(x == 150));
    ymean(2) = nanmean(y(x == 75)); ymean(6) = nanmean(y(x == 175));
    ymean(3) = nanmean(y(x == 100)); ymean(7) = nanmean(y(x == 200));
    ymean(4) = nanmean(y(x == 125));
    plot([50,75,100,125,150,175,200], ymean); 
    % Add labels and title
    xticks([50, 75, 100, 125, 150, 175, 200]);
    xlabel('Stance width'); ylabel('Slope (deg/deg)'); ylim([-2.4,2.4]);
    title('Trunk Angle w.r.t. Earth-Z axis'); grid on;

    subplot(2,3,2);
    x = slopess.trunk_angle_rel(:,1);
    y = slopess.trunk_angle_rel(:,2);
    plot(x, y, 'o', 'MarkerSize', 8); hold on; % Plot data points as circles
    ymean = zeros(7,1);
    ymean(1) = nanmean(y(x == 50)); ymean(5) = nanmean(y(x == 150));
    ymean(2) = nanmean(y(x == 75)); ymean(6) = nanmean(y(x == 175));
    ymean(3) = nanmean(y(x == 100)); ymean(7) = nanmean(y(x == 200));
    ymean(4) = nanmean(y(x == 125));
    plot([50,75,100,125,150,175,200], ymean);% Plot data points as circles
    % Add labels and title
    xticks([50, 75, 100, 125, 150, 175, 200]);
    xlabel('Stance width'); ylabel('Slope (deg/deg)'); ylim([-2.4,2.4]);
    title('Trunk Pelvis Relative Angle'); grid on;

    subplot(2,3,3);
    x = slopess.trunk_angle_abs(:,1);
    y = slopess.trunk_angle_abs(:,2);
    plot(x, y, 'o', 'MarkerSize', 8); hold on; % Plot data points as circles
    ymean = zeros(7,1);
    ymean(1) = nanmean(y(x == 50)); ymean(5) = nanmean(y(x == 150));
    ymean(2) = nanmean(y(x == 75)); ymean(6) = nanmean(y(x == 175));
    ymean(3) = nanmean(y(x == 100)); ymean(7) = nanmean(y(x == 200));
    ymean(4) = nanmean(y(x == 125));
    plot([50,75,100,125,150,175,200], ymean);% Plot data points as circles
    % Add labels and title
    xticks([50, 75, 100, 125, 150, 175, 200]);
    xlabel('Stance width'); ylabel('Slope (deg/eg)'); ylim([-2.4,2.4]);
    title('Pelvis Angle'); grid on;

    subplot(2,3,4); 
    x = slopess.trunk_angle_abs(:,1);
    y = slopess.trunk_angle_abs(:,2);
    plot(x, y, 'o', 'MarkerSize', 8); hold on; % Plot data points as circles
    ymean = zeros(7,1);
    ymean(1) = nanmean(y(x == 50)); ymean(5) = nanmean(y(x == 150));
    ymean(2) = nanmean(y(x == 75)); ymean(6) = nanmean(y(x == 175));
    ymean(3) = nanmean(y(x == 100)); ymean(7) = nanmean(y(x == 200));
    ymean(4) = nanmean(y(x == 125));
    plot([50,75,100,125,150,175,200], ymean); 
    % Add labels and title
    xticks([50, 75, 100, 125, 150, 175, 200]);
    xlabel('Stance width'); ylabel('Angle (deg)'); ylim([-10,10]);
    title('Trunk Angle w.r.t. Earth-Z axis'); grid on;

    subplot(2,3,5);
    x = ampltiduess.trunk_angle_rel(:,1);
    y = ampltiduess.trunk_angle_rel(:,2);
    plot(x, y, 'o', 'MarkerSize', 8); hold on; % Plot data points as circles
    ymean = zeros(7,1);
    ymean(1) = nanmean(y(x == 50)); ymean(5) = nanmean(y(x == 150));
    ymean(2) = nanmean(y(x == 75)); ymean(6) = nanmean(y(x == 175));
    ymean(3) = nanmean(y(x == 100)); ymean(7) = nanmean(y(x == 200));
    ymean(4) = nanmean(y(x == 125));
    plot([50,75,100,125,150,175,200], ymean);% Plot data points as circles
    % Add labels and title
    xticks([50, 75, 100, 125, 150, 175, 200]);
    xlabel('Stance width'); ylabel('Angle (deg)'); ylim([-10,10]);
    title('Trunk Pelvis Relative Angle'); grid on;

    subplot(2,3,6);
    x = ampltiduess.trunk_angle_abs(:,1);
    y = ampltiduess.trunk_angle_abs(:,2);
    plot(x, y, 'o', 'MarkerSize', 8); hold on; % Plot data points as circles
    ymean = zeros(7,1);
    ymean(1) = nanmean(y(x == 50)); ymean(5) = nanmean(y(x == 150));
    ymean(2) = nanmean(y(x == 75)); ymean(6) = nanmean(y(x == 175));
    ymean(3) = nanmean(y(x == 100)); ymean(7) = nanmean(y(x == 200));
    ymean(4) = nanmean(y(x == 125));
    plot([50,75,100,125,150,175,200], ymean);% Plot data points as circles
    % Add labels and title
    xticks([50, 75, 100, 125, 150, 175, 200]);
    xlabel('Stance width'); ylabel('Angle (deg)'); ylim([-10,10]);
    title('Pelvis Angle'); grid on;
    
    saveas(gcf, strcat('slopes_ampltidues_plots.fig'));
    % close;

end