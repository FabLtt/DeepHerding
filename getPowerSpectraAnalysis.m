function Classification = getPowerSpectraAnalysis(TargetNumber,RepulMultiplier,TrialNumberTot,HowDivisionTot,paramTrue,tf)

if paramTrue == 1
    %     load('Parameters\params.mat');
    load(['Parameters/param_',num2str(TargetNumber),'_',num2str(RepulMultiplier),'.mat']);
    
    global T N
    T = tf;         % simulation total time
    N = T / dt;
    
else
    
    %     global T N dt xstar rstar Q P
    %
    %     dt = 0.006;         % fixedDeltaTime
    %     T = 15; %30 * 4;         % simulation total time
    %     N = T / dt;         % number of steps
    %
    %     Q = 7;                      % number of target    7
    %     P = 2;                      % number of herder    3
    %     xstar = zeros(2,1);        % goal position initialization
    %     rstar = 1;                  % radius of goal region
    
end

N_interval = floor(T / dt); % 45 for T = 60 | 84 for T = 120
T_interval = floor(T / 2); 
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
        case 5 % search strategy DEEP NN %
            howSearch_val = 'Deep';
    end
    
    cont_successfull_trials = 0;
    successfull_trials = [];
    cont = 1;
    Herder_data_power_max = [];
    freqHz_max = [];
    
    for TrialNumber = TrialNumberTot(1) : TrialNumberTot(2)
        
        % load data from trialfile 'file_name' %
        %        file_name = ['Trials\',howSearch_val,'\','trial_',num2str(howSearch_val),'_',dwellTimeName,'_',num2str(TrialNumber),'.mat'];
        file_name = ['Trials/',howSearch_val,'/','trial_',howSearch_val,'_',num2str(TrialNumber),'_',num2str(TargetNumber),'_',num2str(RepulMultiplier),'.mat'];
        
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
        
        % discard unsuccessfull trials %
        % a "T" long trial is considered succsessfull only if targets are contained for
        % the "percentage" of last "T_interval" of the trial duration

        [timeIN, timeOUT, deltaTimeIN] = ContainmentTimeFunc(Target_norm, steadystate, T_interval);
        
        timeInitial = floor(timeIN/dt);
        
        
        if 100 - (deltaTimeIN * 100) / T < T
            
            cont_successfull_trials = cont_successfull_trials + 1;
            successfull_trials = [successfull_trials, TrialNumber];
            
            for p = 1 : P
                
                % add 'Classification' field to p-th Herder struct
                Herder(p).Classification = [];
                
                % get angular component of p-th Herder of last T_interval [seconds] of T = 60' simulation
                N_interval = N * (T - T_interval) / T + 1;
                Herder_data(p,:) = Herder(p).theta(1,N_interval:N);
                
                
                % low pass filter at 10 Hz with a 4th order butterworth filter
                f_order = 4;
                f_CutOff = 10;          %Hz
%                 dt = T / N;             %necessary if 'dt' is not saved in the trialfile
                f_SampleRate = 1/dt;    %Hz
                [weight_b,weight_a] = butter(f_order,f_CutOff/(f_SampleRate/2));
                Herder_data_filtered(p,:) = filtfilt(weight_b,weight_a,Herder_data(p,:));
                
                % linearly detrend data
                Herder_data_detrended(p,:) = detrend(Herder_data_filtered(p,:));
                
                % calculate power spectra with Welch enstimate on a
                % window of windows_size samples and overlap_size overlap
                window_size = 512;                  % 512 samples
                window = hanning(window_size);
                overlap_size = window_size / 2;     % 50% overlap
                [Herder_data_power(p,:),freqHz(p,:)] = pwelch(Herder_data_detrended(p,:),window,overlap_size,window_size,f_SampleRate,'power');

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                % find peak frequency according to PN
                % temp(1,:,P) = data_power of p-th herder
                % temp(2,:,P) = freqHz of p-th herder
                temp(:,:,p) = [Herder_data_power(p,:); freqHz(p,:)];
                
                f_lowfilterCutoff = 2;
                [Herder_data_power_max(p,cont), index] = max(temp(1,temp(2,:,p) < f_lowfilterCutoff,p));
                freqHz_max(p,cont) = temp(2,temp(1,:,p) == Herder_data_power_max(p,cont),p);
                
 
                %Herder behaviour classification according to PN
                %Obtain classification. Value > 0 indicate Oscillatory behavior, < 0
                %indicate S&R behavior. The magnitude of value indicate strength of
                %classification.
                f_treshold = 0.5;
                Herder(p).Classification = Herder_data_power_max(p,cont) * (freqHz_max(p,cont) - f_treshold) / abs(freqHz_max(p,cont) - f_treshold);
                Classification(how).HerderBehaviour(p,cont) = Herder(p).Classification;
                
                
                
            end     % for over p herders
            
            Classification(how).PowerEstimate(:,:,cont) = Herder_data_power;
            Classification(how).PowerEstimateMax = Herder_data_power_max';
            Classification(how).FreqHz = freqHz';
            Classification(how).FreqHzMax = freqHz_max';
            
            cont = cont + 1;
            
            
        end
    end
    
    Classification(how).name = howSearch_val;
    Classification(how).cont_successfullTrials = cont_successfull_trials;
    Classification(how).successfullTrials = successfull_trials;
    
    if cont_successfull_trials > 0
        for p = 1 : P
            Classification(how).contCOCtrial(p) = length(Classification(how).HerderBehaviour(p, Classification(how).HerderBehaviour(p,:)>=0));
            Classification(how).contSRtrial(p) = length(Classification(how).HerderBehaviour(p, Classification(how).HerderBehaviour(p,:)<0));
        end
    end
end


save(['Metrics/Metrics_',num2str(TargetNumber),'_',num2str(RepulMultiplier),'.mat'],'Classification','-append');