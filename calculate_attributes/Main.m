addpath('../calculate_com/kinematic_method_com/');

clear; clc; close all;

trial_num = 6;

markers = importfile(strcat('../../data/MLBAL03/Trial', num2str(trial_num),'.csv'));
real = real_attributes(markers);
plot(real.vertical_angles);
