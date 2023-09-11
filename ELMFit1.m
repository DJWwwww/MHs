function [fitness,ER,F1]=ELMFit1(all,X)
global D;

Elm_Type=1; 
L=1;
Y=[L X];
K=5;
ERindex=zeros(1,K);
F1index=zeros(1,K);
FeatNum=sum(X);
[m , ~]=size(all);
id_test = crossvalind('Kfold',m,K);
 for i = 1:K
     test=(id_test==i);
     train=~test;
     traindata=all(train,:);
     testdata=all(test,:);
     [ERrate,F1_score]=ELM(traindata(:,Y==1), testdata(:,Y==1), Elm_Type, 20,'sig');
     ERindex(i)= ERrate;
     F1index(i)=F1_score;
 end
 ER=mean(ERindex);
 F1=mean(F1_score);
 a=0.1;
 b=1-a;
 fitness=b*ER+a*(FeatNum/D);

