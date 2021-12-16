function MetricsMatrix = getMetrics(TargetNumber,HerderNumber,TrialNumberTot,HowDivisionTot,paramTrue,tf)

if paramTrue == 1
    load(['Parameters/param_',num2str(TargetNumber),'T_',num2str(HerderNumber),'H.mat']);

    
    global T N
    T = tf;         % simulation total time
    N = T / dt;
    
else
    
    %     global T N dt xstar rstar Q P
    %
    %     dt = 0.02;         % fixedDeltaTime
    %     T = 30 * 4;         % simulation total time
    %     N = T / dt;         % number of steps
    %
    %     Q = 7;                      % number of target    7
    %     P = 2;                      % number of herder    3
    %     xstar = zeros(2,1);        % goal position initialization
    %     rstar = 1;                  % radius of goal region
    
end

N_interval = floor(T/dt); % 45 for T = 60 | 84 for T = 120
steadystate = 0;


for how = HowDivisionTot(1) : HowDivisionTot(2)
    
    switch how
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
    
    metrics_deltaTime = [];
    metrics_containmentRate = [];
    metrics_spreadNormalized = [];
    metrics_spread = [];
    metrics_distance = [];
    metrics_distanceTravelled = [];
    metrics_FirstTime = [];
    metrics_distanceTravelled_toFirstIn = [];
    metrics_containmentRate_toFirstIn = [];
    metrics_spreadNormalized_toFirstIn = [];
    metrics_distance_toFirstIn = [];
    
    for TrialNumber = TrialNumberTot(1) : TrialNumberTot(2)
        
        % load data from trialfile 'file_name' %
        file_name = ['Trials/',howSearch_val,'/','trial_',howSearch_val,'_',num2str(TrialNumber),'_',num2str(TargetNumber),'T_',num2str(HerderNumber),'H.mat'];
        load(file_name);
        
        if exist('Target','var')         
            for q = 1 : Q
                TargetPos(:,:,q) = real(Target(q).x);
            end
            for q = 1 : P
                HerderPos(:,:,q) = real(Herder(q).y);
            end
        end
        
        % calculate function's arguments
        for q = 1 : Q
            for t = 1 : N
                Target_norm(q,t) = norm(TargetPos(:,t,q) - xstar);
                Target_norm_abs(q,t) = norm(TargetPos(:,t,q));
            end
            TargetPosX(q,:) = TargetPos(1,:,q);
            TargetPosY(q,:) = TargetPos(2,:,q);    
        end
        
        [timeIN, ~, deltaTimeIN] = ContainmentTimeFunc(Target_norm, steadystate, N_interval);
        
        timeInitial = floor(timeIN/dt);
                
        % containment time
        metrics_deltaTime = [metrics_deltaTime; 100 - (deltaTimeIN * 100) / T];
        metrics_FirstTime = [metrics_FirstTime; timeIN];
        
        % containment rate
        [contRate, ~] = ContainmentRateFunc(Target_norm, steadystate, N_interval,1);
        metrics_containmentRate = [metrics_containmentRate; contRate * 100];
        
        [contRate_toFirstIn, ~] = ContainmentRateFunc(Target_norm, steadystate, timeInitial,0);
        metrics_containmentRate_toFirstIn = [metrics_containmentRate_toFirstIn; contRate_toFirstIn * 100];
        
        % heard spread
        herdSpread = HerdSpreadFunc(TargetPosX, TargetPosY, steadystate, N_interval,1);
        herdSpreadNormalized = herdSpread / (pi * rstar^2);
        metrics_spreadNormalized = [metrics_spreadNormalized; herdSpreadNormalized];
        metrics_spread = [metrics_spread; herdSpread];
        
        herdSpread_toFirstIn = HerdSpreadFunc(TargetPosX, TargetPosY, steadystate, timeInitial,0);
        herdSpreadNormalized_toFirstIn = herdSpread_toFirstIn / (pi * rstar^2);
        metrics_spreadNormalized_toFirstIn = [metrics_spreadNormalized_toFirstIn; herdSpreadNormalized_toFirstIn];
        
        % mean distance
        TargetGoalAvgDistance = MeanDistanceFunc(TargetPosX, TargetPosY,steadystate,N_interval,1);
        metrics_distance = [metrics_distance; TargetGoalAvgDistance];
        
        TargetGoalAvgDistance_toFirstIn = MeanDistanceFunc(TargetPosX, TargetPosY,steadystate,timeInitial,0);
        metrics_distance_toFirstIn = [metrics_distance_toFirstIn; TargetGoalAvgDistance_toFirstIn];
        
        % Distance travelled by each herder
        for p = 1 : P
            LenghtTrajectory(p) = DistanceTravelledFunc(HerderPos(:,:,p), steadystate, N_interval, 1);
        end
        metrics_distanceTravelled = [metrics_distanceTravelled; mean(LenghtTrajectory)];
        
        for p = 1 : P
            LenghtTrajectory_toFirstIn(p) = DistanceTravelledFunc(HerderPos(:,:,p), steadystate, timeInitial, 0);
        end
        metrics_distanceTravelled_toFirstIn = [metrics_distanceTravelled_toFirstIn; mean(LenghtTrajectory_toFirstIn)];
            
    end
    
    
    MetricsMatrix(:,1,how) = metrics_deltaTime;
    MetricsMatrix(:,2,how) = metrics_containmentRate;
    MetricsMatrix(:,3,how) = metrics_spreadNormalized;
    MetricsMatrix(:,4,how) = metrics_spread;
    MetricsMatrix(:,5,how) = metrics_distance;
    MetricsMatrix(:,6,how) = metrics_distanceTravelled;
    MetricsMatrix(:,7,how) = metrics_FirstTime;
    MetricsMatrix(:,8,how) = metrics_distanceTravelled_toFirstIn;
    MetricsMatrix(:,9,how) = metrics_spreadNormalized_toFirstIn;
    MetricsMatrix(:,10,how) = metrics_containmentRate_toFirstIn;
    MetricsMatrix(:,11,how) = metrics_distance_toFirstIn;
    
    metrics(how).table = table(metrics_deltaTime, metrics_containmentRate, metrics_spreadNormalized, metrics_spread, metrics_distance, metrics_distanceTravelled, metrics_FirstTime, metrics_distanceTravelled_toFirstIn, metrics_spreadNormalized_toFirstIn, metrics_containmentRate_toFirstIn, metrics_distance_toFirstIn);
    metrics(how).name = howSearch_val; 
    
end


save(['Metrics/Metrics_',num2str(TargetNumber),'T_',num2str(HerderNumber),'H.mat'],'metrics');


end