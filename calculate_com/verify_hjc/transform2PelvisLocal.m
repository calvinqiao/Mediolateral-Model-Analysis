function [local_lthigh, local_rthigh] = transform2PelvisLocal(global_lthigh,global_rthigh, Trial4, Trial5)
% Transform local thigh data from (some) reference to global coordinates
%% WARNINGS: no longer useful, New experiement doesn't do this

	markers = Trial5;

	l_psisx = markers.LPSIS; l_psisy = markers.VarName37; l_psisz = markers.VarName38;
	r_psisx = markers.RPSIS; r_psisy = markers.VarName31; r_psisz = markers.VarName32;
	l_asisx = markers.LASIS; l_asisy = markers.VarName43; l_asisz = markers.VarName44;
	r_asisx = markers.RASIS; r_asisy = markers.VarName40; r_asisz = markers.VarName41;

	l_psis = [l_psisx l_psisy l_psisz];
	r_psis = [r_psisx r_psisy r_psisz];
	mid_psis = (l_psis + r_psis) / 2;
	l_asis = [l_asisx l_asisy l_asisz];
	r_asis = [r_asisx r_asisy r_asisz];
	mid_asis = (l_asis + r_asis) / 2;

	local_lthigh = zeros(length(mid_asis), 3); 
	for i = 1:length(global_lthigh)
		this_asis_right = r_asis(i, :);
		this_asis_mid = mid_asis(i, :);
		this_psis_mid = mid_psis(i, :);
		x = this_asis_right - this_asis_mid;
		y = this_asis_mid - this_psis_mid;
		z = cross(x,y); 
		x = x / norm(x); y = y / norm(y); z = z / norm(z);
		
		thisT = frame(x, y, z, this_asis_mid);
        R = thisT(1:3, 1:3); t = thisT(1:3, 4);
        thisT(1:3, 1:3) = R'; thisT(1:3, 4) = -R'*t;
        
		this_lthigh_global = [global_lthigh(i, :), 1];
		this_lthigh_local = (thisT * this_lthigh_global')';
		this_lthigh_local(:, 4) = [];
		local_lthigh(i, :) = this_lthigh_local;
	end
    
    clear markers;
    
    markers = Trial4;

	l_psisx = markers.LPSIS; l_psisy = markers.VarName37; l_psisz = markers.VarName38;
	r_psisx = markers.RPSIS; r_psisy = markers.VarName31; r_psisz = markers.VarName32;
	l_asisx = markers.LASIS; l_asisy = markers.VarName43; l_asisz = markers.VarName44;
	r_asisx = markers.RASIS; r_asisy = markers.VarName40; r_asisz = markers.VarName41;

	l_psis = [l_psisx l_psisy l_psisz];
	r_psis = [r_psisx r_psisy r_psisz];
	mid_psis = (l_psis + r_psis) / 2;
	l_asis = [l_asisx l_asisy l_asisz];
	r_asis = [r_asisx r_asisy r_asisz];
	mid_asis = (l_asis + r_asis) / 2;
    
    local_rthigh = zeros(length(mid_asis), 3);
    for j = 1:length(global_rthigh)
		this_asis_right = r_asis(j, :);
		this_asis_mid = mid_asis(j, :);
		this_psis_mid = mid_psis(j, :);
		x = this_asis_right - this_asis_mid;
		y = this_asis_mid - this_psis_mid;
		z = cross(x,y); 
		x = x / norm(x); y = y / norm(y); z = z / norm(z);
		
		thisT = frame(x, y, z, this_asis_mid);
        R = thisT(1:3, 1:3); t = thisT(1:3, 4);
        thisT(1:3, 1:3) = R'; thisT(1:3, 4) = -R'*t;
        
        this_rthigh_global = [global_rthigh(j, :), 1];
		this_rthigh_local = (thisT * this_rthigh_global')';
		this_rthigh_local(:, 4) = [];
		local_rthigh(j, :) = this_rthigh_local;		
    end
end
