function [A, B, pendMass] = initPrediction(measures, ankle_distance)
    pendMass = 0.971*measures.mass; 
    
    A = ((measures.HJC_distance-ankle_distance)/(measures.HJC_distance+ankle_distance))^2 ...
        * measures.HJC_distance/2 ...
        * (measures.leg_CoM/measures.leg_len*measures.leg_mass+...
        measures.pelvis_mass/2+measures.trunk_mass/2);
    
    B = 2*measures.leg_mass*measures.leg_CoM ...
        + measures.pelvis_mass*(measures.leg_len-...
        (measures.HJC_distance-ankle_distance)/...
        (measures.HJC_distance+ankle_distance)*measures.pelvis_CoM) ...
        + measures.trunk_mass*(measures.leg_len+...
        (measures.HJC_distance-ankle_distance)/(measures.HJC_distance+ankle_distance)...
        *measures.trunk_CoM);
end