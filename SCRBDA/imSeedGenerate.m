function [seedGenerateMatrix, sons_fitness_array,Errowrate,F1]  = imSeedGenerate(all,sonsnum_array, scope_array, seeds_matrix, params,MI,mean,VC)
global D;
global fun;
sons_matrix = zeros(sum(sonsnum_array),D);
sons_index = 1; 
%% NormalSowing
     u=4;
     s=sonsnum_array(1);
     seed_position = ones(s,1) * seeds_matrix(1,:);   
     offsett=zeros(sonsnum_array(1),D);
     offsetn=zeros(sonsnum_array(1),D);
     h=round(s/3);
       
         for k=1:h    
             for d=1:D
                 switch(mean)
                     case 1 %Chebyshev
                         offsett(1,d)=0.5*rand()*scope_array(1,d);
                         offsett(k+1,d)=cos(k./cos(offsett(k,d))); 
                         offsetn(k,d)=abs(erf(sqrt(pi)*offsett(k,d)));
                     case 2 %cube
                         offsett(1,d)=0.5*rand()*scope_array(1,d);
                         offsett(k+1,d)=4.*(offsett(k,d)^3)-3.*offsett(k,d);
                         offsetn(k,d)=abs(erf(sqrt(pi)*offsett(k,d)));
                     case 3 %tent
                         offsetn(1,d)=abs(erf(sqrt(pi)*rand()*scope_array(1,d)));
                        if offsetn(k,d)>0 && offsetn(k,d)<0.5
                            offsetn(k+1,d)=2.*offsetn(k,d);
                        else
                            offsetn(k+1,d)=2-2.*offsetn(k,d);
                        end
                     case 4 %Logistic 
                        offsetn(1,d)=abs(erf(sqrt(pi)*(rand()*2-1)*scope_array(1,d)));
                        offsetn(k+1,d)=u*offsetn(k,d)*(1-offsetn(k,d));
                     case 5 %Mutual information
                          offsetn=abs(erf(sqrt(pi)*scope_array(1,d)*MI(1,d)));
                 end
                 if mean<5
                   if rand()<offsetn(k,d)
                   seed_position(k,d)=1-seed_position(k,d);
                   end
                 else
                     if rand()<offsetn
                   seed_position(k,d)=0;
                     else 
                   seed_position(k,d)=1;
                     end
                 end
             end
         end
         for k=h+1:s 
             for d=1:D
%             offset =(rand()*2-1) * scope_array(i,d);
            %offsetn=logsig(offset);%Sigmoid函数
            %offsetn=abs(pi*atan(pi*offset/2)/2)
%            offsetn=abs(2./(1+exp(-2*offset))-1);%tanh函数
             offsetn=abs(erf(sqrt(pi)*rand()*scope_array(1,d)));
             if rand()<offsetn
                 seed_position(k,d)=1-seed_position(k,d);
             end 
             end
         end
     sons_matrix(sons_index:sons_index + sonsnum_array(1) - 1,:) = seed_position;
     sons_index = sons_index + sonsnum_array(1);     
for i = 2 : params.seednum
    s=sonsnum_array(i);
    seed_position = ones(s,1) * seeds_matrix(i,:); 
    for k=1:s   
       for d=1:D
%             offset =(rand()*2-1) * scope_array(i,d);
            %offsetn=logsig(offset);%Sigmoid函数
            %offsetn=abs(pi*atan(pi*offset/2)/2)
%            offsetn=abs(2./(1+exp(-2*offset))-1);%tanh函数
             offsetn=abs(erf(sqrt(pi)*rand()*scope_array(i,d)));
             if rand()<offsetn
                 seed_position(k,d)=1-seed_position(k,d);
             end  
       end
     end
     

        sons_matrix(sons_index:sons_index + sonsnum_array(i) - 1,:) = seed_position;
        sons_index = sons_index + sonsnum_array(i);     

end
%% Mutation

seed_mutation_matrix = zeros(params.MutationNum, D);   
% VC=5;%Variation category
switch (VC)
%NO.1  Direct inversion   
    case 1
      for j=1: params.MutationNum 
        seed_mutation_matrix(j,:)=~seeds_matrix(j,:);    
      end
    case 2
%NO.2  Random inversion
    seed_mutation_matrix=seeds_matrix; 
    num=round(D/3);
    b=randi([1,D],1,num);
    for j=1: params.MutationNum
       for k=1: num
           seed_mutation_matrix(j,b(k)) = 1;
          
       end
    end
    case 3
%NO.3 Crossover operator
    pc=0.5; % Crossover rate
    R=rand;
    seed_mutation_matrix=seeds_matrix;
    for j=1:2:params.MutationNum-1
       if R<pc
       p=randi([0,1],1,D);
       for k=1:D
           if p(k)==1
               temp=seed_mutation_matrix(j+1,k);
               seed_mutation_matrix(j+1,k)=seed_mutation_matrix(j,k);
               seed_mutation_matrix(j,k)=temp;
           end
       end
       end
    end
    case 4
%NO.4 XOR operation   
    seed_mutation_matrix=seeds_matrix;
    for j=1:params.MutationNum-1
         seed_mutation_matrix(j,:)=bitxor(seed_mutation_matrix(j,:),seed_mutation_matrix(j+1,:)); 
    end
    case 5
%NO.5 Quick bit mutation
    miu=0.1;
    seed_mutation_matrix=seeds_matrix;
    for j=1:params.MutationNum
        seedpos0=find(seed_mutation_matrix(j,:)==0);
        seedpos1=find(seed_mutation_matrix(j,:)==1);
        count0=length(seedpos0);
        count1=length(seedpos1);
        G0=round(miu*min(count0,count1));
        GG=max(1,G0);
        rx=rand();
        if count0==0||count1==0
           rxx=randi([1,D],1,GG);
           for k=1:GG
            seed_mutation_matrix(j,rxx(k))=~seed_mutation_matrix(j,rxx(k));
           end
        elseif count0~=0&&count1~=0
        if rx>0.5
         rxx=randi([1, count0],1,GG);
         for k=1:GG
          seed_mutation_matrix(j,seedpos0(rxx(k)))=1;
         end
        else 
         rxx=randi([1, count1],1,GG);   
         for k=1:GG
          seed_mutation_matrix(j,seedpos1(rxx(k)))=0;
         end
        end
        end
    end
    case 6
%NO.6
      seed_mutation_matrix=seeds_matrix;
        for j=1:params.MutationNum
            for k=1:D
                rx=rand();
                if MI(1,k)>rx
                    seed_mutation_matrix(j,k)=1;
                else
                    seed_mutation_matrix(j,k)=0;
                end
            end
        end        
end


%% Calculate fitness
seedGenerateMatrix=[sons_matrix;seed_mutation_matrix]; 
tempnum=params.MutationNum+sons_index-1;
sons_fitness_array=zeros(1,tempnum);
Errowrate=zeros(1,tempnum);
F1=zeros(1,tempnum);
for n =1:tempnum
[sons_fitness_array(n),Errowrate(n),F1(n)]=fun(all,seedGenerateMatrix(n,:));
end

