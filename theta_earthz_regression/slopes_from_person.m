function slopes_stance_array = slopes_from_person(folderpath, effec_trials, stances, static_trial_num)
% SLOPES_FROM_PERSON  Gets all slopes from a subject.
%   SLOPES_STANCE_ARRAY = SLOPES_FROM_PERSON(FOLDERPATH, EFFEC_TRIALS, STANCES,
%   STATIC_TRIAL_NUM) gets all regression slopes of theta_t vs theta_com from
%   a subject (FOLDERPATH) and return an array where first row stores the
%   stance, second array stores corresponding slopes.
% 
%   See also SLOPE_FROM_TRIAL.

    assert(length(effec_trials) == length(stances));
    slopes_stance_array = zeros(14, 2);

    for i = 1:length(effec_trials)
        slope = slope_from_trial(folderpath, static_trial_num, effec_trials(i));
        slopes_stance_array(i, 1) = stances(i);
        slopes_stance_array(i, 2) = slope;
    end
end
    