function [predicted] = runPrediction(measures, CoM_x, ankle_distance) % m represents measures
    n_frames = length(CoM_x);
    fullStates = zeros(n_frames, 6); % fullStates(:, 1) = pendAngles;
    init_leg_ang = asin((ankle_distance-measures.HJC_distance)/(2*measures.leg_len));
    
    for i = 1:n_frames
        % pendDeg = -pendAngles(i);
        x_pend = CoM_x(i); 
        % xPend = sind(pendDeg)*measures.pendLength;

        if abs(ankle_distance-measures.HJC_distance) < 0.01
            pelvis_ang = 0; % pelvis_ang2 = 0; 
            top = measures.pend_mass*x_pend;
            bottom = 2*measures.leg_mass*measures.leg_CoM + ...
                     measures.pelvis_mass*measures.leg_len + measures.trunk_mass*measures.leg_len;
            leg_ang = asin(top/bottom);
        else
            C = -x_pend * measures.pend_mass; 
            delta_leg_ang = (-measures.B + sqrt(measures.B^2 - 4*measures.A*C))...
                            / (2*measures.A);             
            leg_ang = init_leg_ang + delta_leg_ang; 
            % pelvis_ang = leg2PelvisAng(measures, leg_ang, ankle_distance);
            pelvis_ang = (measures.HJC_distance-ankle_distance)/(measures.HJC_distance+ankle_distance)*delta_leg_ang;
        end

        
        %% Pelvis top location & shoulder top location
        x_pelvis_mid = (sin(leg_ang)*measures.leg_len +... 
                cos(pelvis_ang)*measures.HJC_distance/2) - ankle_distance/2;
        x_shoulder_mid = sin(leg_ang)*measures.leg_len ...
                    + cos(pelvis_ang)*measures.HJC_distance/2 ...
                    + measures.trunk_len*sin(pelvis_ang) - ankle_distance/2; 
        %%      
        fullStates(i, 2) = leg_ang; 
        fullStates(i, 3) = pelvis_ang;
%         fullStates(i, 4) = pelvis_ang2; 
        fullStates(i, 5) = x_pelvis_mid; 
        fullStates(i, 6) = x_shoulder_mid;
        
    end
    predicted.leg_ang = rad2deg(fullStates(:,2)); 
    predicted.pelvis_ang = rad2deg(fullStates(:,3)); 
%     predicted.pelvis_ang2 = rad2deg(fullStates(:,4));  
    predicted.x_pelvis_mid = fullStates(:,5);  
    predicted.x_shoulder_mid = fullStates(:,6);  
end
% plot(CoM_x) plot(predicted.x_pelvis_mid) plot(predicted.pelvis_ang)

