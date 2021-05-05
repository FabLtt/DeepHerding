function Param_Initialization(TargetNumber,HerderNumber,DwellTime,RepulMultiplier)
% Assign system parameters and save them on file in "Parameters/" folder
%
% Simulation parameters : T N dt t_search
% Environment parameters : xstar rstar delta_rmin Q P
% Target's parameters : RepulMag
% Herder's parameters : br b_theta_S eps_r eps_theta

global T N dt t_search t_dwell

dt = 0.02;          % fixedDeltaTime (default 0.02)
T = 30 * 4;         % simulation total time
N = T / dt;         % number of steps

t_search = 0;
t_dwell = DwellTime; % (default 50)


global xstar rstar delta_rmin Q P

Q = TargetNumber;                      % number of target
P = HerderNumber;                      % number of herder
xstar = [0;0];        % goal position initialization default = zeros(2,1)
rstar = 1;                  % radius of goal region
delta_rmin = rstar + (.062 - .061539); 


global BrownDist BrownMag RepulMag

BrownDist = makedist('Normal',0,sqrt(dt)); % Initialize the probability distribution for our random variable with mean 0 and stdev of sqrt(dt)
BrownMag = 0.05; % default value: 0.05
RepulMag = RepulMultiplier * BrownMag; % default value: 20*0.05


global br b_theta_S eps_r eps_theta 

or = 10;                % default value: 10
eps_r = or^2;           % radial spring constant
otheta = 8;             % default value: 8
eps_theta = otheta^2;   % angular spring constant
zeta_r = 0.5;           % default value: 0.5
zeta_theta = 0.7;       % default value: 0.7
br = 2 * zeta_r * or;   % radial damping term
b_theta_S = 2 * zeta_theta * otheta;     % angular damping term

% global alfa beta gamma delta A B
% 
% beta = 0.16;  
% gamma = 7.22; 
% delta = 23.08; 
% alfa = 80.59; 
% A = - 0.2; 
% B = -0.2; 

global net
% uncomment the following lines to import a tensorflow keras model 
% modelfile = "./model/Reduced3_ExpertModel";
% net = importKerasNetwork(modelfile);

% uncomment the following lines to load the net model from a .mat file 
load('./model/ImportedModelNovice_Red3.mat','net');     % Novice model
% load('./model/ImportedModelExpert_Red3.mat','net');   % Expert model 

save(['Parameters/param_',num2str(TargetNumber),'_',num2str(RepulMultiplier),'.mat']);

