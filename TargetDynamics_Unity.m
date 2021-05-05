function [xddot, xdot] = TargetDynamics_Unity(xpos, xvel, ypos, param_val)

switch param_val
    
    case 1 % unity / aamas
        
        brownMagnitude = 1.2;
        brownDamping = 0.25;
        
    case 2 % pnas
        
        brownMagnitude = 0.12;
        brownDamping = 0;
        
end



[isRepulsed, repulsiveMotion] = addedRepulsion(xpos, ypos, param_val);

if isRepulsed
    
    randomDirection = 2 * rand(2,1) - 1;
    randomMagnitude = brownMagnitude * brownDamping;
    randomMotion = randomDirection * randomMagnitude;
    
else
    
    randomDirection = 2 * rand(2,1) - 1;
    randomMagnitude = brownMagnitude;
    randomMotion = randomDirection * randomMagnitude;
    
end



xdot = xvel;
xddot = randomMotion + repulsiveMotion;


end

function [isRepulsed, repulsiveMotion] = addedRepulsion(xpos, ypos, param_val)

global P

isRepulsed = 0;
repulsiveDirection = zeros(2,1);

switch param_val
    
    case 1 % unity
        
        repulsiveCutoff = 2; %default is 2
        repulsiveMagnitude = 3.6; %default is 3.6;
        
    case 2 % pnas
        
        repulsiveCutoff = 2;  %default is 0.12
        repulsiveMagnitude = 0.36;
end



for p = 1 : P
    
    relDist = xpos - ypos(:,p);
    
    if norm(relDist) < repulsiveCutoff
        
        repulsiveDirection = repulsiveDirection + (relDist / norm(relDist)) * (repulsiveCutoff / norm(relDist));
        isRepulsed = 1;
    end
    
end

repulsiveMotion = repulsiveDirection * repulsiveMagnitude;


end


