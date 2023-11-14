function comparison_graph(folder, static_trial, trial_num)
% COMPARISON_GRAPH  Generates comparison graph for a specific trial.
%   COMPARISON_GRAPH(FOLDER, STATIC_TRIAL, TRIAL_NUM) generates a 2-by-3
%   comparison image for pelvis and shoulder, as well as other angles for a
%   subject (FOLDER) OF its TRIAL_NUM by its STATIC_TRIAL. 
% 
%   @NOTE: Some plotting are commented out, since there is two way to calculate
%   real data, both use different fill-missing methodology, please carefully
%   choose them.

    %% imports
    addpath('../calculate_com/double_integration_com/');
    addpath('../calculate_com/kinematic_method_com/');
    addpath('../calculate_attributes/');
    addpath('../cross_validation/');
    addpath('../theta_relative_regression/');
    addpath('../theta_z_regression/');

    %% files name
    csv_file = strcat(folder, 'Trial', num2str(trial_num), '.csv');

    %% Get CoM kinematics
    CoM_x = get_double_com(folder, trial_num) / 1000;
    L = get_com_length(folder, static_trial);
    CoM_ang = rad2deg(CoM_x / L);
    CoM_ang = CoM_ang - mean(CoM_ang);
    markers = importfile(csv_file);
    real = real_attributes(markers);

    %% get model prediction
    model_path = '../cross_validation/models/';
    f = load_model(model_path, 'best');
    [predicted_old, predicted_new] = theta_relative_regression(folder, static_trial, trial_num, f);
    [~, predicted_new_new] = theta_z_regression(folder, static_trial, trial_num, f);

    %% Get quiet standing measures from marker data
    markers = importfile(csv_file);
    measures.mass = 85; 
    lasis_x = markers.LASIS; lasis_y = markers.VarName43; lasis_z = markers.VarName44; 
    lasis = [lasis_x lasis_y lasis_z];
    rasis_x = markers.RASIS; rasis_y = markers.VarName40; rasis_z = markers.VarName41;
    rasis = [rasis_x rasis_y rasis_z];
    lpsis_x = markers.LPSIS; lpsis_y = markers.VarName37; lpsis_z = markers.VarName38;
    lpsis = [lpsis_x lpsis_y lpsis_z];
    rpsis_x = markers.RPSIS; rpsis_y = markers.VarName31; rpsis_z = markers.VarName32;
    rpsis = [rpsis_x rpsis_y rpsis_z];
    manub_x = markers.Manub; manub_y = markers.VarName22; manub_z = markers.VarName23;
    manub = [manub_x manub_y manub_z];
    lank_x = markers.LAnkle; lank_y = markers.VarName112; lank_z = markers.VarName113;
    lank = [lank_x lank_y lank_z];
    mid_asis = (lasis + rasis)/2; mid_psis = (lpsis + rpsis)/2; 

    measures.pelvis_depth = mean(sqrt(sum((lasis(:, 2)-lpsis(:, 2)).^2, 2)), "omitnan");
    measures.pelvis_width = mean(sqrt(sum((lasis(:, 1)-rasis(:, 1)).^2, 2)), "omitnan");
    measures.leg_len = mean(sqrt(sum((lasis(:, [1,2,3])-lank(:, [1,2,3])).^2, 2)), "omitnan");
    measures.yhat = -0.24*measures.pelvis_depth - 9.9;
    measures.zhat = -0.16*measures.pelvis_width - 0.04*measures.leg_len - 7.1;
    measures.xhat = 0.28*measures.pelvis_depth + 0.16*measures.pelvis_width + 7.9;
    measures.HJC_distance = measures.xhat*2;
    [lhjc, ~] = getHipJointCenters(mid_asis, mid_psis, rasis, measures);

    measures.leg_len = mean(sqrt(sum((lhjc(:, [1,2,3])-lank(:, [1,2,3])).^2, 2)), "omitnan");
    measures.trunk_len = mean(sqrt(sum((lhjc(:, [1,2,3])-manub(:, [1,2,3])).^2, 2)), "omitnan");
    measures.leg_CoM = 0.567*measures.leg_len;
    measures.pelvis_CoM = 0.105*measures.HJC_distance;
    measures.trunk_CoM = 0.626*measures.trunk_len;

    measures.leg_mass = measures.mass*(0.161-0.0145); measures.leg_CoM_ratio = 0.567;
    measures.pelvis_mass = measures.mass*0.142; measures.pelvis_CoM_ratio = 0.105;
    measures.trunk_mass = measures.mass*(0.678-0.142);measures.trunk_CoM_ratio = 0.626;

    clear markers;

    %% Get sway kinematics from marker data
    markers = importfile(csv_file);
    lasis_x = markers.LASIS; lasis_y = markers.VarName43; lasis_z = markers.VarName44;
    rasis_x = markers.RASIS; rasis_y = markers.VarName40; rasis_z = markers.VarName41;
    lpsis_x = markers.LPSIS; lpsis_y = markers.VarName37; lpsis_z = markers.VarName38;
    rpsis_x = markers.RPSIS; rpsis_y = markers.VarName31; rpsis_z = markers.VarName32;
    lpsis = [lpsis_x lpsis_y lpsis_z]; rpsis = [rpsis_x rpsis_y rpsis_z];
    mid_psis = (lpsis + rpsis)/2;
    lasis = [lasis_x lasis_y lasis_z]; rasis = [rasis_x rasis_y rasis_z];
    mid_asis = (lasis + rasis)/2;
    [lhjc, rhjc] = getHipJointCenters(mid_asis, mid_psis, rasis, measures);

    % Get trunk-pelvis angle
    manub_x = markers.Manub; manub_y = markers.VarName22; manub_z = markers.VarName23;
    manub = [manub_x manub_y manub_z];
    for iAxis = 1:3
        manub(:, iAxis) = ...
        fillmissing(manub(:, iAxis),'makima','SamplePoints',1:length(manub(:, iAxis))); 
        lhjc(:, iAxis) = ...
        fillmissing(lhjc(:, iAxis),'makima','SamplePoints',1:length(lhjc(:, iAxis)));
        rhjc(:, iAxis) = ...
        fillmissing(rhjc(:, iAxis),'makima','SamplePoints',1:length(rhjc(:, iAxis)));
    end
    mid_hjc = (lhjc+rhjc)/2;
    trunk_hjc_vec = manub - mid_hjc;
    % hjc_vec = lhjc - rhjc;
    % pelvis_ang = -atand(hjc_vec(:,3)./hjc_vec(:,1));
    % u = trunk_hjc_vec'; v = hjc_vec';
    % cosTheta = max(min(dot(u,v)./(vecnorm(u).*vecnorm(v)),1),-1);
    % relAngs = acosd(cosTheta);
    trunkAngs = atand(trunk_hjc_vec(:,1)./trunk_hjc_vec(:,3));
    % trunkAngs = 90 - (relAngs - pelvis_ang');
    % plot(trunkAngs)
    % x_hjc_mid = mid_hjc(:,1); x_sho_mid = manub(:,1);

    % Get manubrium
    % manub_x = markers.Manub; manub_y = markers.VarName22; manub_z = markers.VarName23;
    % manub = [manub_x manub_y manub_z];
    rank_x = markers.RAnkle; rank_y = markers.VarName73; rank_z = markers.VarName74;
    rank = [rank_x rank_y rank_z];
    lank_x = markers.LAnkle; lank_y = markers.VarName112; lank_z = markers.VarName113;
    lank = [lank_x lank_y lank_z];
    % lheel_x = markers.LHeel; lheel_y = markers.VarName115; lheel_z = markers.VarName116;
    % lheel = [lheel_x lheel_y lheel_z];
    % ank_dist = mean(sqrt(sum((rank-lank).^2,2)), "omitnan");
    for iAxis = 1:3
    rank(:, iAxis) = ...
    fillmissing(rank(:, iAxis),'makima','SamplePoints',1:length(rank(:, iAxis))); 
    lank(:, iAxis) = ...
    fillmissing(lank(:, iAxis),'makima','SamplePoints',1:length(lank(:, iAxis)));
    end

    % get leg angle
    % leg_vec = lhjc - lheel;
    % leg_ang = atand(leg_vec(:,1)./leg_vec(:,3)); 

    % ankle_distance = 108; % mm
    % figure('units','normalized','outerposition',[0 0 1 1]);
    % measures.leg_len = mean(sqrt(sum((lhjc(:, [1,2,3])-lank(:, [1,2,3])).^2, 2)), "omitnan"); % DIFF: count 3D (model_prediction)
    % measures.trunk_len = mean(sqrt(sum((lhjc(:, [1,2,3])-manub(:, [1,2,3])).^2, 2)), "omitnan");
    % plot(trunk_len)

    %% Prediction
    % [measures.A, measures.B, measures.pend_mass] = ...
    %           initPrediction(measures, ank_dist);
    % predicted_old = runPrediction(measures, CoM_x*1000, ank_dist);
    %plot(CoM_x)

    %% Regression
    % model = fitlm(CoM_ang, relAngs);
    % model.Coefficients.Estimate(2);
    % mean(relAngs)

    %% Plotting
    figure('units','normalized','outerposition',[0 0 1 1]);

    subplot(2,3,1);
    hold on; grid on;
    % plot(CoM_ang, real.vertical_angles, '.');
    % plot(CoM_ang, ones(length(CoM_ang), 1) * mean(real.vertical_angles));
    plot(real.vertical_angles);
    title('Trunk-Pelvis Angle');
    hold off;

    subplot(2,3,2);
    hold on; grid on;
    % plot(pelvis_ang - mean(pelvis_ang));
    plot(real.pelvis_angle, '-');
    plot((predicted_old.pelvis_ang - mean(predicted_old.pelvis_ang)),'--');
    plot((predicted_new.pelvis_ang - mean(predicted_new.pelvis_ang)),':');
    plot((predicted_new_new.pelvis_ang - mean(predicted_new_new.pelvis_ang)),'-.');
    legend('real', 'old', 'new', 'new new');
    title('Pelvis Angle');
    hold off;

    subplot(2,3,3);
    hold on; grid on;
    plot(real.left_leg_angle - mean(real.left_leg_angle), '-');
    plot((predicted_old.leg_ang - mean(predicted_old.leg_ang)),'--');
    plot((predicted_new.leg_ang - mean(predicted_new.leg_ang)),':');
    plot((predicted_new_new.leg_ang - mean(predicted_new_new.leg_ang)),'-.');
    legend('real', 'old', 'new', 'new new');
    title('Leg Angle');
    hold off;

    subplot(2,3,4);
    hold on; grid on;
    % plot(CoM_ang, trunkAngs, '.');
    % plot(CoM_ang, (predicted_old.pelvis_ang - mean(predicted_old.pelvis_ang)),'-');
    % plot(CoM_ang, (predicted_new.pelvis_ang - mean(predicted_new.pelvis_ang)),':');
    % plot(CoM_ang, (predicted_new_new.pelvis_ang - mean(predicted_new_new.pelvis_ang)),'-.');
    % legend('real', 'old', 'new', 'new new');
    plot(trunkAngs);
    title('Trunk-Pelvis-Earth-Z Angle');
    hold off;

    subplot(2,3,5);
    hold on; grid on;
    plot(real.shoulder_x, '-');
    plot((predicted_old.x_shoulder_mid - mean(predicted_old.x_shoulder_mid)),'--');
    plot((predicted_new.x_shoulder_mid - mean(predicted_new.x_shoulder_mid)),':');
    plot((predicted_new_new.x_shoulder_mid - mean(predicted_new_new.x_shoulder_mid)),'-.');
    legend('real', 'old', 'new', 'new new');
    title('Shoulder Position');
    hold off;

    subplot(2,3,6);
    hold on; grid on;
    plot(real.pelvis_x, '-');
    plot((predicted_old.x_pelvis_mid - mean(predicted_old.x_pelvis_mid)),'--');
    plot((predicted_new.x_pelvis_mid - mean(predicted_new.x_pelvis_mid)),':');
    plot((predicted_new_new.x_pelvis_mid - mean(predicted_new_new.x_pelvis_mid)),'-.');
    legend('real', 'old', 'new', 'new new');
    title('Pelvis Position');
    hold off;

    sgtitle(strcat('Trial-', num2str(trial_num), ' Comparison Graph'));

    % save graph
    % path = folder;
    % path(end) = [];
    % [~, folder_name] = fileparts(path);
    % saveas(gcf, strcat('./comparison_imgs/experiments/', folder_name, '/Trial', num2str(trial_num), '.fig'));
end
