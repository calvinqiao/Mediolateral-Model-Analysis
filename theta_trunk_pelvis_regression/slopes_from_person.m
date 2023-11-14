function [slopes_stance_array, amplitudes_stance_array, widths] = ...
    slopes_from_person(folderpath, effec_trials, stances, static_trial_num)
% SLOPES_FROM_PERSON  Gets all slopes from a subject.
%   SLOPES_STANCE_ARRAY = SLOPES_FROM_PERSON(FOLDERPATH, EFFEC_TRIALS, STANCES,
%   STATIC_TRIAL_NUM) gets all regression slopes of theta_vertical vs theta_com
%   from a subject (FOLDERPATH) and return an array where first row stores the
%   stance, second array stores corresponding slopes.
% 
%   See also SLOPE_FROM_TRIAL.

    assert(length(effec_trials) == length(stances));
    slopes_stance_array.trunk_angle_rel = zeros(14, 2);
    slopes_stance_array.trunk_angle_abs = zeros(14, 2);
    slopes_stance_array.pelvis_angle = zeros(14, 2);
    amplitudes_stance_array.trunk_angle_rel = zeros(14, 2);
    amplitudes_stance_array.trunk_angle_abs = zeros(14, 2);
    amplitudes_stance_array.pelvis_angle = zeros(14, 2);
    widths = zeros(14, 1);
    
    for i = 1:length(effec_trials)
        [slopes, amplitudes, width] = ...
            slope_from_trial(folderpath, static_trial_num, effec_trials(i));
        widths(i) = width;

        slopes_stance_array.trunk_angle_rel(i, 1) = stances(i);
        slopes_stance_array.trunk_angle_rel(i, 2) = slopes.trunk_angle_rel;

        slopes_stance_array.trunk_angle_abs(i, 1) = stances(i);
        slopes_stance_array.trunk_angle_abs(i, 2) = slopes.trunk_angle_abs;

        slopes_stance_array.pelvis_angle(i, 1) = stances(i);
        slopes_stance_array.pelvis_angle(i, 2) = slopes.pelvis_angle;

        amplitudes_stance_array.trunk_angle_rel(i, 1) = stances(i);
        amplitudes_stance_array.trunk_angle_rel(i, 2) = amplitudes.trunk_angle_rel;

        amplitudes_stance_array.trunk_angle_abs(i, 1) = stances(i);
        amplitudes_stance_array.trunk_angle_abs(i, 2) = amplitudes.trunk_angle_abs;

        amplitudes_stance_array.pelvis_angle(i, 1) = stances(i);
        amplitudes_stance_array.pelvis_angle(i, 2) = amplitudes.pelvis_angle;
    end
end
