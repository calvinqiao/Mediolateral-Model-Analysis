% clc; clear; close all;


x = [50, 100, 150, 200];
y = flip(-[-1.2913, -0.7855, 0.0569, -0.7405;
           -1.3186, -0.6276, -0.0583, -0.9046;
           -1.5675, -0.9659, -0.2201, -0.8;
           -1.3956, -0.9670, -0.4260, -0.7843]);

% std_dev = std(y);
% curve1 = mean(y) + std_dev;
% curve2 = mean(y) - std_dev;
% x2 = [x, fliplr(x)];
% inBetween = [curve1, fliplr(curve2)];
% figure;
% fill(x2, inBetween, 'g'); hold on;
plot(x, flip(mean((y))) ,'LineWidth', 2); grid on;
% scatter(x, flip(y))


%% To do
% (1) Lab list email the study (SimPL; Calvin Kuo)
% (2) After a week, post on campus
% Aftr 5-10 people, make sure there are no risk concernts;
% then, reach out to patients.
% Mike (tell Candy)
% Ethics documents ready 
% Check static results; 50% marker (only use ones outside)

%% Calculate the worst case (total time)
% 50, 75, 100, 125, 150
% 0.1 hz(10 sec*10 cycles), 0.2 hz(5 sec*10 cycles)
% static (2 sec * 5 angles)
% 100+50+10 = 160 seconds / stance width
% 160 * 5 = 800 seconds = 13.3 = (rounded up to) 15 min
% Leg swing (1 min)
% Quiet standing (1 min)
% Total: 15+1+1 = 17 = (rounded up to) 20 min

%% Functional HJC
% 

