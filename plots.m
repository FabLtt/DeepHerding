%% just a script to plot around after have loaded a trail .mat file (e.g., load('Trials\Global\trial_Global_1_7T_3H.mat'))
TargetNumber = 7;
HerderNumber = 3;
load(['Parameters/param_',num2str(TargetNumber),'T_',num2str(HerderNumber),'H.mat']);

setPlots;

time = linspace(0,T,N);
color = [0.3 .8 0; 0.5 .8 0; .2 .8 0.5; .4 .8 0.4;  0.7 .8 0; 0.6 .8 0.2; 0.8 .8 0];

opt1 = '1 - time snapshots \n';
opt2 = '2 - initial and final positions \n';
opt3 = '3 - Herder and GCM trajectories \n';
opt4 = '4 - norm distances \n';
opt5 = '5 - Angular and radial positions\n';
opt6 = '6 - Angular and radial velocities\n';


disp('which plot do you need?');
letsPlot = input([opt1,opt2,opt3,opt4,opt5,opt6]);

switch letsPlot
    
    case 1  %% positions' snapshots in the environment
        %%
        t_stamp = [10 N*2/8 N*4/8 N*6/8 N];
        
        for i = 1 : length(t_stamp)
            
            figure(i)
            
            step_plot = 20000;
            
            for p = 1 : P
                if i == 1
                    plot(Herder(p).y(1,1:t_stamp(i)), Herder(p).y(2,1:t_stamp(i)),'-.','LineWidth',1,'Color',[0.8 0.8 0.8]); hold on;
                else
                    plot(Herder(p).y(1,t_stamp(i-1):1000:t_stamp(i)), Herder(p).y(2,t_stamp(i-1):1000:t_stamp(i)),'-.','LineWidth',1,'Color',[0.8 0.8 0.8]); hold on;
                end
                plot(Herder(p).y(1,t_stamp(i)), Herder(p).y(2,t_stamp(i)),'ks','MarkerSize',10,'MarkerFaceColor','k'); hold on;
            end
            
            for q = 1 : Q
                if i == 1
                    plot(Target(q).x(1,1:t_stamp(i)), Target(q).x(2,1:t_stamp(i)),'-.','LineWidth',1,'Color',color(q,:),'MarkerIndices',[1 floor(t_stamp(i)/4)]); hold on;
                else
                    plot(Target(q).x(1,t_stamp(1):1000:t_stamp(i)), Target(q).x(2,t_stamp(1):1000:t_stamp(i)),'-.','LineWidth',1,'Color',0.2 * i * color(q,:),'MarkerIndices',[1 floor(t_stamp(i)/4)]); hold on;
                end
                plot(Target(q).x(1,t_stamp(i)),Target(q).x(2,t_stamp(i)),'o','MarkerSize',10,'MarkerEdgeColor',color(q,:),'MarkerFaceColor',color(q,:)); hold on;
            end
            
            
            env_radius = 3;
            legend('','y_1(t)','','y_2(t)','','x_1(t)','','x_2(t)','','x_3(t)');
            axis equal
            grid on;
            text(-1,1,['t=',num2str((t_stamp(i))* dt - dt),'s'],'FontSize',15);
        end
        
    case  2
        %% start and end positions
        figure()
        N = 1000;
        
        [xcircleG, ycircleG] = scircle1(xstar(1,1), xstar(2,1),rstar);
        plot(xcircleG, ycircleG,'-.','LineWidth',1,'Color',[0 .5 .7]); hold on
        for p = 1 : P
            plot(Herder(p).y(1,1), Herder(p).y(2,1),'ks','MarkerSize',10, 'MarkerFaceColor','none');
            plot(Herder(p).y(1,N), Herder(p).y(2,N),'ks','MarkerSize',10, 'MarkerFaceColor','k');
        end
               
        for q = 1 : Q
            plot(Target(q).x(1,1),Target(q).x(2,1),'o','MarkerSize',10,'MarkerEdgeColor',0.6*color(q,:),'MarkerFaceColor','none');
            plot(Target(q).x(1,N),Target(q).x(2,N),'o','MarkerSize',10,'MarkerEdgeColor','none','MarkerFaceColor',color(q,:));
        end
        
        axis equal
        axis([-7 7 -7 7])
        
    case 3
        %% trajectories of herders and targets
        
        N1 = 1;
        N2 = 1000; 
               
        for p = 1 : 1
            
            plot(Herder(p).y(1,N1:N2), Herder(p).y(2,N1:N2),'-.','Color',[0.5 0.5 0.5],'LineWidth',1); hold on
            plot(Herder(p).y(1,N1), Herder(p).y(2,N1),'ks','MarkerSize',10, 'MarkerFaceColor','none');
            plot(Herder(p).y(1,N2), Herder(p).y(2,N2),'ks','MarkerSize',10,'MarkerFaceColor','k'); hold on;
        end
        
        for p = 2 : 2
            
            plot(Herder(p).y(1,N1:N2), Herder(p).y(2,N1:N2),'-.','Color',[0.5 0.5 0.8],'LineWidth',1); hold on
            plot(Herder(p).y(1,N1), Herder(p).y(2,N1),'bs','MarkerSize',10, 'MarkerFaceColor','none');
            plot(Herder(p).y(1,N2), Herder(p).y(2,N2),'bs','MarkerSize',10,'MarkerFaceColor','k'); hold on;
        end
        
        sizeH = size(Herder);
        
        if sizeH(2) == 4
            for p = 3 : 3
                plot(Herder(p).y(1,N1:N2), Herder(p).y(2,N1:N2),'-.','Color',[0.5 0.5 0.8],'LineWidth',1); hold on
                plot(Herder(p).y(1,N1), Herder(p).y(2,N1),'ks','MarkerSize',10, 'MarkerFaceColor','none');
                plot(Herder(p).y(1,N2), Herder(p).y(2,N2),'ks','MarkerSize',10,'MarkerFaceColor','k'); hold on;
            end
        end
        
        for q = 1 : Q
            plot(Target(q).x(1,N1:N2),Target(q).x(2,N1:N2),'-.','LineWidth',2,'Color',color(q,:)); hold on
            plot(Target(q).x(1,N1),Target(q).x(2,N1),'o','MarkerSize',10,'MarkerEdgeColor',0.6*color(q,:),'MarkerFaceColor','none');
            plot(Target(q).x(1,N2),Target(q).x(2,N2),'o','MarkerSize',10,'MarkerEdgeColor','none','MarkerFaceColor',color(q,:));
        end
        
        [xcircleG, ycircleG] = scircle1(xstar(1,1), xstar(2,1),rstar);
        plot(xcircleG, ycircleG,'-','LineWidth',2,'Color',[0.7 0 0]); hold on
        
     
        axis equal;
        axis([-7 7 -7 7])
        
    case 4
        %% Norms  
        for t = 1 : N
            
            for p = 1 : P
                Herder_norm(p,t) = norm(Herder(p).y(:,t) - xstar);
            end
            
            for q = 1 : Q
                Target_norm(q,t) = norm(Target(q).x(:,t) - xstar); % to show containment with respect to x*
            end
              
            radius(t) = rstar;
        end
        
        figure()
               
        for q = 1 : Q
            plot(time, Target_norm(q,:),'Color',color(q,:)); hold on     
        end
             
        for p = 1 : P
            plot(time, Herder_norm(p,:),'k-','LineWidth',1.5); hold on
        end
        
        plot(time,radius,'-.','LineWidth',2,'Color',[0 .5 .7]); hold on ;
        
        axis tight
        
    case 5        
        %% Angular and radial positions
        
        figure()
        for p = 1 : P
            subplot(P,1,p)
            plot(time, rad2deg(Herder(p).theta(1,1:N)),'k-','LineWidth',1); hold on
        end
        
        figure()
        for p = 1 : P
            subplot(P,1,p)
            plot(time, Herder(p).r(1,1:N),'k-','LineWidth',1); hold on
            axis tight;
        end
        
    case 6
        %% Angular and radial velocities
        
        figure()
        for p = 1 : P
            subplot(2,1,p)
            plot(time, rad2deg(Herder(p).theta_dot(1,1:N)),'k-','LineWidth',1); hold on
        end
        
        figure()
        for p = 1 : P
            subplot(2,1,p)
            plot(time, Herder(p).r_dot(1,1:N),'k-','LineWidth',1); hold on
            axis tight;
        end
        
               
end     %% end switch case


clear opt1 opt2 opt3 opt4 opt5 opt6 opt7