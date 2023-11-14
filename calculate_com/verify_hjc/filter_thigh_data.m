function thigh_data = filter_thigh_data(thigh_raw, low, high)
% Filter out thigh raw data to only count left-to-right leg movement

    s = size(thigh_raw);
    assert(s(2) == 3);
    
    % Extract x-values from thigh_raw
    x_values = thigh_raw(:, 1);
    
    % Create logical index for values within the specified range
    index = (x_values >= low) & (x_values <= high);
    
    % Filter thigh_raw based on the logical index
    thigh_data = thigh_raw(index, :);
end
