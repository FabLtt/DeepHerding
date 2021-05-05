function LenghtTrajectory = DistanceTravelledFunc(AgentPos, steadystate, N_interval, fulltrial)

% steadystate = 0   if containment rate over full trial 
% steadystate = 1   if containment rate over last T_interval second of trial

global N T 

if steadystate == 0 
    N_start = 1; 
else
    N_start = N * (T - N_interval) / T + 1;
end 

if fulltrial == 1
    N_final = N; 
else 
    N_final = N_interval; 
end 

    
AgentPosShifted = (circshift(AgentPos(:,N_start:N_final), -1, 2)); 
TrajectoryPieces = vecnorm(AgentPos(:,N_start:N_final) - AgentPosShifted, 2, 1);
TrajectoryPieces = TrajectoryPieces(1,1:length(TrajectoryPieces)-1);
LenghtTrajectory = sum(TrajectoryPieces); 