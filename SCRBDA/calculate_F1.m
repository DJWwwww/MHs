function F1_score = calculate_F1(confusion_matrix)
% 输入混淆矩阵计算F1-SCORE
[m,n]=size(confusion_matrix);
if m~=n
    error('必须是方阵');
end
numof_class=m;
F1_score=0;
if numof_class == 2
    if confusion_matrix(1,1) == 0
      Precision=0;
      Recall=0;
      F1_score=0;
    else
      Precision = confusion_matrix(1,1)/(confusion_matrix(1,1)+confusion_matrix(2,1));
      Recall = confusion_matrix(1,1)/(confusion_matrix(1,1)+confusion_matrix(1,2));
      F1_score=2*(Precision*Recall)/(Precision+Recall);
    end
else
    sum_matrix = sum(sum(confusion_matrix));
    for i=1:numof_class
        TP = confusion_matrix(i,i);
        FP = sum(confusion_matrix(:,i)) - TP;
        FN = sum(confusion_matrix(i,:)) - TP;
        TN = sum_matrix-TP-FP-FN;
        if TP==0
              Precision=0;
              Recall=0;
              F1=0; 
        else
              Precision = TP/(TP+FP);
              Recall = TP/(TP+FN);
              F1 = 2*(Precision*Recall)/(Precision+Recall);
        end
        F1_score = F1_score + F1;
    end
    F1_score = F1_score/numof_class;
end
end
