function Herder = Herder_NovelNovelModel(t,Herder,Target, howSearch)

global dt P t_search rps thetaps t_dwell Chased

if t < 26
    t_search = t_search + 1;
    [rps(:,t_search), thetaps(:,t_search), Bounds(:,:,t_search), Chased(:,t_search)] = planeSearch_global(t, Target);
else
    if  mod(t,t_dwell) == 0
        t_search = t_search + 1;
        
        %     if (P == 1), [thetaps(:,t_search), rps(:,t_search)] = cart2pol(Target(1).x(1,t) - xstar(1,1), Target(1).x(2,t) - xstar(2,1));     end
        
        switch howSearch
                 case 5
                [rps(:,t_search), thetaps(:,t_search),Chased(:,t_search)] = planeSearch_deep(t,Herder,Target);
        end
        
        
    end
end


Herder(P+1).rps(:,t) = rps(:,t_search);
Herder(P+1).thetaps(:,t) = thetaps(:,t_search);
Herder(P+1).chased(:,t) = Chased(:,t_search);


for p = 1 : P
    
    if Herder(p).theta(1,t) >= 0
        if abs(Herder(p).theta(1,t) - Herder(P+1).thetaps(:,t)) > pi
            if Herder(p).theta(1,t) - Herder(P+1).thetaps(:,t) > 0
                Herder(P+1).thetaps(:,t) = Herder(P+1).thetaps(:,t) -  pi;
            else
                Herder(P+1).thetaps(:,t) = Herder(P+1).thetaps(:,t) +  pi;
            end
        end
    else
        if abs(Herder(p).theta(1,t) - Herder(P+1).thetaps(:,t)) < pi
            if Herder(p).theta(1,t) - Herder(P+1).thetaps(:,t) > 0
                Herder(P+1).thetaps(:,t) =  Herder(P+1).thetaps(:,t) - pi;
            else
                Herder(P+1).thetaps(:,t) = Herder(P+1).thetaps(:,t) + pi;
            end
        end
    end
    
    
    % radial and angular force
    Force(p) = ForceRadial(Herder(p).r(1,t), Herder(P+1).rps(p,t));
    Torque(p) = ForceAngular(Herder(p).theta(1,t),Herder(P+1).thetaps(p,t), Herder(P+1).rps(p,t) - Herder(p).r(1,t));
   
    [Herder(p).r_ddot(1,t), Herder(p).r_dot(1,t)] = HerderDynamics_Radial(Herder(p).r_dot(1,t), Force(p));     %  radial dynamics
    [Herder(p).theta_ddot(1,t), Herder(p).theta_dot(1,t)] = HerderDynamics_Angular(Herder(p).theta_dot(1,t), Torque(p));   %  angular dynamics
    
%     Herder(p).cir_ddot(:,t) = ForceCircumnavigation(Herder(p).y(:,t),Herder(P+1).rps(p,t), Herder(P+1).thetaps(p,t)); 
%     Herder(p).cir_dot(:,t+1) = Herder(p).cir_dot(:,t) + Herder(p).cir_ddot(:,t) * dt; 
%     Herder(p).cir(:,t+1) = Herder(p).cir(:,t) + Herder(p).cir_dot(:,t) * dt; 
%     [Ucir_th, Ucir_r] = cart2pol(Herder(p).cir(1,t),Herder(p).cir(2,t)); 
    
    % Herder state update
    Herder(p).r_dot(1,t+1) = Herder(p).r_dot(1,t) + Herder(p).r_ddot(1,t) * dt;
    Herder(p).r(1,t+1) = Herder(p).r(1,t) + Herder(p).r_dot(1,t) * dt;
    
    Herder(p).theta_dot(1,t+1) = Herder(p).theta_dot(1,t) + Herder(p).theta_ddot(1,t) * dt;
    Herder(p).theta(1,t+1) = Herder(p).theta(1,t) + Herder(p).theta_dot(1,t) * dt;
    
    [Herder(p).y(1,t+1), Herder(p).y(2,t+1)] = pol2cart(Herder(p).theta(1,t+1), Herder(p).r(1,t+1));
    
    
    
end

end

function csi = getXsi(rps)

global rstar

if rps >= rstar
    csi = 1;
else
    csi = 0; 
end

end

function F = ForceRadial(yrpos, rps)

global eps_r rstar delta_rmin

F = eps_r * (yrpos - getXsi(rps) * (rps + rstar) - (1 - getXsi(rps)) * (rstar + delta_rmin));

end

function T = ForceAngular(theta_pos, thetaps, delta_rps)

global eps_theta

T = eps_theta * ((1 - heaviside(delta_rps)) * (theta_pos - thetaps) + heaviside(delta_rps) * (pi - theta_pos - thetaps));  %getXsi(rps) *

end


function [theta_ddot, theta_dot] = HerderDynamics_Angular(theta_vel, T )

global b_theta_S

theta_dot = theta_vel;
theta_ddot = - (b_theta_S * theta_vel + T);
end


function [yr_ddot,yr_dot] = HerderDynamics_Radial(yrvel,F)

global br

yr_dot = yrvel;
yr_ddot = - (br * yrvel + F);

end

function C = ForceCircumnavigation(ypos, rps, thetaps)

U = 1; 
v = 1; 
xps = pol2cart(thetaps,rps); 
Delta_xy = xps - ypos; 
phi = atan2(Delta_xy(2) + ypos(2),Delta_xy(1) + ypos(1));

% C = U * v * (cos(phi/2))^2 * (Delta_xy / norm(Delta_xy)); 

% C = U * cos(Delta_xy)^2;
% C = U * cos(Delta_xy)^2 - ypos; %ish
% C = U * cos(Delta_xy / 2); 
% C = U * cos(Delta_xy / 2) - ypos; 
% C = U * cos((Delta_xy - ypos)/2) ^ 2 * (Delta_xy/abs(Delta_xy)); 

% C(1) = rps + y
% C(2) = pi - theta - thetaps; 

end 


