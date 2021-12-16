TrialNumberTot = [1 2];        % [startValue endValue]
HowDivisionTot = [1 6];         % [Value] | [startValue endValue] (1-Gloabl 2-Static 3-LeaderFollower 4-Peer2Peer 5-Novice inspired 6-Expert inspired)
DwellTimesTot = 50;             % [Value] | [startValue endValue]

TargetNumber = 7;   % total number of target agents
HerderNumber = 3;   % total number of herder agents 

paramTrue = 1;  % 0 - set simulation parameters | 1 - read parameters from file   
tf = 120;       % end time of the simulation by which computing metrics

% get Metrics and Averages

if length(DwellTimesTot) == 1
   
    dwellTimeName = num2str(DwellTimesTot);
    
    MetricsMatrix = getMetrics(TargetNumber,HerderNumber,TrialNumberTot,HowDivisionTot,paramTrue,tf);
    
    for how = HowDivisionTot(1) : HowDivisionTot(2)
        
        AverageMetrics_ContTime(how) = mean(MetricsMatrix(:,1,how));
        AverageMetrics_ContRate(how) = mean(MetricsMatrix(:,2,how));
        AverageMetrics_Spread(how) = mean(MetricsMatrix(:,3,how));  %normalized
        AverageMetrics_Distance(how) = mean(MetricsMatrix(:,5,how));
        AverageMetrics_DistanceTravelled(how) = mean(MetricsMatrix(:,6,how));
        AverageMetrics_FirstTime(how) = mean(MetricsMatrix(:,7,how));
        AverageMetrics_DistanceTravelled_toFirstIn(how) = mean(MetricsMatrix(:,8,how));
        AverageMetrics_Spread_toFirstIn(how) = mean(MetricsMatrix(:,9,how));
        AverageMetrics_ContRate_toFirstIn(how) = mean(MetricsMatrix(:,10,how));
        AverageMetrics_Distance_toFirstIn(how) = mean(MetricsMatrix(:,11,how));
        
    end
    
    
    
else
    
    for DwellTimesCont = DwellTimesTot(1): 1 :DwellTimesTot(2)
        
        dwellTimeName = num2str(DwellTimesTot(DwellTimesCont));
        
        MetricsMatrix = getMetrics(TargetNumber,HerderNumber,TrialNumberTot,HowDivisionTot,paramTrue,tf);
        
        for how = HowDivisionTot(1) : HowDivisionTot(2)
            
            AverageMetrics_ContTime(how,DwellTimesCont) = mean(MetricsMatrix(:,1,how));
            AverageMetrics_ContRate(how,DwellTimesCont) = mean(MetricsMatrix(:,2,how));
            AverageMetrics_Spread(how,DwellTimesCont) = mean(MetricsMatrix(:,3,how));  %normalized
            AverageMetrics_Distance(how,DwellTimesCont) = mean(MetricsMatrix(:,5,how));
            AverageMetrics_DistanceTravelled(how,DwellTimesCont) = mean(MetricsMatrix(:,6,how));
            AverageMetrics_FirstTime(how,DwellTimesCont) = mean(MetricsMatrix(:,7,how));
            AverageMetrics_DistanceTravelled_toFirstIn(how,DwellTimesCont) = mean(MetricsMatrix(:,8,how));
            AverageMetrics_Spread_toFirstIn(how,DwellTimesCont) = mean(MetricsMatrix(:,9,how));
            AverageMetrics_ContRate_toFirstIn(how,DwellTimesCont) = mean(MetricsMatrix(:,10,how));
            AverageMetrics_Distance_toFirstIn(how,DwellTimesCont) = mean(MetricsMatrix(:,11,how));
            
        end
        
    end
    
end

AveragesTaskDivisions = table(AverageMetrics_ContTime,AverageMetrics_ContRate,AverageMetrics_Spread,AverageMetrics_Distance,AverageMetrics_DistanceTravelled, AverageMetrics_FirstTime,AverageMetrics_DistanceTravelled_toFirstIn, AverageMetrics_Spread_toFirstIn, AverageMetrics_ContRate_toFirstIn,AverageMetrics_Distance_toFirstIn);

save(['Metrics/Averages_',num2str(TargetNumber),'T_',num2str(HerderNumber),'H.mat'],'AveragesTaskDivisions');
