function [TimeFirstIn, TimeFirstOut, DeltaTimeIn] = ContainmentTimeFunc(Target_norm, steadystate, T_interval)

% steadystate = 0   if containment rate over full trial 
% steadystate = 1   if containment rate over last T_interval second of trial

global N T rstar delta_rmin

if steadystate == 0 
    N_start = 1; 
else
    N_start = N * (T - T_interval) / T + 1;
end 

% firstIN = 0; 
% firstOUT = 0; 

cont_in = 0; 
cont_out = 0; 

dt = T / N; 

for t = N_start : N

%     if Target_norm(:,t) < rstar & firstIN == 0 % if all targets are inside the desired region for the first time 
%         TimeFirstIn = t * dt;
% %             disp(num2str(timeIN)); 
%         firstIN = 1; 
%     elseif Target_norm(:,t) > rstar & firstOUT == 0 & firstIN == 1 % if all targets escape desired region after been be contained
%         TimeFirstOut = t* dt; 
% %             disp(num2str(timeOUT)); 
%         firstOUT = 1; 
%     end 

    if Target_norm(:,t) < rstar 
        if cont_in == 0
            TimeFirstIn = t * dt; 
        end 
        cont_in = cont_in + 1; 
    else 
        if cont_in > 1 
            TimeFirstOut = t * dt; 
        end 
        cont_out = cont_out + 1; 
    end 
 
end 

DeltaTimeIn = cont_in * dt; 

% if exist('TimeFirstIn','var') && exist('TimeFirstOut','var') 
% %     disp(num2str(timeOUT - timeIN)); 
%     DeltaTimeIn = TimeFirstOut - TimeFirstIn;
% elseif exist('TimeFirstIn','var') && ~exist('TimeFirstOut','var') 
% %     disp(num2str(T - timeIN));
%     TimeFirstOut = T; 
%     DeltaTimeIn = T - TimeFirstIn;
% else
if ~exist('TimeFirstIn','var')
    DeltaTimeIn = 0;
    TimeFirstIn = T; 
    TimeFirstOut = T; 
end
if ~exist('TimeFirstOut','var')
TimeFirstOut = T; 
end 

