clc; clear; close all;

folder = '../../data/MLBAL03/';
static_trial = 4;
trials = [5, 6, 8, 9, 11, 12, 14, 15, 17, 18, 20, 21, 23, 24];
% [5, 6, 8, 9, 11, 12, 14, 15, 17, 18, 20, 21, 23, 24] % MLBAL01
% [6, 7, 9, 10, 12, 13, 15, 16, 18, 19, 21, 22, 24, 25] % MLBAL02, 03

comparison_graph(folder, static_trial, 9);

% for i = 1:length(trials)
%    comparison_graph(folder, static_trial, trials(i));
% end
