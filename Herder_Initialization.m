function Herder = Herder_Initialization(HerderNumber, TotalTimesteps)

% Initialize an array of "HerderNumber" struct of fields
% and assign initial polar (and cartesian) initial around a fixed radial distance from the centre of the environment

global rstar

InitialRadius = 6 * rstar; 

for p = 1 : HerderNumber
    
    Herder(p).y = zeros(2,TotalTimesteps);
    Herder(p).y_dot = zeros(2,TotalTimesteps);
    Herder(p).r = zeros(1,TotalTimesteps);
    Herder(p).theta = zeros(1,TotalTimesteps);
    Herder(p).r_dot = zeros(1,TotalTimesteps);          % radial velocity
    Herder(p).theta_dot = zeros(1,TotalTimesteps);      % angular velocity
    Herder(p).r_ddot = zeros(1,TotalTimesteps);          % radial acceleration
    Herder(p).theta_ddot = zeros(1,TotalTimesteps);      % angular acceleration
    
    Herder(p).cir_ddot = zeros(2,TotalTimesteps); 
    Herder(p).cir_dot = zeros(2,TotalTimesteps); 
    Herder(p).cir = zeros(2,TotalTimesteps); 
    
end

Herder(HerderNumber+1).b_theta = zeros(2,TotalTimesteps); 


% initial "random" position around a fixed radial distance from the centre of the environment

for p = 1 : HerderNumber
    Herder(p).theta(1,1) = (p-1) * 2 * pi / HerderNumber ;
    Herder(p).r(1,1) = InitialRadius;
    [Herder(p).y(1,1), Herder(p).y(2,1)] = pol2cart(Herder(p).theta(1,1), Herder(p).r(1,1));
end




end