function barplot(Y,color,x,opt,dotson)
if nargin<2 || isempty(color)
    color2=cell(1,length(Y));
    color=color2;
    colorflag=1;
else
    colorflag=0;
end
if ~iscell(Y)
    Y=mat2cell(Y,size(Y,1),ones(1,size(Y,2)));
end
for n=1:length(Y)
    if nargin<2 || colorflag
        color2{n}=[1 1 1]/(length(Y))*n;
        color{n}=color2{n};
    end
    if ~iscell(color)
        color2{n}=color;
    else
        color2{n}=color{n};
    end
    % X=X(:)';
    % X{n}=n;
    Ymean{n}=nanmean(Y{n});
    if nargin<5 || isempty(dotson)
        dotson=true;
    end
    if nargin<4
        ys{n}=(nanstd(Y{n}))./sqrt(sum(~isnan(Y{n})));
    elseif opt==1
        ys{n}=(nanstd(Y{n}));
    else
        ys{n}=(nanstd(Y{n}))./sqrt(sum(~isnan(Y{n})));
    end
    if nargin<3
        x=1:length(Y);
    end
    H=bar(x(n),Ymean{n});
    hold on
    set(H,'FaceColor',color2{n},'BarWidth',.8)
    %         errorbar(x(n),Ymean{n},ys{n},'k+')
    plot([x(n) x(n)],[Ymean{n}-ys{n} Ymean{n}+ys{n}],'k-')

    if dotson
        [xValues,Ynew]=scatter_points_even(sort(Y{n}(:)));
        plot(xValues+x(n)-1,Ynew,'o','Color','k')
    end
end
% Y_swap=Ymean(:);
% ys_swap=ys(:);
% maxmean=max(vertcat(Y_swap{:})+vertcat(ys_swap{:}));

% try
%     lineheight=max(Ymean{1}+ys{1},Ymean{2}+ys{2})+maxmean*.02;
%         p=ranksum(Y{1},Y{2});
%     if p<0.001
%         h=text((x(1)+x(2))/2,lineheight,'***');
%         set(h,'HorizontalAlignment','center')
%         plot([x(1) x(2)],ones(1,2)*lineheight,'k-')
%     elseif p<.01
%         h=text((x(1)+x(2))/2,lineheight,'**');
%         set(h,'HorizontalAlignment','center')
%         plot([x(1) x(2)],ones(1,2)*lineheight,'k-')
%     elseif p<.05
%         h=text((x(1)+x(2))/2,lineheight,'*');
%         set(h,'HorizontalAlignment','center')
%         plot([x(1) x(2)],ones(1,2)*lineheight,'k-')
%     end
%
%     lineheight=max([Ymean{1}+ys{1},Ymean{2}+ys{2},Ymean{3}+ys{3}])+maxmean*.05;
%         p=ranksum(Y{1},Y{3});
%     if p<0.001
%         h=text((x(1)+x(3))/2,lineheight,'***');
%         set(h,'HorizontalAlignment','center')
%         plot([x(1) x(3)],ones(1,2)*lineheight,'k-')
%     elseif p<.01
%         h=text((x(1)+x(3))/2,lineheight,'**');
%         set(h,'HorizontalAlignment','center')
%         plot([x(1) x(3)],ones(1,2)*lineheight,'k-')
%     elseif p<.05
%         h=text((x(1)+x(3))/2,lineheight,'*');
%         set(h,'HorizontalAlignment','center')
%         plot([x(1) x(3)],ones(1,2)*lineheight,'k-')
%     end
%
%     lineheight=max(Ymean{2}+ys{2},Ymean{3}+ys{3})+maxmean*.02;
%         p=ranksum(Y{2},Y{3});
%     if p<0.001
%         h=text((x(2)+x(3))/2,lineheight,'***');
%         set(h,'HorizontalAlignment','center')
%         plot([x(2) x(3)],ones(1,2)*lineheight,'k-')
%     elseif p<.01
%         h=text((x(2)+x(3))/2,lineheight,'**');
%         set(h,'HorizontalAlignment','center')
%         plot([x(2) x(3)],ones(1,2)*lineheight,'k-')
%     elseif p<.05
%         h=text((x(2)+x(3))/2,lineheight,'*');
%         set(h,'HorizontalAlignment','center')
%         plot([x(2) x(3)],ones(1,2)*lineheight,'k-')
%     end
%
% end
% if nargin<3
%     x=[];
% end
set(gca,'XTick',[])