clear all; close all; warning('off','all');

TrialNumberTot = [1 2];        % [startValue endValue]
HowDivisionTot = [1 5];         % [Value] | [startValue endValue] (1-Gloabl 2-Static 3-LeaderFollower 4-Peer2Peer 5-Deep)
DwellTimesTot = 50;             % [Value] | [startValue endValue]

TargetNumber = 7;
HerderNumber = 3;

Func_TrialsMaker(TrialNumberTot,TargetNumber,HerderNumber,HowDivisionTot,DwellTimesTot);

RepulMultiplier = 20; paramTrue = 1; tf = 120;
MAIN_MetricsMaker;
Classification = getPowerSpectraAnalysis(TargetNumber,RepulMultiplier,TrialNumberTot,HowDivisionTot,paramTrue,tf);

load(['Metrics\Metrics_',num2str(TargetNumber),'_',num2str(RepulMultiplier),'.mat'])

disp(['successful trials are ', num2str( metrics(HowDivisionTot(1)).cont_successfullTrials)])
disp(['max gathering time is ', num2str(max(metrics(HowDivisionTot(1)).table.metrics_deltaTime)), ' seconds'])
disp(['mean gathering time is ', num2str(mean(metrics(HowDivisionTot(1)).table.metrics_deltaTime)), ' seconds'])



function Func_TrialsMaker(TrialNumberTot,TargetNumber,HerderNumber,HowDivisionTot,DwellTimesTot)

RepulMultiplier = 20; %default value: 20

if length(DwellTimesTot) == 1
    
    Param_Initialization(TargetNumber,HerderNumber,DwellTimesTot,RepulMultiplier)
    
    if length(HowDivisionTot) == 1
        
        howSearch = HowDivisionTot;
        
        parfor TrialNumber = TrialNumberTot(1) : TrialNumberTot(2)
            
            Func_Simulation(TrialNumber,TargetNumber,RepulMultiplier,howSearch,DwellTimesTot)
        end
        
    else
        
        for howSearch = HowDivisionTot(1) : HowDivisionTot(2)
            
            for TrialNumber = TrialNumberTot(1) : TrialNumberTot(2)
                
                Func_Simulation(TrialNumber,TargetNumber,RepulMultiplier,howSearch,DwellTimesTot)
                
            end
        end
        
    end
    
       
else 
    
    for DwellTime = DwellTimesTot(1): 1 :DwellTimesTot(2)
        
        Param_Initialization(TargetNumber,HerderNumber,DwellTime,RepulMultiplier)
        
        if length(HowDivisionTot) == 1
            
            howSearch = HowDivisionTot;
            
            parfor TrialNumber = TrialNumberTot(1) : TrialNumberTot(2)
                
                Func_Simulation(TrialNumber,TargetNumber,RepulMultiplier,howSearch,DwellTimesTot)
            end
            
        else
            
            for howSearch = HowDivisionTot(1) : HowDivisionTot(2)
                
                parfor TrialNumber = TrialNumberTot(1) : TrialNumberTot(2)
                    
                    Func_Simulation(TrialNumber,TargetNumber,RepulMultiplier,howSearch,DwellTimesTot)
                    
                end
            end
            
        end
        
    end
    
end


end





