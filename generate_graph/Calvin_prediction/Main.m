clc; clear; close all;

% Seems like the model works well within a certain angular range
trial = 18; %10, 18, 27, 36
% -1.2913, -0.7855, 0.0569, -0.7405
% -1.3186, -0.6276, -0.0583, -0.9046
% -1.5675, -0.9659, -0.2201, -0.8
% -1.3956, -0.9670, -0.4260, -0.7843
%% Get CoM kinematics
dt = 1/2000; measures.mass = 85; 
tor_info = loadTorque(strcat('../../../Data-0428/MLBAL02/Trial',num2str(trial),'.forces')); 
fx1 = tor_info.FX1; fx2 = tor_info.FX2; fx = fx1+fx2;
fz1 = tor_info.FZ1; fz2 = tor_info.FZ2; 
copx1 = tor_info.X1; copx2 = tor_info.X2; 
copx = copx1.*(fz1./(fz1+fz2)) + copx2.*(fz2./(fz1+fz2));
copx = copx/1000;
fx = fx - mean(fx); copx = copx - mean(copx);
[CoM_x] = doubleIntegrator(copx, fx, measures.mass, dt);
CoM_x = downsample(CoM_x, 20);
L = 0.95;
CoM_ang = rad2deg(CoM_x/L); CoM_ang = CoM_ang - mean(CoM_ang);
% plot(CoM_ang)

%% Get quiet standing measures from marker data
markers = load3D_table(strcat('../../../Data-0428/MLBAL02/Trial',num2str(trial),'.trc')); %9 13 24
measures.mass = 85; 
lasis_x = markers.LASIS; lasis_y = markers.VarName43; lasis_z = markers.VarName44; 
lasis = [lasis_x lasis_y lasis_z];
rasis_x = markers.RASIS; rasis_y = markers.VarName37; rasis_z = markers.VarName38;
rasis = [rasis_x rasis_y rasis_z];
lpsis_x = markers.LPSIS; lpsis_y = markers.VarName31; lpsis_z = markers.VarName32;
lpsis = [lpsis_x lpsis_y lpsis_z];
rpsis_x = markers.RPSIS; rpsis_y = markers.VarName34; rpsis_z = markers.VarName35;
rpsis = [rpsis_x rpsis_y rpsis_z];
manub_x = markers.Manub; manub_y = markers.VarName22; manub_z = markers.VarName23;
manub = [manub_x manub_y manub_z];
rank_x = markers.RAnkle; rank_y = markers.VarName82; rank_z = markers.VarName83;
rank = [rank_x rank_y rank_z];
lank_x = markers.LAnkle; lank_y = markers.VarName139; lank_z = markers.VarName140;
lank = [lank_x lank_y lank_z];
mid_asis = (lasis + rasis)/2; mid_psis = (lpsis + rpsis)/2; 

measures.pelvis_depth = nanmean(sqrt(sum((lasis(:, [2])-lpsis(:, [2])).^2, 2)));
measures.pelvis_width = nanmean(sqrt(sum((lasis(:, [1])-rasis(:, [1])).^2, 2)));
measures.leg_len = nanmean(sqrt(sum((lasis(:, [1,2,3])-lank(:, [1,2,3])).^2, 2)));
measures.yhat = -0.24*measures.pelvis_depth - 9.9;
measures.zhat = -0.16*measures.pelvis_width - 0.04*measures.leg_len - 7.1;
measures.xhat = 0.28*measures.pelvis_depth + 0.16*measures.pelvis_width + 7.9;
measures.HJC_distance = measures.xhat*2;
[lhjc, rhjc] = getHipJointCenters(mid_asis, mid_psis, rasis, measures);

measures.leg_len = nanmean(sqrt(sum((lhjc(:, [1,2,3])-lank(:, [1,2,3])).^2, 2)));
measures.trunk_len = nanmean(sqrt(sum((lhjc(:, [1,2,3])-manub(:, [1,2,3])).^2, 2)));
measures.leg_CoM = 0.567*measures.leg_len;
measures.pelvis_CoM = 0.105*measures.HJC_distance;
measures.trunk_CoM = 0.626*measures.trunk_len;

measures.leg_mass = measures.mass*(0.161-0.0145); measures.leg_CoM_ratio = 0.567;
measures.pelvis_mass = measures.mass*0.142; measures.pelvis_CoM_ratio = 0.105;
measures.trunk_mass = measures.mass*(0.678-0.142);measures.trunk_CoM_ratio = 0.626;

clear markers;

%% Get sway kinematics from marker data
markers = load3D_table(strcat('../../../Data-0428/MLBAL02/Trial',num2str(trial),'.trc')); %9 13 24
lasis_x = markers.LASIS; lasis_y = markers.VarName43; lasis_z = markers.VarName44;
rasis_x = markers.RASIS; rasis_y = markers.VarName37; rasis_z = markers.VarName38;
lpsis_x = markers.LPSIS; lpsis_y = markers.VarName31; lpsis_z = markers.VarName32;
rpsis_x = markers.RPSIS; rpsis_y = markers.VarName34; rpsis_z = markers.VarName35;
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
hjc_vec = lhjc - rhjc;
pelvis_ang = -atand(hjc_vec(:,3)./hjc_vec(:,1)); 
u = trunk_hjc_vec'; v = hjc_vec';
cosTheta = max(min(dot(u,v)./(vecnorm(u).*vecnorm(v)),1),-1);
relAngs = acosd(cosTheta);
trunkAngs = atand(trunk_hjc_vec(:,1)./trunk_hjc_vec(:,3));
% trunkAngs = 90 - (relAngs - pelvis_ang');
% plot(trunkAngs)
x_hjc_mid = mid_hjc(:,1); x_sho_mid = manub(:,1);

% Get manubrium
% manub_x = markers.Manub; manub_y = markers.VarName22; manub_z = markers.VarName23;
% manub = [manub_x manub_y manub_z];
rank_x = markers.RAnkle; rank_y = markers.VarName82; rank_z = markers.VarName83;
rank = [rank_x rank_y rank_z];
lank_x = markers.LAnkle; lank_y = markers.VarName139; lank_z = markers.VarName140;
lank = [lank_x lank_y lank_z];
lheel_x = markers.LHeel; lheel_y = markers.VarName136; lheel_z = markers.VarName137;
lheel = [lheel_x lheel_y lheel_z];
ank_dist = nanmean(sqrt(sum((rank-lank).^2,2)));
for iAxis = 1:3
   rank(:, iAxis) = ...
   fillmissing(rank(:, iAxis),'makima','SamplePoints',1:length(rank(:, iAxis))); 
   lank(:, iAxis) = ...
   fillmissing(lank(:, iAxis),'makima','SamplePoints',1:length(lank(:, iAxis)));
end

% get leg angle
leg_vec = lhjc - lheel;
leg_ang = atand(leg_vec(:,1)./leg_vec(:,3)); 

% ankle_distance = 108; % mm
% figure('units','normalized','outerposition',[0 0 1 1]);
measures.leg_len = nanmean(sqrt(sum((lhjc(:, [1,2,3])-lank(:, [1,2,3])).^2, 2))); % DIFF: count 3D (model_prediction)
measures.trunk_len = nanmean(sqrt(sum((lhjc(:, [1,2,3])-manub(:, [1,2,3])).^2, 2)));
% plot(trunk_len)

%% Prediction
[measures.A, measures.B, measures.pend_mass] = ...
          initPrediction(measures, ank_dist);
predicted = runPrediction(measures, CoM_x*1000, ank_dist);
%plot(CoM_x)

%% Regression
model = fitlm(CoM_ang, relAngs);
model.Coefficients.Estimate(2);
% mean(relAngs)

%% Plotting
figure('units','normalized','outerposition',[0 0 1 1]);
subplot(2,3,1); 
plot(CoM_ang, relAngs); hold on;
plot(CoM_ang, ones(length(CoM_ang),1)*nanmean(relAngs)); grid on;
title('Trunk-Pelvis Angle');
subplot(2,3,2); 
plot(pelvis_ang-nanmean(pelvis_ang)); hold on;
plot((predicted.pelvis_ang - nanmean(predicted.pelvis_ang)),'--'); grid on;
title('Pelvis Angle');
subplot(2,3,3); 
plot(leg_ang-nanmean(leg_ang)); hold on;
plot((predicted.leg_ang - nanmean(predicted.leg_ang)),'--'); grid on;
title('Leg Angle');
subplot(2,3,4); 
plot(CoM_ang, -trunkAngs); hold on;
plot(CoM_ang, (predicted.pelvis_ang - nanmean(predicted.pelvis_ang))); grid on;
title('Trunk-Pelvis-Earth-Z Angle');
subplot(2,3,5); 
% plot(pelvis_ang-nanmean(pelvis_ang)); hold on;
% plot(-(predicted.pelvis_ang - nanmean(predicted.pelvis_ang)));
plot(x_sho_mid-nanmean(x_sho_mid)); hold on;
plot(predicted.x_shoulder_mid - nanmean(predicted.x_shoulder_mid),'--'); grid on;
title('Shoulder Position');
subplot(2,3,6); 
plot(x_hjc_mid-nanmean(x_hjc_mid)); hold on;
plot(predicted.x_pelvis_mid - nanmean(predicted.x_pelvis_mid),'--'); grid on;
legend('Measured','Predicted');
title('Pelvis Position');

%% To do
% static trials (cannot use double integration)
% 50% (small adjustment: ankle joint)

%% Calculate the worst case (total time)
% 50, 75, 100, 125, 150
% 0.1 hz(10 sec*10 cycles), 0.2 hz(5 sec*10 cycles)
% Provide metronome
% static (cannot use the double integration technique)
% 100+50+10 = 160 seconds / stance width
% 160 * 5 = 800 seconds = 13.3 = (rounded up to) 15 min
% Leg swing (1 min)
% Quiet standing (1 min)
% Total: 15+1+1 = 17 = (rounded up to) 20 min






