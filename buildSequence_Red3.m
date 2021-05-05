function Sequence = buildSequence_Red3(HerderPos, TargetPos, HerderVel, TargetVel,HerderVelCart,TargetVelCart, HerderAcc, TargetAcc, OtherHerderPos, OtherHerderVel,OtherHerderVelCart, OtherHerderAcc)
%
% HerderPos = Herder(p).y; % coordinates(x,y) x time_steps
% TargetPos = Target(-).x; % coordinates(x,y) x time_steps x target_id
% HerderVel = Herder(p).y_dot; % coordinates(r,th) x time_steps 
% TargetVel = Target(-).x_dot; % coordinates(r,th) x time_steps x target_id
% HerderVelCart = Herder(p).y_dot; % coordinates(x,y) x time_steps 
% TargetVelCart = Target(-).x_dot; % coordinates(x,y) x time_steps x target_id
% HerderAcc = Herder(p).y_ddot; % coordinates(r,th) x time_steps 
% TargetAcc = Target(-).x_ddot; % coordinates(r,th) x time_steps x target_id
% OtherHerderPos = Herder(!=p).y; % coordinates(x,y) x time_steps
% OtherHerderVel = Herder(!=).y_dot % coordinates(r,th) x time_steps 
% OtherHerderVelCart = Herder(!=).y_dot % coordinates(x,y) x time_steps 

global xstar seq_len

n_features = 48; 

Sequence = zeros(n_features,seq_len);

for q = 1 : 4
    for time = 1 : seq_len
        Herder_Target(time,:,q) = HerderPos(:,time) - TargetPos(:,time,q); % time x coordinates x targetID
        OtherHerder_Target(time,:,q) = OtherHerderPos(:,time) - TargetPos(:,time,q); % time x coordinates x targetID
        Target_goal(time,:,q) = TargetPos(:,time,q) - xstar; % time x coordinates x targetID
    end
    Target_goal_distance = sqrt(Target_goal(:,1,:).^2 + Target_goal(:,2,:).^2); % time x coordinates x targetID
    Target_goal_angle = atan2(Target_goal(:,2,:),Target_goal(:,1,:)); 
end

for time = 1 : seq_len
    Herder_goal(time,:) = HerderPos(:,time) - xstar;
    OtherHerder_goal(time,:) = OtherHerderPos(:,time) - xstar;
    Herder_OtherHerder(time,:) = HerderPos(:,time) - OtherHerderPos(:,time);
end

[Herder_Target_angle,Herder_Target_distance] = cart2pol(Herder_Target(:,1,:),Herder_Target(:,2,:));
[OtherHerder_Target_angle,OtherHerder_Target_distance] = cart2pol(OtherHerder_Target(:,1,:),OtherHerder_Target(:,2,:));
[Herder_OtherHerder_angle, Herder_OtherHerder_distance] = cart2pol(Herder_OtherHerder(:,1), Herder_OtherHerder(:,2));

Sequence(1,:) = Herder_Target_distance(:,1,1);
Sequence(2,:) = Herder_Target_distance(:,1,2);
Sequence(3,:) = Herder_Target_distance(:,1,3);
Sequence(4,:) = Herder_Target_distance(:,1,4);

Sequence(5,:) = Herder_Target_angle(:,1,1);
Sequence(6,:) = Herder_Target_angle(:,1,2);
Sequence(7,:) = Herder_Target_angle(:,1,3);
Sequence(8,:) = Herder_Target_angle(:,1,4);

Sequence(9,:) = sqrt(Herder_goal(:,1).^2 + Herder_goal(:,2).^2);
Sequence(10,:) = Target_goal_distance(:,1,1);
Sequence(11,:) = Target_goal_distance(:,1,2);
Sequence(12,:) = Target_goal_distance(:,1,3);
Sequence(13,:) = Target_goal_distance(:,1,4);

Sequence(14,:) = HerderVel(1,1:seq_len); 
Sequence(15,:) = TargetVel(1,1:seq_len,1);
Sequence(16,:) = TargetVel(1,1:seq_len,2);
Sequence(17,:) = TargetVel(1,1:seq_len,3);
Sequence(18,:) = TargetVel(1,1:seq_len,4);

Sequence(19,:) = HerderAcc(1,1:seq_len); 
Sequence(20,:) = TargetAcc(1,1:seq_len,1);
Sequence(21,:) = TargetAcc(1,1:seq_len,2);
Sequence(22,:) = TargetAcc(1,1:seq_len,3);
Sequence(23,:) = TargetAcc(1,1:seq_len,4);

Sequence(24,:) = atan2(Herder_goal(:,2),Herder_goal(:,1));
Sequence(25,:) = Target_goal_angle(:,1,1);
Sequence(26,:) = Target_goal_angle(:,1,2);
Sequence(27,:) = Target_goal_angle(:,1,3);
Sequence(28,:) = Target_goal_angle(:,1,4);

Sequence(29,:) = dot(HerderVelCart(:,1:seq_len),Herder_goal(1:seq_len,:)');
Sequence(30,:) = dot(TargetVelCart(:,1:seq_len,1),Target_goal(1:seq_len,:,1)');
Sequence(31,:) = dot(TargetVelCart(:,1:seq_len,2),Target_goal(1:seq_len,:,2)');
Sequence(32,:) = dot(TargetVelCart(:,1:seq_len,3),Target_goal(1:seq_len,:,3)');
Sequence(33,:) = dot(TargetVelCart(:,1:seq_len,4),Target_goal(1:seq_len,:,4)');

Sequence(34,:) = Herder_OtherHerder_distance;
Sequence(35,:) = Herder_OtherHerder_angle; 
Sequence(36,:) = sqrt(OtherHerder_goal(:,1).^2 + OtherHerder_goal(:,2).^2);
Sequence(37,:) = OtherHerderVel(1,1:seq_len);
Sequence(38,:) = OtherHerderAcc(1,1:seq_len);

Sequence(39,:) = atan2(OtherHerder_goal(:,2),OtherHerder_goal(:,1));
Sequence(40,:) = dot(OtherHerderVelCart(:,1:seq_len),OtherHerder_goal(1:seq_len,:)');
Sequence(41,:) = OtherHerder_Target_distance(:,1,1);
Sequence(42,:) = OtherHerder_Target_distance(:,1,2);
Sequence(43,:) = OtherHerder_Target_distance(:,1,3);
Sequence(44,:) = OtherHerder_Target_distance(:,1,4);

Sequence(45,:) = OtherHerder_Target_angle(:,1,1);
Sequence(46,:) = OtherHerder_Target_angle(:,1,2);
Sequence(47,:) = OtherHerder_Target_angle(:,1,3);
Sequence(48,:) = OtherHerder_Target_angle(:,1,4);


Sequence = zscore(Sequence);

end