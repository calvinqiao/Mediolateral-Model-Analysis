clear; clc; close all;

folder = '../../../data/MLBAL03/';
trial_num = 5:25;
width = zeros(length(trial_num), 1);

for i = 1:length(trial_num)
    width(i) = get_stance_width(folder, trial_num(i));
end

figure; hold on;
plot(trial_num, width);
expected_width = repelem([0.50, 0.75, 1.00, 1.25, 1.50, 1.75, 2.00], 3);
plot(trial_num, expected_width);
xlabel('trial number');
ylabel('width');
legend('calculated', 'expected');
folder(end) = [];
[~, subject] = fileparts(folder);
title(subject);
hold off;
