addpath('./double_integration_com/');
addpath('./kinematic_method_com/');

clear; clc; close all;

folderpath = '../../data/MLBAL03/';
trial_num = 17;
% test_trials(folderpath, trial_num);
get_com_length(folderpath, 4);



function test_trials(folderpath, start, final)
% test both single trial or multiple trials
    if nargin == 2
        single_test(folderpath, start);
    else
        multiple_test(folderpath, start, final);
    end
end

function single_test(folderpath, trial_num)
% Test a single Trial with specified trial number

    figure;

    % Calculate real data
    CoMx = KinematicMethod(folderpath, trial_num);
    x = 1:length(CoMx);
    plot(x, CoMx); hold on;

    % calculate using double integration
    CoM_x = get_double_com(folderpath, trial_num);
    
    plot(x, CoM_x); hold on;
    xlabel('Time'); ylabel('Position (mm)');
    legend('Kinematics', 'Integrated CoM');
    grid on; title('Center of Mass in x direction');
    % saveas(gcf, strcat("./com_trial_result_figures/Trial", num2str(trial_num), '.fig'))
end

function multiple_test(folderpath, start_trial, end_trial)
    % Test multiple trials, interval bound inclusive
    figure();

    j = 1;
    start = start_trial;
    final = end_trial;
    width = 6;
    height = ceil((final - start + 1) / width);

    for i = start:final
        CoMx = KinematicMethod(folderpath, trc_file);
        subplot(height, width, j); % Create subplot
        x = 0:0.01:((length(CoMx) - 1) * 0.01);
        plot(x, CoMx.'); xlabel('Time'); ylabel('CoM');
        grid on; title(['Trial ', num2str(i)]); % Set title
        j = j + 1;
    end

    sgtitle(['Center of Mass in x direction for Trials ', num2str(start), ' - ', num2str(final)]);% Set overall title
end
