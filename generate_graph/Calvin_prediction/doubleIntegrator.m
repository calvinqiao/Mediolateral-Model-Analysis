function [CoM_trace] = doubleIntegrator(CoPx, Fx, mass, dt)
    %% Find the zero crossings of Fx and then split the data
    getZeroCrossings = @(var) find(var(:).*circshift(var(:), [-1, 0]) <= 0);
    zeroCrosses = getZeroCrossings(Fx);
%     figure; plot(Fx);hold on; 
%     plot(zeroCrosses, zeros(size(zeroCrosses)), 'x');
%     xlabel('Sample'); ylabel('Force (N)');
%     title('Zero Crossings');
    
    %% Split the data based on zero crossings
    CoPSegs = {}; FxSegs={}; 
    for i = 1:length(zeroCrosses)+1
        if i == length(zeroCrosses)+1
            CoPSegs{i} = CoPx(zeroCrosses(i-1)+1: end);
            FxSegs{i} =Fx(zeroCrosses(i-1)+1: end);
        elseif i == 1
            CoPSegs{i} = CoPx(1:zeroCrosses(i));
            FxSegs{i} =Fx(1:zeroCrosses(i));
        else
            CoPSegs{i} = CoPx(zeroCrosses(i-1)+1:zeroCrosses(i));
            FxSegs{i} =Fx(zeroCrosses(i-1)+1:zeroCrosses(i));     
        end
    end
    
    %% Double-integrate the Fx to get the position
    CoMSegs = {}; 
    for i = 1:length(CoPSegs)
        CoPSeg = CoPSegs{i}; FxSeg = FxSegs{i};
        timeSeg = 0: dt: dt*(length(FxSeg)-1);
        if isempty(CoPSeg)
            continue;
        elseif length(CoPSeg) == 1 
            % 1 element, only the start point
            % Calling cumtrapz in this condition will produce errors
            CoMSeg = CoPSeg;
        else       
            integral = cumtrapz(timeSeg, cumtrapz(timeSeg, FxSeg/mass));
            v_t0 = (CoPSeg(end) - CoPSeg(1) ...
                - integral(end))/timeSeg(end);
%             v_t0 = (integral(end) - CoPSeg(end))/timeSeg(end);
            CoMSeg = integral + v_t0*timeSeg' + CoPSeg(1);  
        end
        CoMSegs{i} = CoMSeg;
    end
    
    %% Concatenate the CoM segments to get the total trace
    idxStart = 1; CoM_trace = [];
    for i = 1:length(CoMSegs)
        % idx = idxStart:1:(idxStart+length(CoMSegs{i})-1);
        CoM_trace = [CoM_trace; CoMSegs{i}];
        idxStart = idxStart+length(CoMSegs{i})-1;
    end
    
    %% Plot the final CoM trace compared to the CoP trace
%     figure; plot(CoM_trace); hold on; plot(CoPx); 
%     xlabel('Sample'); ylabel('Position (m)');
%     legend('Integrated CoM', 'CoP');
%     title('Trace Plot');
    
end