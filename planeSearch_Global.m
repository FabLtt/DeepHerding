function [rps_P, thetaps_P, Bounds, chsd] = planeSearch_Global(t, Target, Herder)

global Q P xstar

Bounds = [];

for q = 1 : Q
    Target_pos(:,q) = Target(q).x(:,t) - xstar;
    [Target_angle(q), Target_norm(q)] = cart2pol(Target_pos(1,q), Target_pos(2,q));
    for p = 1 : P 
        HerderTargetDist(q,p) = norm(Herder(p).y(:,t) - Target(q).x(:,t));
    end 
end

[~, index_farthest] = sort(Target_norm, 'descend');

for p = 1 : P 
    rps_P(p) = Target_norm(index_farthest(p)); 
    thetaps_P(p) = Target_angle(index_farthest(p)); 
    chsd(p) = index_farthest(p);
end

