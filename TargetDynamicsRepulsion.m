function xdot = TargetDynamicsRepulsion(x,y) 
%return the repulsion in cartesian coordinates of the target agents in presence of a herder

global RepulMag rstar

Rthreshold = rstar / 4; % delta_rmin | rstar | rstar / 2

xdot =  heaviside(norm(x-y) - Rthreshold) * RepulMag * (x - y ) / (norm(x - y) .^3) ; %
