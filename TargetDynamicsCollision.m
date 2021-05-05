%% return collision avoidance effect 

function xdot = TargetDynamicsCollision(x,x_neigh,prov) % opzione 1 , 2 


xdot = prov + 0.005 * (x - x_neigh)  / (norm(x - x_neigh).^3);

