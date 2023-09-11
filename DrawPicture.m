function DrawPicture(No,num,lable_of_algorithm,data_name,data_of_picture,x,class)
  figure(No);hold on;
  y=data_of_picture(x);
  value= spcrv([[x(1) x x(end)];[y(1) y y(end)]],3);
  Part=round(size(value,2)/10);
  switch(num)
      case 1
          plot(value(1,:),value(2,:),'-^','LineWidth',2,'MarkerSize',5,'MarkerIndices',...
          1:Part:length(value(1,:)),'MarkerFaceColor',[91, 155, 213]/255, 'Color', [91, 155, 213]/255,...
           'DisplayName',lable_of_algorithm);
      case 2
          plot(value(1,:),value(2,:),'-square','LineWidth',2,'MarkerSize',5,'MarkerIndices',...
          1:Part:length(value(1,:)),'MarkerFaceColor',[33, 196 , 156]/255, 'Color', [33, 196 , 156]/255,...
          'DisplayName',lable_of_algorithm);
      case 3
          plot(value(1,:),value(2,:),'-.','LineWidth',2,'MarkerSize',5,'MarkerIndices',...
          1:Part:length(value(1,:)),'MarkerFaceColor',[255, 111 , 0]/255, 'Color', [255, 111 , 0]/255,...
          'DisplayName',lable_of_algorithm);
      case 4
          plot(value(1,:),value(2,:),'-*','LineWidth',2,'MarkerSize',5,'MarkerIndices',...
          1:Part:length(value(1,:)),'MarkerFaceColor',[255, 0 , 0]/255, 'Color', [255, 0 , 0]/255,...
          'DisplayName',lable_of_algorithm);
      case 5
          plot(value(1,:),value(2,:),'-','LineWidth',2,'MarkerSize',5,'MarkerIndices',...
          1:Part:length(value(1,:)),'MarkerFaceColor',[255, 255 , 0]/255, 'Color', [255, 255 , 0]/255,...
          'DisplayName',lable_of_algorithm);
      case 6
          plot(value(1,:),value(2,:),'--v','LineWidth',2,'MarkerSize',5,'MarkerIndices',...
          1:Part:length(value(1,:)),'MarkerFaceColor',[130,130 , 130]/255, 'Color', [130, 130 , 130]/255,...
          'DisplayName',lable_of_algorithm);
      case 7
          plot(value(1,:),value(2,:),'-','LineWidth',2,'MarkerSize',5,'MarkerIndices',...
          1:Part:length(value(1,:)),'MarkerFaceColor',[205, 95 , 238]/255, 'Color', [205, 95 , 238]/255,...
          'DisplayName',lable_of_algorithm);
      case 8
          plot(value(1,:),value(2,:),'-','LineWidth',2,'MarkerSize',5,'MarkerIndices',...
          1:Part:length(value(1,:)),'MarkerFaceColor',[255, 105 , 180]/255, 'Color', [255, 155 , 180]/255,...
          'DisplayName',lable_of_algorithm);
      case 0
          plot(value(1,:),value(2,:),'-','LineWidth',2,'MarkerSize',5,'MarkerIndices',...
          1:Part:length(value(1,:)),'MarkerFaceColor',[0, 0 , 0]/255, 'Color', [0, 0 , 0]/255,...
          'DisplayName',lable_of_algorithm);
  end
  xlabel('Number of Iterations');
  ylabel(class); title(data_name); 
   legend('Location','NorthEastOutside');
%legend('Location','SouthOutside','orientation','horizontal');%横排图例
  box on;
end