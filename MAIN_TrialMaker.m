% main script to run TrialNumberTot(2) numerical simulations of multi-agent herding task 

clear all; close all; warning('off','all');

TrialNumberTot = [1 2];        % [startValue endValue]
HowDivisionTot = [1 6];         % [Value] | [startValue endValue] (1-Gloabl 2-Static 3-LeaderFollower 4-Peer2Peer 5-Novice inspired 6-Expert inspired)
DwellTimesTot = 50;             % [Value] | [startValue endValue] 
TargetNumber = 7;   % total number of target agents
HerderNumber = 3;   % total number of herder agents 

Func_TrialsMaker(TrialNumberTot,TargetNumber,HerderNumber,HowDivisionTot,DwellTimesTot);

% % Uncomment the next line to run N simulations for each combination of TargetNumber and RepulMultiplier
% % TargetNumberTot = [startValue endValue]
% % RepulMultiplierTot = [startValue endValue]
% % Func_TrialsRobustness(TrialNumberTot,TargetNumberTot,RepulMultiplierTot,HowDivisionTot)

% Optionally, compute performace metrics directly after numerical simulations
MAIN_MetricsMaker;

load(['Metrics/Metrics_',num2str(TargetNumber),'T_',num2str(HerderNumber),'H.mat'])
disp(['max gathering time is ', num2str(max(metrics(HowDivisionTot(1)).table.metrics_deltaTime)), ' seconds'])
disp(['mean gathering time is ', num2str(mean(metrics(HowDivisionTot(1)).table.metrics_deltaTime)), ' seconds'])



function Func_TrialsMaker(TrialNumberTot,TargetNumber,HerderNumber,HowDivisionTot,DwellTimesTot)

if length(DwellTimesTot) == 1
    Param_Initialization(TargetNumber,HerderNumber,DwellTimesTot,0)
    if length(HowDivisionTot) == 1
        howSearch = HowDivisionTot;
        parfor TrialNumber = TrialNumberTot(1) : TrialNumberTot(2)
            Func_Simulation(TrialNumber,TargetNumber,HerderNumber,howSearch,DwellTimesTot)
        end
    else
        for howSearch = HowDivisionTot(1) : HowDivisionTot(2)
            for TrialNumber = TrialNumberTot(1) : TrialNumberTot(2) %% re-add par
                Func_Simulation(TrialNumber,TargetNumber,HerderNumber,howSearch,DwellTimesTot)
            end
        end
    end
else
    for DwellTime = DwellTimesTot(1): 1 :DwellTimesTot(2)
        Param_Initialization(TargetNumber,HerderNumber,DwellTime,0)
        if length(HowDivisionTot) == 1
            howSearch = HowDivisionTot;
            parfor TrialNumber = TrialNumberTot(1) : TrialNumberTot(2)
                Func_Simulation(TrialNumber,TargetNumber,HerderNumber,howSearch,DwellTimesTot)
            end
        else
            for howSearch = HowDivisionTot(1) : HowDivisionTot(2)
                parfor TrialNumber = TrialNumberTot(1) : TrialNumberTot(2)
                    Func_Simulation(TrialNumber,TargetNumber,HerderNumber,howSearch,DwellTimesTot)
                end
            end
        end
    end
end


end





