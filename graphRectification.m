function[epipolar_eq] = graphRectification(priors, epipolar_eq, numOfPtsPerLine, H)

%%
epipolarLine_graphpoints = zeros(length(epipolar_eq), numOfPtsPerLine, 2);
%Generate array of points for graphing, dependent on numOfPtsPerLine
for n = 1:length(epipolar_eq(1,:))
    for i = 1:numOfPtsPerLine
        x = priors(1, n)+i*50-150;
        epipolarLine_graphpoints(n,i, 1) = x;
         epipolarLine_graphpoints(n,i, 2) = ...
         (epipolar_eq(1,n)* x + epipolar_eq(3,n))/(-1*epipolar_eq(2,n)); %y = -(Ax+C)/B
    end
end

%normalize the lines to calculate error
for i = 1:length(epipolar_eq)
    epipolar_eq(1,i) = epipolar_eq(1,i)/epipolar_eq(3,i);
    epipolar_eq(2,i) = epipolar_eq(2,i)/epipolar_eq(3,i);
    epipolar_eq(3,i) = epipolar_eq(3,i)/epipolar_eq(3,i);
end

%%
%Graph the epipolar lines
for i = 1: length(epipolarLine_graphpoints(:,1))
    color = [rand rand rand];
    for j = 1:numOfPtsPerLine-1
        hold on
        
        %plot orignal x'
        plot(priors(1, i), priors(2, i), 'Color', color, 'Marker', '.', 'MarkerSize', 20);%original correspondences 
        
        %graph line from original point to calc point so we know which
        %epipolar line corresponds with which x'
%         if j == 1
%             plot( [priors(1, i) epipolarLine_graphpoints(i,j,1)],...
%                   [priors(2, i) epipolarLine_graphpoints(i,j,2)],...
%                   'Color', 'w', 'LineStyle', '--');
%         end
        
        %plot lines of epipolar lines
        plot( [epipolarLine_graphpoints(i,j,1) epipolarLine_graphpoints(i,j+1,1)],...
              [epipolarLine_graphpoints(i,j,2) epipolarLine_graphpoints(i,j+1,2)],...
              'Color', color, 'LineStyle', '-', 'LineWidth',1);
          
        %plot points of epipolar lines
%         plot( epipolarLine_graphpoints(i,j,1), epipolarLine_graphpoints(i,j,2), 'Color', color,...
%               'Marker', '.', 'MarkerSize', 20);
%         plot( epipolarLine_graphpoints(i,j+1,1), epipolarLine_graphpoints(i,j+1,2), 'Color', color,...
%               'Marker', '.', 'MarkerSize', 20);
    end
        
end