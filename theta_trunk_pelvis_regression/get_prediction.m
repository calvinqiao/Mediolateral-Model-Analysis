function [predicted_old, predicted_new] = get_prediction(measures, CoM_x, ankle_distance, f)
% GET_PREDICTION  Calculates body movements from body data and center of mass.
%   [PREDICTED_OLD, PREDICTED_NEW] = GET_PREDICTION(MEASURES, COM_X,
%   ANKLE_DISTANCE, F) predicts legs and pelvis angles, shoulder and pelvis
%   movement in x direction from subject's real-time CoM_x, ANKLE_DISTANCE and
%   regression function F (F is the function of stance width, sin(f(w) *
%   theta_com). Prediction are made based on both old and theta_vert regression
%   models.
% 
%   See also NEW_MODEL.

    n_frames = length(CoM_x);
    fullStates_old = zeros(n_frames, 6);
    init_leg_ang = asin((ankle_distance - measures.HJC_distance)/(2 * measures.leg_len));
    
    predicted_old = struct();
    
    for i = 1:n_frames
        % Old model
        x_pend = CoM_x(i);
        
        % judging if stance is 100%
        if abs(ankle_distance - measures.HJC_distance) < 0.01
            pelvis_ang = 0;
            top = measures.pend_mass * x_pend;
            bottom = 2 * measures.leg_mass * measures.leg_CoM + ...
                     measures.pelvis_mass * measures.leg_len + measures.trunk_mass*measures.leg_len;
            leg_ang = asin(top / bottom);
        else
            C = -x_pend * measures.pend_mass; 
            delta_leg_ang = (-measures.B + sqrt(measures.B^2 - 4 * measures.A * C))...
                            / (2 * measures.A);             
            leg_ang = init_leg_ang + delta_leg_ang;
            pelvis_ang = (measures.HJC_distance - ankle_distance) ...
                        / (measures.HJC_distance + ankle_distance) * delta_leg_ang;
        end
        
        % Pelvis top location & shoulder top location
        x_pelvis_mid = (sin(leg_ang) * measures.leg_len +... 
                cos(pelvis_ang) * measures.HJC_distance / 2) - ankle_distance / 2;
        x_shoulder_mid = sin(leg_ang) * measures.leg_len ...
                    + cos(pelvis_ang) * measures.HJC_distance / 2 ...
                    + measures.trunk_len * sin(pelvis_ang) - ankle_distance / 2;
 
        fullStates_old(i, 2) = leg_ang;
        fullStates_old(i, 3) = pelvis_ang;
        % fullStates_old(i, 4) = pelvis_ang2;
        fullStates_old(i, 5) = x_pelvis_mid;
        fullStates_old(i, 6) = x_shoulder_mid;
    end

    predicted_old.leg_ang = rad2deg(fullStates_old(:, 2));
    predicted_old.pelvis_ang = rad2deg(fullStates_old(:, 3));
    % predicted_old.pelvis_ang2 = rad2deg(fullStates_old(:, 4));
    predicted_old.x_pelvis_mid = fullStates_old(:, 5);
    predicted_old.x_shoulder_mid = fullStates_old(:, 6);

    % New Model
    predicted_new = new_model(measures, CoM_x, ankle_distance, f);    
end

function predicted_new = new_model(measures, CoM_x, ankle_distance, f)
% NEW_MODEL  predicts subject's movement using new model.
%   PREDICTED_NEW = NEW_MODEL(MEASURES, COM_X, ANKLE_DISTANCE, F) uses same
%   arguments as above, but a new model to construct the equation and solve to
%   subject's movements.

    % initialization
    n_frames = length(CoM_x);
    fullStates_new = zeros(n_frames, 6);
    predicted_new = struct();

    % coefficients
    m_leg = measures.leg_mass;
    m_hip = measures.pelvis_mass;
    m_tru = measures.trunk_mass;
    l_cl = measures.leg_CoM;
    l_l = measures.leg_len;
    l_p = measures.pelvis_CoM;
    l_h = measures.HJC_distance;
    l_u = measures.trunk_CoM;
    w = ankle_distance / measures.HJC_distance * 100;
    d_a = ankle_distance;
    alpha = (l_h - d_a) / (l_h + d_a);
    m_pend = measures.pend_mass;

    delta_theta_l = zeros(n_frames, 1);
    % diff = zeros(n_frames, 1);
    % t = zeros(n_frames, 1);

    for i = 1:n_frames
        % real-time parameters
        x_pend = CoM_x(i);
        theta_com = x_pend / measures.com_length;
        theta_vert = f(w) * theta_com + pi / 2;

        % calculate coefficients
        A = m_leg * l_cl * l_h / (2 * l_l) * alpha ^ 2 + m_hip * l_h / 4 * alpha ^ 2 ...
            + m_tru * l_h / 4 * alpha ^ 2 + m_tru * cos(theta_vert) * alpha ^ 2 * l_u;
        B = 2 * m_leg * l_cl + m_hip * l_l - m_hip * alpha * l_p + m_tru * l_l ...
            + m_tru * sin(theta_vert) * alpha * l_u;
        C = -x_pend * m_pend + cos(theta_vert) * m_tru * l_u;

        % solve for delta_theta_l
        delta_theta_l(i) = (-B + sqrt(B^2 - 4 * A * C)) / (2 * A);

        % finish calculation for things we need
        leg_ang = asin((ankle_distance - measures.HJC_distance) / (2 * measures.leg_len)) + delta_theta_l(i);
        pelvis_ang = alpha * delta_theta_l(i);
        theta_t = pi / 2 - (theta_vert - pelvis_ang);
        % diff(i) = pelvis_ang - theta_t;
        % temp(i) = theta_t;

        x_pelvis_mid = (sin(leg_ang) * l_l + ...
                cos(pelvis_ang) * l_h / 2) - d_a / 2;
        x_shoulder_mid = l_l * sin(leg_ang) ...
                    + l_h / 2 * cos(pelvis_ang) ...
                    + measures.trunk_len * sin(theta_t) - d_a / 2;
 
        fullStates_new(i, 2) = leg_ang;
        fullStates_new(i, 3) = pelvis_ang;
        % fullStates_old(i, 4) = pelvis_ang2;
        fullStates_new(i, 5) = x_pelvis_mid;
        fullStates_new(i, 6) = x_shoulder_mid;
    end

    predicted_new.leg_ang = rad2deg(fullStates_new(:, 2));
    predicted_new.pelvis_ang = rad2deg(fullStates_new(:, 3));
    % predicted_new.pelvis_ang2 = rad2deg(fullStates_new(:, 4));
    predicted_new.x_pelvis_mid = fullStates_new(:, 5);
    predicted_new.x_shoulder_mid = fullStates_new(:, 6);
end
