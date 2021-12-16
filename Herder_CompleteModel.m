function Herder = Herder_CompleteModel(t,Herder,Target, howSearch)

global dt P t_search rps thetaps t_dwell Chased

if t < 26
    t_search = t_search + 1;
    [rps(:,t_search), thetaps(:,t_search), Bounds(:,:,t_search), Chased(:,t_search)] = planeSearch_Global(t, Target);
else
    if  mod(t,t_dwell) == 0
        t_search = t_search + 1;
        
        %     if (P == 1), [thetaps(:,t_search), rps(:,t_search)] = cart2pol(Target(1).x(1,t) - xstar(1,1), Target(1).x(2,t) - xstar(2,1));     end
        
        switch howSearch
            case 1
                [rps(:,t_search), thetaps(:,t_search), Bounds(:,:,t_search), Chased(:,t_search)] = planeSearch_Global(t, Target,Herder);
            case 2
                [rps(:,t_search), thetaps(:,t_search), Bounds(:,:,t_search), Chased(:,t_search)] = planeSearch_Static(t,Target);
            case 3
                [rps(:,t_search), thetaps(:,t_search), Bounds(:,:,t_search), Chased(:,t_search)] = planeSearch_LeaderFollower(t, Herder, Target);
            case 4
                [rps(:,t_search), thetaps(:,t_search), Bounds(:,:,t_search), Chased(:,t_search)] = planeSearch_Peer2Peer(t, Herder, Target);
            case 5
                [rps(:,t_search), thetaps(:,t_search),Chased(:,t_search)] = planeSearch_DeepNovice(t,Herder,Target);       
             case 6
                [rps(:,t_search), thetaps(:,t_search),Chased(:,t_search)] = planeSearch_DeepExpert(t,Herder,Target);     
        end 
    end
end


Herder(P+1).rps(:,t) = rps(:,t_search);
Herder(P+1).thetaps(:,t) = thetaps(:,t_search);
Herder(P+1).chased(:,t) = Chased(:,t_search);


for p = 1 : P
    
    Herder(P+1).thetaps(:,t) = wrapToPi(Herder(P+1).thetaps(:,t));
    
    % radial and angular force
    Force(p) = ForceRadial(Herder(p).r(1,t), Herder(P+1).rps(p,t));
    Torque(p) = ForceAngular(Herder(p).theta(1,t),Herder(P+1).thetaps(p,t),Herder(P+1).rps(p,t));
    RayVanPol(p) = RayleighVanDerPol_Oscillators(Herder(p).theta(1,t), Herder(p).theta_dot(1,t));
    Coupling(p) = CouplingOscillators(Herder, p, t, Herder(P+1).rps(p,t));
    
    Herder(P+1).b_theta_dot(p,t) = AngularDamping(Herder(P+1).b_theta(p,t), Herder(P+1).rps(p,t));
    Herder(P+1).b_theta(p,t+1) = Herder(P+1).b_theta(p,t) + Herder(P+1).b_theta_dot(p,t) * dt;
    
    [Herder(p).r_ddot(1,t), Herder(p).r_dot(1,t)] = HerderDynamics_CompleteModel_Radial(Herder(p).r_dot(1,t), Force(p));     %  radial dynamics
    [Herder(p).theta_ddot(1,t), Herder(p).theta_dot(1,t)] = HerderDynamics_CompleteModel_Angular(Herder(p).theta_dot(1,t), Torque(p), RayVanPol(p), Coupling(p), Herder(P+1).b_theta(p,t));   %  angular dynamics
    
    % Herder state update
    Herder(p).r_dot(1,t+1) = Herder(p).r_dot(1,t) + Herder(p).r_ddot(1,t) * dt;
    Herder(p).r(1,t+1) = Herder(p).r(1,t) + Herder(p).r_dot(1,t) * dt;
    
    Herder(p).theta_dot(1,t+1) = Herder(p).theta_dot(1,t) + Herder(p).theta_ddot(1,t) * dt;
    
    %%%%%%%%%%%
    %     if Herder(p).theta_dot(1,t+1) > 500
    %
    %         Herder(p).theta_dot(1,t+1) = 500;
    %
    %     end
    %%%%%%%%%%%
    
    Herder(p).theta(1,t+1) = Herder(p).theta(1,t) + Herder(p).theta_dot(1,t) * dt;
    
    [Herder(p).y(1,t+1), Herder(p).y(2,t+1)] = pol2cart(Herder(p).theta(1,t+1), Herder(p).r(1,t+1));
    
end

end

function csi = getXsi(rps)

global rstar

if rps > rstar
    csi = 1;
else
    csi = 0;
end

end

function F = ForceRadial(yrpos, rps)

global eps_r rstar delta_rmin

F = eps_r * (yrpos - getXsi(rps) * (rps + rstar) - (1 - getXsi(rps)) * (rstar + delta_rmin));

end

function T = ForceAngular(theta_pos, thetaps, rps)

global eps_theta

T = eps_theta * (theta_pos -  getXsi(rps) *thetaps);

end


function [theta_ddot, theta_dot] = HerderDynamics_CompleteModel_Angular(theta_vel, T, R_VdP, HKB, b_theta)

global dt

theta_dot = theta_vel;
theta_ddot = - (b_theta * theta_vel + T + R_VdP) + HKB + rand(1) * dt;
end


function [yr_ddot,yr_dot] = HerderDynamics_CompleteModel_Radial(yrvel,F)

global br dt

yr_dot = yrvel;
yr_ddot = - (br * yrvel + F) + rand(1) * dt;

end

function R_VdP = RayleighVanDerPol_Oscillators(theta_pos, theta_vel)

global beta gamma

R_VdP = beta * theta_vel^2 + gamma * theta_pos ^ 2 * theta_vel;

end

function HKB = CouplingOscillators(Herder, p, t, rps)

global A B

if p == 1
    theta_pos = Herder(1).theta(1,t);
    theta_vel = Herder(1).theta_dot(1,t);
    theta_pos_other = Herder(2).theta(1,t);
    theta_vel_other = Herder(2).theta_dot(1,t);
end

if p == 2
    theta_pos = Herder(2).theta(1,t);
    theta_vel = Herder(2).theta_dot(1,t);
    theta_pos_other = Herder(1).theta(1,t);
    theta_vel_other = Herder(1).theta_dot(1,t);
end

HKB = (1 - getXsi(rps)) * (theta_vel - theta_vel_other) * (A + B * (theta_pos - theta_pos_other)^2);


end

function b_theta_dot = AngularDamping(b_theta, rps)

global delta rstar delta_rmin

b_theta_dot = - delta * (b_theta - (rps - (rstar + delta_rmin))); 

end

