function [sonsnum_array]  = seedsumGenerate(fitness_array,params)

global Max_Seeds_Num;
global Min_Seeds_Num;
global Coef_Seed_Num;

fitness_max = max(fitness_array); 
fitness_min = min(fitness_array); 

sonsnum_array = zeros(1, params.seednum);

% Ppt=zeros(1, params.seednum);
% PPpt=zeros(1, params.seednum);
for i = 1 : params.seednum
    fit_compare = (fitness_max-fitness_array(i)+eps) / (fitness_max-fitness_min+eps);
    sonnum_temp = round( fit_compare * Coef_Seed_Num);
    if sonnum_temp > Max_Seeds_Num
        sonnum_temp = Max_Seeds_Num;
    elseif sonnum_temp < Min_Seeds_Num
            sonnum_temp = Min_Seeds_Num;
            
    end
%     Ppt(i)=Max_Seeds_Num/sonnum_temp;
    sonsnum_array(i) = sonnum_temp; 
% end
% NPpt= normalize(Ppt,'range',[0,5]);
% for j=2:params.seednum
%   PPpt(j)=logsig(NPpt(j));
%   if rand()<PPpt*0.3
%       sonsnum_array(j) =Max_Seeds_Num-sonsnum_array(j);
%   end
end
