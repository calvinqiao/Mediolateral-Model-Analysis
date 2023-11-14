function CoM_x = get_double_com(folderpath, trial_num)
% GET_DOUBLE_COM  Calculates center of mass in x direction.
%   COM_X = GET_DOUBLE_COM(FOLDERPATH, TRIAL_NUM) calculates center of mass in
%   x direction from a subeject (FOLDERPATH) in a TRIAL_NUM by its .forces
%   file, and resize its length.
% 
%   See also LOADTORQUE, DOUBLEINTEGRATOR.

    dt = 1/2000;
    filepath = strcat(folderpath, 'Trial', num2str(trial_num), '.forces');
    tor_info = loadTorque(filepath);
    fx1 = tor_info.FX1; fx2 = tor_info.FX2; fx = fx1+fx2;
    fz1 = tor_info.FZ1; fz2 = tor_info.FZ2;
    mass = mean(fz1 + fz2) / 9.809; % Vancouver gravity

    copx1 = tor_info.X1; copx2 = tor_info.X2;
    copx = copx1.*(fz1./(fz1+fz2)) + copx2.*(fz2./(fz1+fz2));
    copx = copx / 1000;
    fx = fx - mean(fx); copx = copx - mean(copx);
    fc = 10; fs = 100; % low pass filter fx
    [b,a] = butter(2, fc / (fs / 2));
    filtfilt(b, a, fx);
    [CoM_x] = doubleIntegrator(copx, fx, mass, dt);
    CoM_x = downsample(CoM_x, 20) * 1000;

    % trim for new data
    height = size(CoM_x, 1);
    if (height >= 12000)
        CoM_x(12001:end, :) = [];
    elseif (height > 10000)
        CoM_x(10001:end, :) = [];
    elseif (height > 5000)
        CoM_x(5001:end, :) = [];
    end
end
