function [seedNextMatrix,seedNextMatrixFitness,erbest,F1best]=Select(seedMatrix,seedFitness,er,F1,params)
global D;
seedNextMatrix              = zeros(params.seednum,D);
seedNextMatrixFitness       = zeros(1,params.seednum);  
erbest                      = zeros(1,params.seednum); 
F1best                      =zeros(1,params.seednum);
% the best
[~,bestIndex]=min(seedFitness);
seedNextMatrix(1,:)=seedMatrix(bestIndex,:);
seedNextMatrixFitness(1)=seedFitness(bestIndex);
erbest(1)=er(bestIndex);
F1best(1)=F1(bestIndex);
fitness_mean = mean((seedFitness));
fit=abs((seedFitness)-fitness_mean);
fitsum = sum(fit);
p=fit/fitsum;
[~,best]=sort(p,'descend');

t=1;
i=1;
% the others
m=params.seednum;
while i<m
 if best(i) ~= bestIndex
     t=t+1;
    seedNextMatrix(t,:) = seedMatrix(best(i),:);
    seedNextMatrixFitness(t) = seedFitness(best(i));
    erbest(t)=er(best(i));
    F1best(t)=F1(best(i));
 else
     m=m+1;
 end 
 i=i+1;
end

    
    
    
    
    



