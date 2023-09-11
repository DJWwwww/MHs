function [Sf,Nf,curve1,curve2,curve3,fitness_best,ER_best,F1_best]=SCRBDA(all,T,params,A,B,rs_limit)
% 新重启 全重启
format long;
global Max_Seeds_Num;
global Min_Seeds_Num;
global Coef_Seed_Num;
% global evaTime;
global D;
global fun;
global K;
global t;

Max_Seeds_Num = 20;
Min_Seeds_Num = 2;
Coef_Seed_Num = 20;
%evaTime = 1;
alpha=2;
% fun=@FitnessFunction; 
% fun=@ELMFit;
D=size(all,2)-1; 


fit_b=1;
trail=0;
Mi=zeros(1,D);
         for v=2:D+1
             Mi(1,v-1)=I(all(:,v),all(:,1));
         end
MI=nor(Mi);
MIub=0.8;
MIlb=1-MIub;
MI2=logsig(MI);
for v=1:D
    if MI2(v)>MIub
        MI2(v)=MIub;
    end
    if MI2(v)<MIlb
        MI2(v)=MIlb;
    end
end
SeedsMatrix = zeros(params.seednum,D);
for v=1:params.seednum
    for w=1:D
     SeedsMatrix(v,w)=rand()<(MI2(w));
    end
end
% SeedsMatrix = randi([0 1],params.seednum,D);
SeedsFitness = zeros(1,params.seednum);
ER = zeros(1,params.seednum);
F1 = zeros(1,params.seednum);
[SeedsFitness(1),ER(1),F1(1)]=fun(all,SeedsMatrix(1,:));
fitness_best = SeedsFitness(1);
ER_best=ER(1);
F1_best=F1(1);
Seed_best=SeedsMatrix(1,:);
for i=2:params.seednum
 [SeedsFitness(i),ER(i),F1(i)]=fun(all,SeedsMatrix(i,:));
 
 if(SeedsFitness(i)<fitness_best)
	fitness_best = SeedsFitness(i);
    Seed_best=SeedsMatrix(i,:);
    ER_best=ER(i);
    F1_best=F1(i);
%      evaTime = evaTime + 1;
%     [fitG,idx]=SeedsFitness(i); Xgb=SeedsMatrix(idx,:); Xpb=X; fitP=fit;
 end

end
curve1=inf; 
curve2=inf; 
curve3=inf;
figure(1); clf; axis([1 T 0 0.5]); xlabel('Number of Iterations');
ylabel('Fitness Value'); title('SCRBDA'); grid on;    



% w=0.8;%Auxiliary dandelion weight
scope_array = ones(params.seednum,D)*params.Bound ;
t = 0;
K=40;

SeedBests=ones(K,D);

t0=0; 
while t<T
      
       t0=t0+1;
        t = t + 1;
%     last=SeedsFitness(1);
    %Calculate the number of seeds
    [sonsnum_array] = seedsumGenerate(SeedsFitness,params);
    %Generate seeds
    [NormalSowingMatrix,NormalSowingFitness,NormalSowingER,NormalSowingF1] = imSeedGenerate(all,sonsnum_array,scope_array,SeedsMatrix,params,MI,A,B);
    Allseed = [SeedsMatrix;NormalSowingMatrix];
    Allfitness = [SeedsFitness,NormalSowingFitness];
    AllER=[ER,NormalSowingER];        
    AllF1=[F1,NormalSowingF1];
    % select the next iteration 
    [SeedsMatrix,SeedsFitness,ER,F1]=Select(Allseed,Allfitness,AllER,AllF1,params); 
    Seed_best=SeedsMatrix(1,:); 
    fitness_best=SeedsFitness(1);
    ER_best=ER(1);
    F1_best=F1(1);
    
    M=mod(t0,K);
    if M~=0
         SeedBests(M,:)=Seed_best;
    else
         SeedBests(K,:)=Seed_best;
    end
    %Generate sowing range  
%     A=0.95;
%     B=1.05;
    r0=(2 * pi) * rand();
    r1=alpha - t0 * (alpha / T);
    r2=2*rand();
    r3=rand();
    r4 = -1 + 2 * rand(); 
    if t0<=K  
         if rand()>0.5
                  for d=1:D
%                      scope_array(1,d)=  scope_array(1,d)-r0*cos(r0);
                   Dx     = abs(r2 *Seed_best(d) - scope_array(1,d));
                      scope_array(1,d)=  scope_array(1,d)-r1*cos(r0)*Dx;
                  end
         else
                 for d=1:D
%                      scope_array(1,d)=  scope_array(1,d)+r0*sin(r0);
                     Dx     = abs(r2 *Seed_best(d) - scope_array(1,d)); 
                      scope_array(1,d)=  scope_array(1,d)+r1*sin(r0)*Dx;
                  end
         end
            
    else
         for d=1:D
            
                      dist   = abs(Seed_best(d) - scope_array(i,d));
                 scope_array(i,d) = dist * exp(r4) * cos(2 * pi * r4) + Seed_best(d);
         end
    end 
    for i=2:params.seednum
        for d=1:D
           scope_array(i,d)=(1-t0/T)*scope_array(i,d)+r3*(r2*Seed_best(d)-SeedsMatrix(i,d));

        end
    end
    %Cross-boundary processing
    scope_array(scope_array>params.Bound)=params.Bound ;
    scope_array(scope_array<-params.Bound)=-params.Bound ; 
    curve1(t)=fitness_best;
    curve2(t)=ER_best;
    Pos=1:D; Sf=Pos(Seed_best==1); Nf=length(Sf);
    curve3(t)=Nf;
    pause(0.000000001); hold on;
    CG=plot(t,fitness_best,'Color','r','Marker','.'); set(CG,'MarkerSize',5);
    AG=plot(t,ER_best,'Color','g','Marker','.'); set(AG,'MarkerSize',5);
    DG=plot(t,Nf/D,'Color','b','Marker','.'); set(DG,'MarkerSize',5);
    if fitness_best==fit_b
        trail=trail+1;
    else
        trail=0;
    end
    fit_b=fitness_best;
    if trail>rs_limit
        t0=0;
        trail=0;
    end 
end
Pos=1:D; Sf=Pos(Seed_best==1); Nf=length(Sf);
end