function AvgSpreadOfTargets = HerdSpreadFunc(TargetPosX, TargetPosY, steadystate, T_interval, fulltrial) 

% Average herd spread measured by computing the convex hull formed 
% by all of the sheep (the convex hull is defined by the smallest convex polygon that 
% can encompass an entire set of objects)

% TargetPosX(q,:) = Target(q).x(1,:); 
% TargetPosY(q,:) = Target(q).x(2,:); 

% steadystate = 0   if containment rate over full trial 
% steadystate = 1   if containment rate over last T_interval second of trial

global N T 

if steadystate == 0 
    N_start = 1; 
else
    N_start = N * (T - T_interval) / T + 1;
end 

if fulltrial == 1
    N_final = N; 
else 
    N_final = T_interval; 
end 


for t = N_start : N_final
    
    [~,SpreadOfTargetsTrend(t)] = convhull(TargetPosX(:,t), TargetPosY(:,t), 'simplify', true);  
    
end

AvgSpreadOfTargets = mean(SpreadOfTargetsTrend); 
% StdErrorSpreadOfTargets = std(SpreadOfTargetsTrend) / sqrt(N_final); 





