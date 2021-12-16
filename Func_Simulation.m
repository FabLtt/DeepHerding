function Func_Simulation(TrialNumber,TargetNumber,HerderNumber,howSearch,~)
% main function to initialize and simulate target and herder agents

load(['Parameters/param_',num2str(TargetNumber),'T_',num2str(HerderNumber),'H.mat']);

Target = Target_Initialization(Q,N);
Herder = Herder_Initialization(P,N);

% set TargetType to select the type of target agents to simulate : 
% 0 - simulate Brownian target agents, 
% 1 - simulate target agents as used in Rigoli, Lillian M., et al. "Employing Models of Human Social Motor 
%                                       Behavior for Artificial Agent Trainers." Proceedings of the 19th 
%                                       International Conference on Autonomous Agents and MultiAgent Systems. 2020., 
% 2 - simulate target agents as used in 10.1073/pnas.1813164116
TargetType = 0;

% simulation loop
for t = 1 : N
    
    
    % Herders are driven by the simplified version of model
    % 10.1073/pnas.1813164116, as presented in https://arxiv.org/abs/2010.00386v2
    Herder = Herder_NovelModel(t,Herder,Target, howSearch);
    
    % Eventually, herders can be driven by the originam model from 10.1073/pnas.1813164116
    %     Herder = Herder_CompleteModel(t,Herder,Target, howSearch);
    
    % Targets
    for q = 1 : Q
        
        if TargetType == 0
            
            %%% "Brownian targets"
            % x_dot = f(x,y)  -- Escaping the herder
            for p = 1 : P
                Target(q).x_dot1_temp = TargetDynamicsRepulsion(Target(q).x(:,t),Herder(p).y(:,t));
                Target(q).x_dot1(:,t)  = Target(q).x_dot1(:,t) + Target(q).x_dot1_temp;
            end
            
            % x_dot = v , v_dot = f(x,v) -- Collision avoidance b/w targets
            cont = 1;
            for q1 = 1 : Q
                if (q1 ~= q)
                    if norm(Target(q).x(:,t) - Target(q1).x(:,t)) < 1
                        cont = cont + 1;
                        Target(q).x_dot2(:,t) = TargetDynamicsCollision(Target(q).x(:,t), Target(q1).x(:,t), Target(Q+1).coll_temp(:,t));
                        Target(Q+1).coll_temp(:,t) = Target(q).x_dot2(:,t);
                    end
                end
            end
            
            % x_dot = f(x,y)  -- Diffusive motion
            Target(q).x_dot3(:,t) =  TargetDynamicsBrownian_EulerMaruyama();
            
            % state update
            Target(q).x_dot(:,t) = Target(q).x_dot1(:,t) + Target(q).x_dot2(:,t)/cont;
            Target(q).x(:,t+1) = Target(q).x(:,t) + Target(q).x_dot(:,t) * dt + Target(q).x_dot3(:,t);
            
            
        else
            
            %%% "Unity targets"
            for p = 1 : P
                ypos(:,p) = Herder(p).y(:,t);
            end
            
            [Target(q).x_dot(:,t), Target(q).x_ddot(:,t)] = TargetDynamics_Unity(Target(q).x(:,t), Target(q).x_dot(:,t), ypos, TargetType);
            Target(q).x_dot(:,t+1) = Target(q).x_dot(:,t) + Target(q).x_ddot(:,t) * dt;
            
            % check on max velocity
            maxTargetVel = 1;
            sqrTargetVel = maxTargetVel ^ 2;
            
            if norm(Target(q).x_dot(:,t)) > sqrTargetVel
                Target(q).x_dot(:,t+1) = (Target(q).x_dot(:,t+1) / norm(Target(q).x_dot(:,t))) * maxTargetVel;
            end
            
            Target(q).x(:,t+1) = Target(q).x(:,t) + Target(q).x_dot(:,t) * dt;
            
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [TargetTH, TargetR] = cart2pol(Target(q).x(1,t+1) - Target(q).x(1,t),Target(q).x(2,t+1) - Target(q).x(2,t));
        
        Target(q).r_dot(1,t+1) = Target(q).r_dot(1,t) + TargetR / dt;
        Target(q).th_dot(1,t+1) = Target(q).th_dot(1,t) + TargetTH / dt;
        
        Target(q).r_ddot(1,t+1) = Target(q).r_ddot(1,t) + Target(q).r_dot(1,t) / dt;
        
        
    end
    
end

%% save files

for q = 1 : Q
    TargetPos(:,:,q) = Target(q).x;
end

for p = 1 : P
    HerderPos(:,:,p) = Herder(p).y;
end

switch howSearch
    case 1  % search strategy GLOBAL %
        howSearch_val = 'Global';
    case 2  % search strategy STATIC %
        howSearch_val = 'Static';
    case 3  % search strategy INDIVIDUAL %
        howSearch_val = 'LeaderFollower';
    case 4  % search strategy COOPERATIVE %
        howSearch_val = 'PeerToPeer';
    case 5  % search strategy NOVICE INSPIRED %
        howSearch_val = 'Novice';
    case 6  % search strategy EXPERT INSPIRED %
        howSearch_val = 'Expert';
end

file_nameTrial = ['Trials/',howSearch_val,'/','trial_',howSearch_val,'_',num2str(TrialNumber),'_',num2str(TargetNumber),'T_',num2str(HerderNumber),'H.mat'];
save(file_nameTrial, 'TargetPos','HerderPos','Herder','Target');
