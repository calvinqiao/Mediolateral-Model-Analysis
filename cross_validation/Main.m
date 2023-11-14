clear; clc; close all; tic;

w = warning ('off','all');
% folders = {'null', '../../data/MLBAL01/', '../../data/MLBAL03/', '../../data/MLBAL04/', ...
%            '../../data/MLBAL05/', '../../data/MLBAL06/', '../../data/MLBAL07/', ...
%            '../../data/MLBAL08/', '../../data/MLBAL10/', ...
%            '../../data/MLBAL13/', '../../data/MLBAL14/', ...
%            '../../data/MLBAL15/', '../../data/MLBAL16/', '../../data/MLBAL17/', ...
%            '../../data/MLBAL18/', '../../data/MLBAL19/', '../../data/MLBAL20/', ...
%            '../../data/MLBAL21/'};
% effec_trials = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1;
%                 5, 6, 8, 9, 11, 12, 14, 15, 17, 18, 20, 21, 23, 24;
%                 6, 7, 9, 10, 12, 13, 15, 16, 18, 19, 21, 22, 24, 25;
%                 6, 5, 8, 9, 12, 11, 14, 15, 17, 18, 20, 21, 23, 24;
%                 6, 5, 9, 8, 11, 12, 14, 15, 18, 17, 20, 21, 23, 24;
%                 5, 4, 7, 8, 10, 11, 14, 13, 16, 17, 19, 20, 22, 23;
%                 5, 6, 9, 8, 12, 11, 14, 15, 18, 17, 21, 20, 23, 24;
%                 6, 5, 8, 9, 12, 11, 15, 14, 18, 17, 20, 21, 24, 23;
%                 6, 5, 9, 8, 11, 12, 14, 15, 17, 18, 21, 20, 23, 24;
%                 6, 5, 9, 8, 11, 12, 14, 15, 17, 18, 21, 20, 24, 23;
%                 5, 6, 9, 8, 11, 12, 14, 15, 17, 18, 21, 20, 23, 24;
%                 5, 6, 9, 8, 11, 12, 14, 15, 18, 17, 20, 21, 24, 23;
%                 6, 5, 8, 9, 12, 11, 14, 15, 17, 18, 20, 21, 24, 23;
%                 5, 6, 8, 9, 12, 11, 14, 15, 18, 17, 20, 21, 24, 23;
%                 6, 5, 8, 9, 11, 12, 14, 15, 17, 18, 21, 20, 23, 24;
%                 5, 6, 8, 9, 12, 11, 14, 15, 17, 18, 20, 21, 23, 24;
%                 5, 6, 8, 9, 12, 11, 15, 14, 17, 18, 21, 20, 23, 24;
%                 5, 6, 8, 9, 12, 11, 14, 15, 18, 17, 21, 20, 23, 24;
%                 ];
% static_trials = [-1, 3, 4, 4, ...
%                  4, 25, 4, ...
%                  4, 4, ...
%                  4, 4, ...
%                  4, 4, 4, ...
%                  4, 4, 4, ...
%                  4];

folders = {'../../data/MLBAL01/', '../../data/MLBAL03/', '../../data/MLBAL04/'};
effec_trials = [5, 6, 8, 9, 11, 12, 14, 15, 17, 18, 20, 21, 23, 24;
                6, 7, 9, 10, 12, 13, 15, 16, 18, 19, 21, 22, 24, 25;
                6, 5, 8, 9, 12, 11, 14, 15, 17, 18, 20, 21, 23, 24;];
static_trials = [3, 4, 4];

folders = {'../../data/MLBAL01/', '../../data/MLBAL03/', ...
           '../../data/MLBAL04/', '../../data/MLBAL05/', ...
           '../../data/MLBAL06/', '../../data/MLBAL07/', ...
           '../../data/MLBAL08/', '../../data/MLBAL10/', ...
           '../../data/MLBAL11/', '../../data/MLBAL12/', ...
           '../../data/MLBAL13/', '../../data/MLBAL14/', ...
           '../../data/MLBAL15/', '../../data/MLBAL16/', ...
           '../../data/MLBAL17/', '../../data/MLBAL18/', ...
           '../../data/MLBAL19/', '../../data/MLBAL20/', ...
           '../../data/MLBAL21/', '../../data/MLBAL02/'};
effec_trials = [5, 6, 8, 9, 11, 12, 14, 15, 17, 18, 20, 21, 23, 24;
                6, 7, 9, 10,12, 13, 15, 16, 18, 19, 21, 22, 24, 25;
                6, 5, 8, 9, 12, 11, 14, 15, 17, 18, 20, 21, 23, 24;
                6, 5, 9, 8, 11, 12, 14, 15, 18, 17, 20, 21, 23, 24;
                5, 4, 7, 8, 10, 11, 14, 13, 17, 17, 19, 20, 22, 23;
                5, 6, 9, 8, 12, 11, 14, 15, 18, 17, 20, 20, 23, 24;
                6, 5, 8, 9, 12, 11, 15, 14, 18, 17, 20, 21, 24, 23;
                6, 5, 9, 8, 11, 12, 14, 15, 17, 18, 21, 20, 23, 24;
                6, 7, 9, 10,12, 13, 16, 15, 19, 18, 23, 22, 25, 26;
                6, 5, 8, 9, 11, 12, 15, 14, 18, 17, 21, 20, 25, 24;
                6, 5, 9, 8, 11, 12, 14, 15, 17, 18, 21, 20, 24, 23;
                5, 6, 9, 8, 11, 12, 14, 15, 17, 18, 21, 20, 23, 24;
                5, 6, 9, 8, 11, 12, 14, 15, 18, 17, 20, 21, 24, 23;
                6, 5, 8, 9, 12, 11, 14, 15, 17, 18, 20, 21, 24, 23;
                5, 6, 8, 9, 12, 11, 14, 15, 18, 17, 20, 21, 24, 23;
                6, 5, 8, 9, 11, 12, 14, 15, 17, 18, 21, 20, 23, 24;
                5, 6, 8, 9, 12, 11, 14, 15, 17, 18, 20, 21, 23, 24;
                5, 6, 8, 9, 12, 11, 15, 14, 17, 18, 21, 20, 23, 24;
                5, 6, 8, 9, 12, 11, 14, 15, 18, 17, 21, 20, 23, 24;
                6, 6, 9, 10,13, 12, 15, 16, 18, 19, 21, 22, 24, 25];
static_trials = [3, 4, 4, 4, 25, ...
                 4, 4, 4, 4, 4, ....
                 4, 4, 4, 4, 4, ...
                 4, 4, 4, 4, 5];

% [slopess, amplitudess] = get_angular_slopes(folders, static_trials, effec_trials);
% see_slopes_and_amplitudes(slopess, amplitudess)

folder_size = 4;

% i = 3;
% fit(folders(i), static_trials(i), effec_trials(i, :));

[~, errors] = ...
    cross_validate(folders, effec_trials, static_trials, ...
                   folder_size);
disp(errors);

toc;
