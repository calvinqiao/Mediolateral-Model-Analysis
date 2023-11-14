function [slopes, amplitudes, width] = slope_from_trial(folderpath, static_trial_num, trial_num)
% SLOPE_FROM_TRIAL  Calculates slopes of vert_angles vs theta_com of one trial.
%   SLOPE = SLOPE_FROM_TRIAL(FOLDERPATH, STATIC_TRIAL_NUM, TRIAL_NUM) gets
%   slope of vert_angles vs theta_com for a subject (FOLDERPATH) of one
%   TRIAL_NUM.

    % imports
    addpath('../calculate_com/kinematic_method_com/');
    addpath('../calculate_attributes/');
    addpath('../calculate_com/double_integration_com/');
    addpath('../calculate_com/verify_stance_width/');

    slopes = struct();

    % load data
    filepath = strcat(folderpath, 'Trial', num2str(trial_num), '.csv');
    markers = importfile(filepath);

    % get Attributes
    real = real_attributes(markers);
    trunk_angle_rel = deg2rad(real.trunk_angle_rel);
    theta_com = get_double_com(folderpath, trial_num) / get_com_length(folderpath, static_trial_num);
     
    % get peaks
    [~,MaxIdx1] =findpeaks(theta_com);
    [~,MaxIdx2] =findpeaks(-theta_com);
    MaxIdx = union(MaxIdx1,MaxIdx2);
    peaks = real.trunk_angle_rel(MaxIdx1);
    vallies = real.trunk_angle_rel(MaxIdx2);
    amplitudes.trunk_angle_rel = mean([peaks;abs(vallies)]);
    peaks = real.trunk_angle_abs(MaxIdx1);
    vallies = real.trunk_angle_abs(MaxIdx2);
    amplitudes.trunk_angle_abs = mean([peaks;abs(vallies)]);
    peaks = real.pelvis_angle(MaxIdx1);
    vallies = real.pelvis_angle(MaxIdx2);
    amplitudes.pelvis_angle = mean([peaks;abs(vallies)]);

    stance_width = get_stance_width(folderpath, trial_num);
    getZeroCrossings = @(var) find(var(:).*circshift(var(:), [-1, 0]) <= 0);
    zeroCrosses = getZeroCrossings(theta_com);
    width = nanmean(stance_width(zeroCrosses));

    % split in pieces
    num_pieces = 10;
    n = length(theta_com) / num_pieces;
    coeff = zeros(num_pieces, 2);
    for i = 0 : (num_pieces - 1)
        coeff(i + 1, :) = regress(trunk_angle_rel((i * n + 1):((i + 1) * n)), ...
                                  [theta_com((i * n + 1):((i + 1) * n)), ones(n, 1)]);
    end
    % coeff = regress(vert_angles, [theta_com, ones(size(theta_com))]);
    slopes.trunk_angle_rel = mean(coeff(:, 1));

    trunk_angle_abs = deg2rad(real.trunk_angle_abs); coeff = zeros(num_pieces, 2);
    for i = 0 : (num_pieces - 1)
        coeff(i + 1, :) = regress(trunk_angle_abs((i * n + 1):((i + 1) * n)), ...
                                  [theta_com((i * n + 1):((i + 1) * n)), ones(n, 1)]);
    end
    slopes.trunk_angle_abs = mean(coeff(:, 1));

    pelvis_angle = deg2rad(real.pelvis_angle); coeff = zeros(num_pieces, 2);
    for i = 0 : (num_pieces - 1)
        coeff(i + 1, :) = regress(pelvis_angle((i * n + 1):((i + 1) * n)), ...
                                  [theta_com((i * n + 1):((i + 1) * n)), ones(n, 1)]);
    end
    slopes.pelvis_angle = mean(coeff(:, 1));

    % % Plot the data with curve
    % fig = figure('Position', [20,20,2400,1200]);
    % fig.WindowState = 'maximized';
    % subplot(3,2,1);
    % plot(rad2deg(theta_com), rad2deg(trunk_angle_rel), 'b.'); hold on;
    % % plot(rad2deg(theta_com), rad2deg(slopes.trunk_angle_rel * theta_com), 'r-');
    % title(strcat('Trial-', num2str(trial_num))); 
    % xlabel('\theta_{CoM} (deg)'); title('Trunk-Pelvis Relative Angle (deg)');
    % ylim([-10,10]); xlim([-15,15]); grid on;
    % subplot(3,2,2);
    % plot(rad2deg(theta_com), rad2deg(trunk_angle_abs), 'b.'); hold on;
    % % plot(rad2deg(theta_com), rad2deg(slopes.trunk_angle_abs * theta_com), 'r-');
    % xlabel('\theta_{CoM} (deg)'); title('\Trunk EarthZ Angle} (deg)');
    % ylim([-10,10]); xlim([-15,15]); grid on;
    % subplot(3,2,3);
    % plot(rad2deg(theta_com), rad2deg(pelvis_angle), 'b.'); hold on;
    % % plot(rad2deg(theta_com), rad2deg(slopes.pelvis_angle * theta_com), 'r-');
    % ylim([-10,10]); xlim([-15,15]); grid on;
    % xlabel('\theta_{CoM} (deg)'); title('Pelvis Angle (deg)');
    % subplot(3,2,4);
    % plot(rad2deg(theta_com), real.pelvis_x, 'b.'); hold on;
    % % plot(rad2deg(theta_com), rad2deg(slopes.pelvis_angle * theta_com), 'r-');
    % ylim([-200,200]); xlim([-15,15]); grid on;
    % xlabel('\theta_{CoM} (deg)'); title('Pelvis X (mm)');
    % subplot(3,2,5);
    % plot(rad2deg(theta_com), real.shoulder_x, 'b.'); hold on;
    % % plot(rad2deg(theta_com), rad2deg(slopes.pelvis_angle * theta_com), 'r-');
    % ylim([-200,200]); xlim([-15,15]); grid on;
    % xlabel('\theta_{CoM} (deg)'); title('Shoulder X (mm)');
    % 
    % s = strsplit(folderpath, '/');
    % saveas(gcf, strcat('../cross_validation/plot/angle/', s{end - 1}, ...
    %                    'Trial-', num2str(trial_num), '.png'));
    % saveas(gcf, strcat('../cross_validation/plot/angle/', s{end - 1}, ...
    %                    'Trial-', num2str(trial_num), '.fig'));
    % close
    
    time = 1/100:1/100:length(theta_com)/100;
    fig = figure('Position', [20,20,2400,1200],'visible','off');
    fig.WindowState = 'maximized';
    subplot(2,4,1);
    plot(time, rad2deg(theta_com)); ylim([-10,10]); grid on;
    title('CoM Angle (deg)'); xlabel('Time (sec)')
    subplot(2,4,2);
    plot(time, rad2deg(trunk_angle_rel)); ylim([-10,10]); grid on;
    title('Trunk-Pelvis Relative Angle (deg)')
    subplot(2,4,3);
    plot(time, rad2deg(trunk_angle_abs)); ylim([-10,10]); grid on;
    title('Trunk Earth-Z Angle (deg)')
    subplot(2,4,4);
    plot(time, rad2deg(pelvis_angle)); ylim([-10,10]); grid on;
    title('Pelvis Angle (deg)')

    subplot(2,4,6);
    plot(rad2deg(theta_com), rad2deg(trunk_angle_rel), 'b.'); hold on;
    % plot(rad2deg(theta_com), rad2deg(slopes.trunk_angle_rel * theta_com), 'r-');
    title(strcat('Trial-', num2str(trial_num))); 
    xlabel('\theta_{CoM} (deg)'); title('Trunk-Pelvis Relative Angle (deg)');
    ylim([-10,10]); xlim([-15,15]); grid on;
    subplot(2,4,7);
    plot(rad2deg(theta_com), rad2deg(trunk_angle_abs), 'b.'); hold on;
    % plot(rad2deg(theta_com), rad2deg(slopes.trunk_angle_abs * theta_com), 'r-');
    xlabel('\theta_{CoM} (deg)'); title('\Trunk EarthZ Angle} (deg)');
    ylim([-10,10]); xlim([-15,15]); grid on;
    subplot(2,4,8);
    plot(rad2deg(theta_com), rad2deg(pelvis_angle), 'b.'); hold on;
    % plot(rad2deg(theta_com), rad2deg(slopes.pelvis_angle * theta_com), 'r-');
    ylim([-10,10]); xlim([-15,15]); grid on;
    xlabel('\theta_{CoM} (deg)'); title('Pelvis Angle (deg)');
    
    s = strsplit(folderpath, '/');
    saveas(gcf, strcat('../cross_validation/plot/all_angle/', s{end - 1}, ...
                       'Trial-', num2str(trial_num), '.png'));
    saveas(gcf, strcat('../cross_validation/plot/all_angle/', s{end - 1}, ...
                       'Trial-', num2str(trial_num), '.fig'));
    close
    
    fig = figure('Position', [20,20,2400,1200],'visible','off');
    fig.WindowState = 'maximized';
    subplot(2,2,1);
    plot(time, real.pelvis_x); ylim([-200,200]); grid on;
    title('Pelvis X (mm)')
    subplot(2,2,2);
    plot(time, real.shoulder_x); ylim([-200,200]); grid on;
    title('Shoulder X (mm)')
    subplot(2,2,3);
    plot(rad2deg(theta_com), real.pelvis_x, 'b.'); hold on;
    % plot(rad2deg(theta_com), rad2deg(slopes.pelvis_angle * theta_com), 'r-');
    ylim([-200,200]); xlim([-15,15]); grid on;
    xlabel('\theta_{CoM} (deg)'); title('Pelvis X (mm)');
    subplot(2,2,4);
    plot(rad2deg(theta_com), real.shoulder_x, 'b.'); hold on;
    % plot(rad2deg(theta_com), rad2deg(slopes.pelvis_angle * theta_com), 'r-');
    ylim([-200,200]); xlim([-15,15]); grid on;
    xlabel('\theta_{CoM} (deg)'); title('Shoulder X (mm)');
    s = strsplit(folderpath, '/');
    saveas(gcf, strcat('../cross_validation/plot/all_position/', s{end - 1}, ...
                       'Trial-', num2str(trial_num), '.png'));
    saveas(gcf, strcat('../cross_validation/plot/all_position/', s{end - 1}, ...
                       'Trial-', num2str(trial_num), '.fig'));
    close

    fig = figure('Position', [20,20,2400,1200],'visible','off');
    fig.WindowState = 'maximized';
    subplot(4,3,1);
    plot(time, real.l_psisx); 
    title('Left PSIS X (mm)'); xlabel('Time (sec)')
    subplot(4,3,2);
    plot(time, real.l_psisz); 
    title('Left PSIS Z (mm)'); xlabel('Time (sec)')
    subplot(4,3,3);
    plot(time, real.r_psisx); 
    title('Right PSIS X (mm)'); xlabel('Time (sec)')
    subplot(4,3,4);
    plot(time, real.r_psisz); 
    title('Right PSIS Z (mm)'); xlabel('Time (sec)')
    subplot(4,3,5);
    plot(time, real.l_asisx); 
    title('Left ASIS X (mm)'); xlabel('Time (sec)')
    subplot(4,3,6);
    plot(time, real.l_asisz); 
    title('Left ASIS Z (mm)'); xlabel('Time (sec)')
    subplot(4,3,7);
    plot(time, real.r_asisx); 
    title('Right ASIS X (mm)'); xlabel('Time (sec)')
    subplot(4,3,8);
    plot(time, real.r_asisz); 
    title('Right ASIS Z (mm)'); xlabel('Time (sec)')
    subplot(4,3,9);
    plot(time, real.l_hjcx); 
    title('Left HJC X (mm)'); xlabel('Time (sec)')
    subplot(4,3,10);
    plot(time, real.l_hjcz); 
    title('Left HJC Z (mm)'); xlabel('Time (sec)')
    subplot(4,3,11);
    plot(time, real.r_hjcx); 
    title('Right HJC X (mm)'); xlabel('Time (sec)')
    subplot(4,3,12);
    plot(time, real.r_hjcz); 
    title('Right HJC Z (mm)'); xlabel('Time (sec)')

    s = strsplit(folderpath, '/');
    saveas(gcf, strcat('../cross_validation/plot/hjc/', s{end - 1}, ...
                       'Trial-', num2str(trial_num), '.png'));
    close
end

