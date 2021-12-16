function [containmentRate, escapingRate] = ContainmentRateFunc(Target_norm,steadystate,T_interval, fulltrial)

% steadystate = 0   if containment rate over full trial
% steadystate = 1   if containment rate over last T_interval second of trial

global N T rstar 

rstar = 1.05; % to slightly relax the requirement of being in the containment region

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

Q = size(Target_norm,1);

for t = N_start : N_final
    
    trgtsOUT_atTimet(t) = length(Target_norm(Target_norm(:,t) > rstar,t));
    trgtsIN_atTimet(t) = length(Target_norm(Target_norm(:,t) <= rstar,t));
    
end

escapingRate = mean(trgtsOUT_atTimet / Q);
containmentRate = mean(trgtsIN_atTimet / Q);

end