clc, clear, close
global fun;
data_name='SRBCT';
foldername='最终实验（f1）';
newfolder=['D:\MATLAB\bin\BDARS\SCRBDA\',foldername];
if exist(newfolder,'dir')==0 
mkdir(newfolder);
end
load ([data_name,'.mat']); 

fun=@ELMFit1;
filename=[newfolder,'\',data_name,'.xlsx'];

ir=1;
jr=3;
G=1;
Tt=100;
num_of_algorithm=1;
for num=0:num_of_algorithm-1
eval(['avger',num2str(num),'=zeros(1,Tt);']);
eval(['avgfit',num2str(num),'=zeros(1,Tt);']);
eval(['avgfeat',num2str(num),'=zeros(1,Tt);']);
end
for num=0:num_of_algorithm-1
eval(['NFS',num2str(num),'=zeros(1,G);']);
eval(['fitness_bestS',num2str(num),'=zeros(1,G);']);
eval(['ER_bestS',num2str(num),'=zeros(1,G);']);
eval(['F1_bestS',num2str(num),'=zeros(1,G);']);
end
title_t={'TestNumber','FeatureNumber','Bestfitness','SuccessRate','F1'};
title0='SCRBDA';
writematrix(title0,filename,'Sheet',1,'Range','C1');
writecell(title_t,filename,'Sheet',1,'Range','A2');
for M=1:G
%% 0 SCRBDA
clearvars -except all ir jr G M filename NFS0 fitness_bestS0 ER_bestS0 avger0 avgfit0...
curve_feat0 avgfeat0 title0 data_name Tt newfolder num_of_algorithm F10 F1_bestS0
tic;
params.seednum          = 4;
params.sonnum           = 20; 
params.maxEva		    = 4000;       
params.MutationNum		= 4;
params.Bound            =2;
rs_limit=10;
[Sf0,Nf0,curve_fit0,curve_ER0,curve_feat0,fitness0,ER0,F10]=SCRBDA(all,Tt,params,5,5,rs_limit); 

time_return0 = toc;
sf0=int2str(Sf0);
fprintf([' \n Best fitness for ',title0,': %.10f  \n runtime: %g'],fitness0, time_return0);
fprintf([' \n Best ER for ',title0,': %.10f  \n'],ER0);
fprintf(['Selections for ',title0,': %d  \n'],Nf0);
fprintf(['Best F1 for ',title0,': %.10f  \n'],F10);
fprintf(['Selected result for ',title0,': %s \n '],sf0);
fitness0=1-fitness0;
ER0=1-ER0;
BDAS=[ir Nf0 fitness0 ER0 F10 ];
writematrix(BDAS,filename,'Sheet',1,'Range',['A',num2str(jr)]); 
avger0=avger0+curve_ER0/G;
avgfit0=avgfit0+curve_fit0/G;
avgfeat0=avgfeat0+curve_feat0/G;
NFS0(M)= Nf0;fitness_bestS0(M)= fitness0;ER_bestS0(M)= ER0;F1_bestS0(M)=F10;
disp([title0,',round ',num2str(ir)]);
jr=jr+1;
ir=ir+1;

end
%% pictures

x=1:20:Tt; 
x(size(x,2)+1)=Tt;

for num=1:num_of_algorithm
    numb=num;
    No=2;
    if num~=num_of_algorithm
    DrawPicture(No,numb,eval(['title',num2str(numb)]),data_name,eval(['avger',num2str(numb)]),x,'Error Rate');
    else
        numb=0;
        DrawPicture(No,numb,eval(['title',num2str(numb)]),data_name,eval(['avger',num2str(numb)]),x,'Error Rate');
    end
end
if exist([newfolder,'/ER'],'dir')==0   %该文件夹不存在，则直接创建
    mkdir([newfolder,'/ER']);
end
print('-f2',[newfolder,'/ER/' ,data_name], '-dsvg', '-r600')

for num=1:num_of_algorithm
    numb=num;
    No=3;
    if num~=num_of_algorithm
    DrawPicture(No,numb,eval(['title',num2str(numb)]),data_name,eval(['avgfit',num2str(numb)]),x,'Fitness Value');
    else
        numb=0;
        DrawPicture(No,numb,eval(['title',num2str(numb)]),data_name,eval(['avgfit',num2str(numb)]),x,'Fitness Value');
    end
end
if exist([newfolder,'/Fit'],'dir')==0   %该文件夹不存在，则直接创建
    mkdir([newfolder,'/Fit']);
end
print('-f3',[newfolder,'/Fit/' ,data_name], '-dsvg', '-r600')

for num=1:num_of_algorithm
    numb=num;
    No=4;
    if num~=num_of_algorithm
    DrawPicture(No,numb,eval(['title',num2str(numb)]),data_name,eval(['avgfeat',num2str(numb)]),x,'Feature Number');
    else
        numb=0;
        DrawPicture(No,numb,eval(['title',num2str(numb)]),data_name,eval(['avgfeat',num2str(numb)]),x,'Feature Number');
    end
end

if exist([newfolder,'/Feat'],'dir')==0   %该文件夹不存在，则直接创建
    mkdir([newfolder,'/Feat']);
end
print('-f4',[newfolder,'/Feat/' ,data_name], '-dsvg', '-r600')


cell_tittle={'Algorithm','AvgNF','Avgfit','AvgER','BestER','AvgF1'};
writecell(cell_tittle,filename,'Sheet',2,'Range','A1');
cell_tittle2={'StdNF','Stdfit','StdER','StdF1'};
writecell(cell_tittle2,filename,'Sheet',2,'Range','G1');
for num=0:num_of_algorithm-1
cell_mean={eval(['title',num2str(num)]),mean(eval(['NFS',num2str(num)])),mean(eval(['fitness_bestS',num2str(num)])),mean(eval(['ER_bestS',num2str(num)])),max(eval(['ER_bestS',num2str(num)])),mean(eval(['F1_bestS',num2str(num)]))};
writecell(cell_mean,filename,'Sheet',2,'Range',['A',num2str(num+2)]);
cell_std={std(eval(['NFS',num2str(num)])),std(eval(['fitness_bestS',num2str(num)])),std(eval(['ER_bestS',num2str(num)])),std(eval(['F1_bestS',num2str(num)]))};
writecell(cell_std,filename,'Sheet',2,'Range',['G',num2str(num+2)]);
end
clearvars -except avger0 avgfit0 avger1 avgfit1 avger2...
avgfit2 avger3 avgfit3 avger4 avgfit4 avger5 avgfit5 avger6 avgfit6 avger7 avgfit7 avger8 avgfit8...
avgfeat0 avgfeat1 avgfeat2 avgfeat3 avgfeat4 avgfeat5 avgfeat6 avgfeat7 avgfeat8...
title0 title1 title2 title3 title4 title5 title6 title7 title8...
data_name newfolder num_of_algorithm

newf=[newfolder,'\','最终实验数据'];
if exist(newf,'dir')==0 
mkdir(newf);
end
save([newf,'\',data_name,'_data.mat']);
% system('shutdown -s');