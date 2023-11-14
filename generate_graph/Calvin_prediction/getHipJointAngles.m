
clc; clear; close all;
% Try getting the torque directly; need to try this
% mass = 85;
% tor_info = loadTorque('Trial36.forces'); % which one is left? 1 is left?
% fx1 = tor_info.FX1; fx2 = tor_info.FX2; fx = fx1+fx2;
% fz1 = tor_info.FZ1; fz2 = tor_info.FZ2; 
% copx1 = tor_info.X1; copx2 = tor_info.X2; 
% copx = copx1.*(fz1./(fz1+fz2)) + copx2.*(fz2./(fz1+fz2));
% copx = copx/1000;
% % plot(copx) plot(fx)
% 
% fx = fx - mean(fx); 
% copx = copx - mean(copx);
% 
% dt = 1/2000;
% [CoMx] = doubleIntegrator(copx, fx, mass, dt);

motions = load3D_table('Trial9.trc'); %9 13 24
l_psisx = motions.LPSIS; l_psisy = motions.VarName31; l_psisz = motions.VarName32;
r_psisx = motions.RPSIS; r_psisy = motions.VarName34; r_psisz = motions.VarName35;
l_asisx = motions.LASIS; l_asisy = motions.VarName43; l_asisz = motions.VarName44;
r_asisx = motions.RASIS; r_asisy = motions.VarName37; r_asisz = motions.VarName38;
l_psis = [l_psisx l_psisy l_psisz];
r_psis = [r_psisx r_psisy r_psisz];
mid_psis = (l_psis + r_psis)/2;
l_asis = [l_asisx l_asisy l_asisz];
r_asis = [r_asisx r_asisy r_asisz];
mid_asis = (l_asis + r_asis)/2;

% pelvis_width
% pelvis_depth
% leg_length Check which markers are used for getting the leg length (Jesse)
% Harrington estimate dx, dy, dz
% yhat = -0.24*pelvisDepthMeasured - 9.9;
% zhat = -0.16*pelvisWidthMeasured - 0.04*legLenMeasured - 7.1;
% xhat = 0.28*pelvisDepthMeasured + 0.16*pelvisWidthMeasured + 7.9;
xhat = 90; yhat = -10; zhat = -40; hjc_dist = 210;

hjc_left = zeros(length(mid_asis), 3); hjc_right = zeros(length(mid_asis), 3);
for i = 1:length(mid_asis)
        this_asis_right = r_asis(i, :);
        this_asis_mid = mid_asis(i, :);
        this_psis_mid = mid_psis(i, :);
        x = this_asis_right - this_asis_mid;
        y = this_asis_mid - this_psis_mid;
        z = cross(x,y); 
        x = x/norm(x); y = y/norm(y); z = z/norm(z);
        
        thisT = frame(x, y, z, this_asis_mid);
        this_hjc_left = [-xhat, yhat, zhat];
        this_hjc_right = [xhat, yhat, zhat];
        this_hjc_left = [this_hjc_left, 1];
        this_hjc_left = (thisT*this_hjc_left')';
        this_hjc_left(:, 4) = [];
        this_hjc_right = [this_hjc_right, 1];
        this_hjc_right = (thisT*this_hjc_right')';
        this_hjc_right(:, 4) = [];
        
        hjc_left(i, :) = this_hjc_left;
        hjc_right(i, :) = this_hjc_right;
end

hjc_vec = hjc_left - hjc_right;
pelvis_ang = atand(hjc_vec(:,3)./hjc_vec(:,1));
plot(pelvis_ang-nanmean(pelvis_ang)); hold on;

psis_vec = l_psis - r_psis;
p_ang1 = atand(psis_vec(:,3)./psis_vec(:,1));
plot(p_ang1-mean(p_ang1)); hold on;

% plot(l_asisx - mean(l_asisx))




