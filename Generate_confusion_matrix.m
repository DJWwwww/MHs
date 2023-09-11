function [confusion_matrix] = Generate_confusion_matrix(expect_label, actual_label)
% 输入预测类别和实际类别，生成混淆矩阵
adju = min([min(actual_label),min(expect_label)]);
if adju == -1
    expect_label(find(expect_label==-1))=0;
    actual_label(find(actual_label==-1))=0;
else
    expect_label=expect_label-adju;
    actual_label=actual_label-adju;
end % 把所有类变成从0开始的连续自然数
numof_class = max([max(actual_label)+1,max(expect_label)+1]); %判断一共有几类
[~,n] = size(actual_label);%统计总样本数
if numof_class == 2 
    confusion_matrix = zeros(2,2);
    for i = 1 : n
        if expect_label(i) == 1
            if actual_label(i) == 1
                confusion_matrix(1,1) = confusion_matrix(1,1) + 1;
            else
                confusion_matrix(2,1) = confusion_matrix(2,1) + 1;
            end
        else
            if actual_label(i) == 1
                confusion_matrix(1,2) = confusion_matrix(1,2) + 1;
            else
                confusion_matrix(2,2) = confusion_matrix(2,2) + 1;
            end
        end
    end % 二分类问题
else %多分类
        confusion_matrix = zeros(numof_class,numof_class);
        for i=1:n
            if expect_label(i)==actual_label(i)
              A_index = actual_label(i)+1;
               confusion_matrix(A_index,A_index)=confusion_matrix(A_index,A_index)+1;
            else 
              A_index = actual_label(i)+1; 
              E_index = expect_label(i)+1;
              confusion_matrix(A_index,E_index)=confusion_matrix(A_index,E_index)+1;
            end
        end
end
end