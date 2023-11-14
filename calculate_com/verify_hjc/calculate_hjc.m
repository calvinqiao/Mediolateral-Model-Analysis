function hjc_from_marker = calculate_hjc()
% Calculate hjc positions from marker data from two static trials

    addpath('../kinematic_method_com/');

    hjc_from_marker = struct();

    % load thigh data
    Trial4 = importfile('../../../Data-0428/MLBAL02/Trial4.trc', [7, Inf]);
    Trial4(:, 165:end) = [];
    Trial5 = importfile('../../../Data-0428/MLBAL02/Trial5.trc', [7, Inf]);
    Trial5(:, 165:end) = [];

    [l_thigh, r_thigh] = get_thigh_avg(Trial4, Trial5);
    [l_thigh, r_thigh] = transform2PelvisLocal(l_thigh, r_thigh, Trial4, Trial5);
    
    % l_thigh = filter_thigh_data(l_thigh, -168.71, -154.90);
    % r_thigh = filter_thigh_data(r_thigh, 164.18, 178.68);

    [center_l, radius_l] = sphereFit(l_thigh);
    [center_r, radius_r] = sphereFit(r_thigh);

    % plot_single_leg(center_l, radius_l, l_thigh, 'Left');
    % plot_single_leg(center_r, radius_r, r_thigh, 'Right');

    hjc_from_marker.hjc_l = center_l;
    hjc_from_marker.hjc_r = center_r;
    [hjc_from_marker.l_max, hjc_from_marker.r_max] = max_rotate_angle(l_thigh, r_thigh, center_l, center_r);
end

function [Center,Radius] = sphereFit(X)
    % this fits a sphere to a collection of data using a closed form for the
    % solution (opposed to using an array the size of the data set). 
    % Minimizes Sum((x-xc)^2+(y-yc)^2+(z-zc)^2-r^2)^2
    % x,y,z are the data, xc,yc,zc are the sphere's center, and r is the radius
    % Assumes that points are not in a singular configuration, real numbers, ...
    % if you have coplanar data, use a circle fit with svd for determining the
    % plane, recommended Circle Fit (Pratt method), by Nikolai Chernov
    % http://www.mathworks.com/matlabcentral/fileexchange/22643
    % Input:
    % X: n x 3 matrix of cartesian data
    % Outputs:
    % Center: Center of sphere 
    % Radius: Radius of sphere
    % Author:
    % Alan Jennings, University of Dayton
    A=[mean(X(:,1).*(X(:,1)-mean(X(:,1)))), ...
        2*mean(X(:,1).*(X(:,2)-mean(X(:,2)))), ...
        2*mean(X(:,1).*(X(:,3)-mean(X(:,3)))); ...
        0, ...
        mean(X(:,2).*(X(:,2)-mean(X(:,2)))), ...
        2*mean(X(:,2).*(X(:,3)-mean(X(:,3)))); ...
        0, ...
        0, ...
        mean(X(:,3).*(X(:,3)-mean(X(:,3))))];
    A=A+A.';
    B=[mean((X(:,1).^2+X(:,2).^2+X(:,3).^2).*(X(:,1)-mean(X(:,1))));...
        mean((X(:,1).^2+X(:,2).^2+X(:,3).^2).*(X(:,2)-mean(X(:,2))));...
        mean((X(:,1).^2+X(:,2).^2+X(:,3).^2).*(X(:,3)-mean(X(:,3))))];
    Center=(A\B).';
    Radius=sqrt(mean(sum([X(:,1)-Center(1),X(:,2)-Center(2),X(:,3)-Center(3)].^2,2)));
end

function plot_single_leg(center, radius, thigh, direction)
% Generate a 3D plot of thigh data and hip joint center
    thigh_x = thigh(:, 1);
    thigh_y = thigh(:, 2);
    thigh_z = thigh(:, 3);

    figure;
    hold on;
    scatter3(thigh_x, thigh_y, thigh_z, 'b'); % Plotting the points
    [X,Y,Z] = sphere;
    X = X * radius;
    Y = Y * radius;
    Z = Z * radius;
    surf(X + center(1), Y + center(2), Z + center(3));
    xlabel('x');
    ylabel('y');
    zlabel('z');
    title(direction);
    grid on;
    view(3);
    plot3(center(1), center(2), center(3), 'ro');
    hold off;
end

function [l_max, r_max] = max_rotate_angle(l_thigh, r_thigh, center_l, center_r)
% Calculate maximum sway angle

    %% Left leg value
    % Extract the y values from the matrix
    y_values = l_thigh(:, 2);
    % Find the row with the maximum y value
    [~, max_y_index] = max(y_values);
    row_with_max_y = l_thigh(max_y_index, :);
    % Find the row with the minimum y value
    [~, min_y_index] = min(y_values);
    row_with_min_y = l_thigh(min_y_index, :);

    u = [0,0,-1]; v = row_with_max_y - center_l;
    CosTheta1 = max(min(dot(u,v)/(norm(u)*norm(v)),1),-1);
    ThetaInDegrees1 = real(acosd(CosTheta1));

    u = [0,0,-1]; v = row_with_min_y - center_l;
    CosTheta2 = max(min(dot(u,v)/(norm(u)*norm(v)),1),-1);
    ThetaInDegrees2 = real(acosd(CosTheta2));
    l_max = max(ThetaInDegrees1, ThetaInDegrees2);

    %% Right Leg Value
    % Extract the y values from the matrix
    y_values = r_thigh(:, 2);
    % Find the row with the maximum y value
    [~, max_y_index] = max(y_values);
    row_with_max_y = r_thigh(max_y_index, :);
    % Find the row with the minimum y value
    [~, min_y_index] = min(y_values);
    row_with_min_y = r_thigh(min_y_index, :);

    u = [0,0,-1]; v = row_with_max_y - center_r;
    CosTheta1 = max(min(dot(u,v)/(norm(u)*norm(v)),1),-1);
    ThetaInDegrees1 = real(acosd(CosTheta1));

    u = [0,0,-1]; v = row_with_min_y - center_r;
    CosTheta2 = max(min(dot(u,v)/(norm(u)*norm(v)),1),-1);
    ThetaInDegrees2 = real(acosd(CosTheta2));
    r_max = max(ThetaInDegrees1, ThetaInDegrees2);
end