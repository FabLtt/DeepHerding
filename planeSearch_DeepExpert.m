function [rps_P, thetaps_P, chsd] = planeSearch_DeepExpert(t, Herder, Target)

global Q P xstar net_expert seq_len

seq_len = 25;
start_seq = t - seq_len;
end_seq = t;


for q = 1 : Q
    TargetPos_ALL(:,:,q) = Target(q).x(:,start_seq:end_seq);
    TargetVel_ALL(1,:,q) = Target(q).r_dot(:,start_seq:end_seq);
    TargetVel_ALL(2,:,q) = Target(q).th_dot(:,start_seq:end_seq);
    TargetVelCart_ALL(:,:,q) = Target(q).x(:,start_seq:end_seq);
    TargetAcc_ALL(1,:,q) = Target(q).r_ddot(:,start_seq:end_seq);
end


for p = 1 : P
    HerderPos(:,:) = Herder(p).y(:,start_seq:end_seq);
    HerderVel(1,:) = Herder(p).r_dot(:,start_seq:end_seq);
    HerderVel(2,:) = Herder(p).theta_dot(:,start_seq:end_seq);
    HerderVelCart(:,:) = Herder(p).y_dot(:,start_seq:end_seq);
    HerderAcc(1,:) = Herder(p).r_ddot(:,start_seq:end_seq);
    
    for q = 1 : Q
        HerderTargetDist(q) = norm(HerderPos(:,end) - TargetPos_ALL(:,end,q));
    end
    
    
    [~, index_sorted] = sort(HerderTargetDist);
    if Q > 4
        if exist('chsd','var') && chsd(end)>0
            index_sorted(index_sorted(:) == chsd(end)) = [];
        end
    end
    Target_id_to_chase = index_sorted(1:end);
    
    TargetPos = TargetPos_ALL(:,:,Target_id_to_chase);
    TargetVel = TargetVel_ALL(:,:,Target_id_to_chase);
    TargetVelCart = TargetVelCart_ALL(:,:,Target_id_to_chase);
    TargetAcc = TargetAcc_ALL(:,:,Target_id_to_chase);
    
    other_p = p + 1;
    if p == P
        other_p = 1;
    end
    
    OtherHerderPos(:,:) = Herder(other_p).y(:,start_seq:end_seq);
    OtherHerderVel(1,:) = Herder(other_p).r_dot(:,start_seq:end_seq);
    OtherHerderVel(2,:) = Herder(other_p).theta_dot(:,start_seq:end_seq);
    OtherHerderVelCart(:,:) = Herder(other_p).y_dot(:,start_seq:end_seq);
    OtherHerderAcc(1,:) = Herder(other_p).r_ddot(:,start_seq:end_seq);
    
    Sequence = buildSequence_Red3(HerderPos, TargetPos, HerderVel, TargetVel,HerderVelCart,TargetVelCart, HerderAcc, TargetAcc, OtherHerderPos, OtherHerderVel,OtherHerderVelCart,OtherHerderAcc);
    Pred = classify(net_expert,Sequence);
    chsd(p) = grp2idx(Pred)-1;
    
    if chsd(p) == 0
        chsd(p) = index_sorted(end); 
        X = Target(chsd(p)).x(1,end_seq) - xstar(1);
        Y = Target(chsd(p)).x(2,end_seq) - xstar(2);
    else
        chsd(p) = Target_id_to_chase(chsd(p));
        X = Target(chsd(p)).x(1,end_seq) - xstar(1);
        Y = Target(chsd(p)).x(2,end_seq) - xstar(2);
    end
    
    [thetaps_P(p), rps_P(p)] = cart2pol(X,Y);
    
    
end
end

