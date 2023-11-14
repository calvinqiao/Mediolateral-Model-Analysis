function [hjc_left, hjc_right, pelvis_com] = HJCEstimation(motions)
% HJCESTIMATION  calculates hip join center movements.
%	[HJC_LEFT, HJC_RIGHT, PELVIS_COM] = HJCESTIMATION(MOTIONS) calcualtes hip
%	joint center (HJC) movements of a subject in a trial with markers data from
%	MOTIONS from relative to absolute coordinates and output left HJC, right HJC,
% 	and pelvis center of mass movements in 3-D.
%
% 	See also FRAME.

	l_psisx = motions.LPSIS; l_psisy = motions.VarName37; l_psisz = motions.VarName38;
	r_psisx = motions.RPSIS; r_psisy = motions.VarName31; r_psisz = motions.VarName32;
	l_asisx = motions.LASIS; l_asisy = motions.VarName43; l_asisz = motions.VarName44;
	r_asisx = motions.RASIS; r_asisy = motions.VarName40; r_asisz = motions.VarName41;
	l_psis = [l_psisx l_psisy l_psisz];
	r_psis = [r_psisx r_psisy r_psisz];
	mid_psis = (l_psis + r_psis) / 2;
	l_asis = [l_asisx l_asisy l_asisz];
	r_asis = [r_asisx r_asisy r_asisz];
	mid_asis = (l_asis + r_asis) / 2;

	% pelvis_width = horizontal dist between the 2 asis markers
	pelvis_width = abs(mean(l_asisx - r_asisx, 'omitnan'));
	% pelvis_depth = forward-backward dist betwen right asis-psis or left
	% asis-psis
	pelvis_depth = mean([abs(mean(l_asisy - l_psisy, 'omitnan'));
					abs(mean(r_asisy - r_psisy, 'omitnan'))], 'omitnan');
	% leg_len  = dist between right malleolus marker and right asis marker
	r_malleolus_z = motions.VarName74;
	l_malleolus_z = motions.VarName113;
	leg_len = mean([abs(mean(r_malleolus_z - r_asisz, 'omitnan'));
				abs(mean(l_malleolus_z - l_asisz, 'omitnan'))], 'omitnan');

	% Harrington method estimates xhat, yhat, zhat based on manually-measured
	% pelvis depth / width and leg length.
	yhat = -0.24 * pelvis_depth - 9.9;
	zhat = -0.16 * pelvis_width - 0.04 * leg_len - 7.1;
	xhat = 0.28 * pelvis_depth + 0.16 * pelvis_width + 7.9;
	hjc_dist = xhat * 2;

	% Ref: Prediction of the hip joint centre in adults, children, and patients
	% with cerebral palsy based on magnetic resonance imaging
	% xhat = 90; yhat = -10; zhat = -40; hjc_dist = 2 * xhat;

	hjc_left = zeros(length(mid_asis), 3);
	hjc_right = zeros(length(mid_asis), 3);
	pelvis_com = zeros(length(mid_asis), 3);

	for i = 1:length(mid_asis)
		this_asis_right = r_asis(i, :);
		this_asis_mid = mid_asis(i, :);
		this_psis_mid = mid_psis(i, :);
		x = this_asis_right - this_asis_mid;
		y = this_asis_mid - this_psis_mid;
		z = cross(x,y); 
		x = x / norm(x); y = y / norm(y); z = z / norm(z);
		
		thisT = frame(x, y, z, this_asis_mid);
		this_hjc_left = [-xhat, yhat, zhat];
		this_hjc_right = [xhat, yhat, zhat];
		this_hjc_left = [this_hjc_left, 1];
		this_hjc_left = (thisT * this_hjc_left')';
		this_hjc_left(:, 4) = [];
		this_hjc_right = [this_hjc_right, 1];
		this_hjc_right = (thisT * this_hjc_right')';
		this_hjc_right(:, 4) = [];

		this_pelvis_CoM = [0,  yhat,  zhat-hjc_dist * 0.105];
		this_pelvis_CoM = [this_pelvis_CoM, 1];
		this_pelvis_CoM = (thisT * this_pelvis_CoM')';
		this_pelvis_CoM(:, 4) = [];
		
		hjc_left(i, :) = this_hjc_left;
		hjc_right(i, :) = this_hjc_right;
		pelvis_com(i, :) = this_pelvis_CoM;			
	end
end
