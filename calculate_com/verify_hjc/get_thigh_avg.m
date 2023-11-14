function [l_thigh, r_thigh] = get_thigh_avg(Trial4, Trial5)
% Compute left and right thigh data from data of Trial 4 and 5,
%   left from Trial 5, right from Trial 4

    % left leg data
    l_thigh_x = mean(table2array([Trial5(:, 99), Trial5(:, 102), Trial5(:, 105), Trial5(:, 108)]), 2);
    l_thigh_y = mean(table2array([Trial5(:, 100), Trial5(:, 103), Trial5(:, 106), Trial5(:, 109)]), 2);
    l_thigh_z = mean(table2array([Trial5(:, 101), Trial5(:, 104), Trial5(:, 107), Trial5(:, 110)]), 2);
    l_thigh = [l_thigh_x, l_thigh_y, l_thigh_z];

    % right leg data
    r_thigh_x = mean(table2array([Trial4(:, 45), Trial4(:, 48), Trial4(:, 51), Trial4(:, 54)]), 2);
    r_thigh_y = mean(table2array([Trial4(:, 46), Trial4(:, 49), Trial4(:, 52), Trial4(:, 55)]), 2);
    r_thigh_z = mean(table2array([Trial4(:, 47), Trial4(:, 50), Trial4(:, 53), Trial4(:, 56)]), 2);
    r_thigh = [r_thigh_x, r_thigh_y, r_thigh_z];
end
