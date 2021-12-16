function Func_TrialsRobustness(TrialNumberTot,TargetNumberTot,RepulMultiplierTot,HowDivisionTot)

TargetNumberCont = 1;
HerderNumber = 2; 
DwellTime = 50;
isRobustness = 1; 

for TargetNumber = TargetNumberTot(1) : 3 : TargetNumberTot(2)
    
    for RepulMultiplier = RepulMultiplierTot(1) : RepulMultiplierTot(2)
        
        % initialize parameters for all division and trials repetition
        Param_Initialization(TargetNumber,HerderNumber,DwellTime,isRobustness)
        
        for howSearch = HowDivisionTot(1) : HowDivisionTot(2)
            
            parfor TrialNumber = TrialNumberTot(1) : TrialNumberTot(2)
                
                Func_Simulation(TrialNumber,TargetNumber,HerderNumber,howSearch,DwellTime)
                
            end
            
        end
        
        % get average metrics
        MetricsMatrix = getMetrics(TargetNumber,HerderNumber,TrialNumberTot,HowDivisionTot,1,100);
        
        % add average metrics to a metrics
        AverageMetrics_ContTime_Global(TargetNumberCont,RepulMultiplier) = mean(MetricsMatrix(:,1,1));
        AverageMetrics_ContTime_Static(TargetNumberCont,RepulMultiplier) = mean(MetricsMatrix(:,1,2));
        AverageMetrics_ContTime_LeaderFollower(TargetNumberCont,RepulMultiplier) = mean(MetricsMatrix(:,1,3));
        AverageMetrics_ContTime_PeerToPeer(TargetNumberCont,RepulMultiplier) = mean(MetricsMatrix(:,1,4));
        AverageMetrics_ContTime_Novice(TargetNumberCont,RepulMultiplier) = mean(MetricsMatrix(:,1,5));
        AverageMetrics_ContTime_Expert(TargetNumberCont,RepulMultiplier) = mean(MetricsMatrix(:,1,6));

        
        delete(['Parameters/param_',num2str(TargetNumber),'T_',num2str(HerderNumber),'H.mat']);
        
        % delete trials used
        delete('Trials\Global\*.mat');
        delete('Trials\Static\*.mat');
        delete('Trials\PeerToPeer\*.mat');
        delete('Trials\LeaderFollower\*.mat');
        delete('Trials\Novice\*.mat');
        delete('Trials\Expert\*.mat');
        %
    end
    
    TargetNumberCont = TargetNumberCont + 1;
   
end
 
save('AverageContainmentTime.mat','AverageMetrics_ContTime_Global','AverageMetrics_ContTime_LeaderFollower',...
    'AverageMetrics_ContTime_PeerToPeer','AverageMetrics_ContTime_Static',...
    'AverageMetrics_ContTime_Novice','AverageMetrics_ContTime_Expert');