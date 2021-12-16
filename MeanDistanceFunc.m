function AvgDistance = MeanDistanceFunc(TargetPosX, TargetPosY, steadystate,T_interval, fulltrial)

% Targetnorm = norm(Target(q).x(:,t) - x_goal)      if x_goal = x*
% Targetnorm = norm(Target(q).x(:,t))/norm(Target(Q+1).gcm(:,t))        if x_goal = x_gcm

% steadystate = 0   if containment rate over full trial
% steadystate = 1   if containment rate over last T_interval second of trial

global N T xstar

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
    
    TargetPosX_sum(t) = sum(TargetPosX(:,t));
    TargetPosY_sum(t) = sum(TargetPosY(:,t));
    
    AvgDistance_atTimet(t) = norm(mean([TargetPosX_sum(t); TargetPosY_sum(t)]) - xstar);
    
end

AvgDistance = mean(AvgDistance_atTimet);
% StdErrorDistance = std(AvgDistance_atTimet) / sqrt(N_final - N_start);