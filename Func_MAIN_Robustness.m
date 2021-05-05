function Func_MAIN_Robustness(TrialNumberTot,TargetNumberTot,ParamTot,HowDivisionTot)

% TrialNumberTot(2) = 10;
% TargetNumberTot(2) = 120;
% ParamTot(2) = 50;
% HowDivisionTot(2) = 4;


% TotParam = ParamTot(2) - ParamTot(1) + 1;
% TotTargets = TargetNumberTot(2) - TargetNumberTot(1) + 1;
% TotTrials = TotParam * TotTargets;
TargetNumberCont = 1;
HerderNumber = 2; 
DwellTime = 50;

for TargetNumber = TargetNumberTot(1) : 3 : TargetNumberTot(2)
    
    for RepulMultiplier = ParamTot(1) : ParamTot(2)
        
        % initialize parameters for all division and trials repetition
        Func_INIT(TargetNumber,HerderNumber,DwellTime,RepulMultiplier)
        
        for how = HowDivisionTot(1) : HowDivisionTot(2)
            
            parfor TrialNumber = TrialNumberTot(1) : TrialNumberTot(2)
                
                Func_MAIN(TrialNumber,TargetNumber,RepulMultiplier,how);
                
            end
            
        end
        
        % get average metrics
        MetricsMatrix = getMetrics(TargetNumber,RepulMultiplier,TrialNumberTot,HowDivisionTot,1,100);
        
        % add average metrics to a metrics
%         AverageMetrics_ContTime_Global(TargetNumberCont,RepulMultiplier) = mean(MetricsMatrix(:,1,1));
%         AverageMetrics_ContTime_Static(TargetNumberCont,RepulMultiplier) = mean(MetricsMatrix(:,1,2));
%         AverageMetrics_ContTime_LeaderFollower(TargetNumberCont,RepulMultiplier) = mean(MetricsMatrix(:,1,3));
%         AverageMetrics_ContTime_PeerToPeer(TargetNumberCont,RepulMultiplier) = mean(MetricsMatrix(:,1,4));
        AverageMetrics_ContTime_Deep(TargetNumberCont,RepulMultiplier) = mean(MetricsMatrix(:,1,5));

        
        delete(['Parameters\param_',num2str(TargetNumber),'_',num2str(RepulMultiplier),'.mat']);
        
        % delete trials used
%         delete('Trials\Global\*.mat');
%         delete('Trials\Static\*.mat');
%         delete('Trials\PeerToPeer\*.mat');
%         delete('Trials\LeaderFollower\*.mat');
        delete('Trials\Deep\*.mat');
        %
    end
    
    TargetNumberCont = TargetNumberCont + 1;
%     
%     disp(['still ',num2str(TotTrials - TargetNumberCont * RepulMultiplier),' / ',num2str(TotTrials),' trials to go!']);
    
end
 
% save('AverageContainmentTime.mat','AverageMetrics_ContTime_Global','AverageMetrics_ContTime_LeaderFollower','AverageMetrics_ContTime_PeerToPeer','AverageMetrics_ContTime_Static');
save('AverageContainmentTime.mat','AverageMetrics_ContTime_Deep');