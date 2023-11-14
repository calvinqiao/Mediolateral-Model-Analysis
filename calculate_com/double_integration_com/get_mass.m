function mass = get_mass(folderpath, trial_num)
% GET_MASS  Calculates subject's mass.
%   MASS = GET_MASS(FOLDERPATH, TRIAL_NUM) calculates a subject's (FOLDERPATH)
%   based on it's force data from a TRIAL_NUM and Vancouver's gravity.
% 
%   See also LOADTORQUE.

    filepath = strcat(folderpath, 'Trial', num2str(trial_num), '.forces');
    tor_info = loadTorque(filepath);
    fz1 = tor_info.FZ1; fz2 = tor_info.FZ2;
    mass = mean(fz1 + fz2) / 9.809; % Vancouver gravity
end
