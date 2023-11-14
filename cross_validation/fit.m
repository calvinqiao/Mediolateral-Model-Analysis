function model = fit(folders, static_trials, effec_trials_all, ...
                     FITTING_MODE, fold_i)
% FIT  Gets a model from regressing all subjects provided.
%   MODEL = FIT(FOLDERS, STATIC_TRIALS, EFFEC_TRIALSS) fits a MODEL from all
%   subjects (FOLDERS) provided, with specified STATIC_TRIALS and
%   EFFEC_TRIALSS.
% 
%   See also SLOPES_FROM_PERSON.

    addpath('../theta_trunk_pelvis_regression/');

    n = length(folders);
    slopess = zeros(n * 14, 2);
    widthss = zeros(n * 14, 1);

    for i = 1:n
        progressbar((i - 1) / n);
        folderpath = folders{i};
        disp(['Collecting slopes...']);
        disp(folderpath);
        effec_trials = effec_trials_all(i, :);
        static_trial = static_trials(i);
        
        stances = repelem([50, 75, 100, 125, 150, 175, 200], 2);
        [slopes, ~, widths] = slopes_from_person(folderpath, effec_trials, stances, static_trial);
        slopess((i - 1) * 14 + 1 : (i - 1) * 14 + 14, :) = slopes.trunk_angle_rel;
        widthss((i - 1) * 14 + 1 : (i - 1) * 14 + 14, 1) = widths;
    end

    slopess = meanOfTwoRows(slopess); % compress the slopes so one stance from a subject only gives one slop
    widthss = meanOfTwoRows(widthss);
    do_plot(widthss, slopess(:, 2), fold_i);
    
    model = struct();
    if strcmp(FITTING_MODE, '2nd-order')
        p = polyfit(widthss, slopess(:, 2), 2);
        [B, info] = lasso([x x.^2],y);
        [~,ind] = min(info.Intercept); %round(size(B,2)*3/4);
        p = zeros(3,1);
        Bselect = B(:,ind); interp = info.Intercept(ind);
        p(1) = Bselect(1); p(2) = Bselect(2); p(3) = interp; 
        model.eq = @(x) p(1) * x.^2 + p(2) * x + p(3);
    end
    if strcmp(FITTING_MODE, '1st-order')
        p = polyfit(widthss, slopess(:, 2), 1);
        model.eq = @(x) p(1) * x + p(2);
    end
    model.coeff = p;
    save_model(model, "temp/", 3);
end

function do_plot(x, y, fold_i)
    check = isnan(x);
    x(check) = []; y(check) = [];
    % Perform linear regression
    
    coefficients = polyfit(x, y, 2); % Fit a first-degree polynomial (line)

    % Generate points for the regression line
    % xLine = min(x):max(x);
    yLine = polyval(coefficients, x);

    % Calculate R^2
    yMean = mean(y);
    yFit = polyval(coefficients, x);
    SSres = sum((y - yFit).^2);
    SStotal = sum((y - yMean).^2);
    rSquared = 1 - SSres / SStotal;

    [B, info] = lasso([x x.^2],y);
    [~,ind] = min(info.Intercept); %round(size(B,2)*3/4);
    Bselect = B(:,ind); interp = info.Intercept(ind);
    ytil = interp+...
        x.*Bselect(1)+x.^2.*Bselect(2);
    % Plot the data points and regression line
    figure;
    plot(x, y, 'o', 'MarkerSize', 8); % Plot data points as circles
    hold on;
    % plot(x, yLine, 'r*', 'LineWidth', 2); % Plot regression line
    plot(x, ytil, 'r*');
    hold off;

    % Add labels and title
    xticks([50, 75, 100, 125, 150, 175, 200]);
    xlabel('x'); ylabel('y');
    title('Regression');
    legend('Data', 'Regression');
    % 
    % Display R^2 on the graph
    % text(max(x), max(y), sprintf('R^2 = %.4f', rSquared), 'HorizontalAlignment', 'right');
    saveas(gcf, strcat('Fold-', num2str(fold_i), '_regression_plot.png'));
    close;
    % figure;
    % y= y'; x = x';
    % sigma = nanstd(y); curve1 = y + sigma; curve2 = y - sigma;
    % x2 = [x, fliplr(x)]; inBetween = [curve1, fliplr(curve2)];
    % fill(x2, inBetween, 'k','FaceAlpha',0.2,'LineStyle','none'); hold on;
    % plot(x, y, 'k', 'LineWidth', 4);
    % xticks([50, 75, 100, 125, 150, 175, 200]);
    % title('Trunk-Pelvis Angle w.r.t. CoM Angle Change Rate');  
    % set(gca,'FontSize',22); grid on;
    % saveas(gcf, 'regression_average_plot.fig');
end
