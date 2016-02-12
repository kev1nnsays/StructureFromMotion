function [F_array,NumOfInliers] = computeFarray_Jeff(matched_pts_org, matched_pts_new,ransacN)%ransacN sets the round that rasnsac checks
    F_array = cell(1, length(matched_pts_org));
    for N = 1:length(matched_pts_org) %for the entire array of scenes find best F
        minE=-1; %reset the minimum error for new image pair
        minEOutliner=-1;
        for RN = 1:ransacN %ransacloop
            outliner = 0; %reset error count for new ransac run
            avgerr = 0;
            index = randperm(size(matched_pts_org{N},2), 8); %choose 10 points from all matching points to calculate F matrix and do ransac voting
            x = matched_pts_org{N}(:,index);
            x1 = matched_pts_new{N}(:,index);
            x = x.';
            x1 = x1.';
            %normalize 2D points 
            x_xavg = mean(x(:,1));
            x_yavg = mean(x(:,2));
            dx1 = sum(abs((x(:,1)-x_xavg))/size(x,1));
            dy1 = sum(abs((x(:,2)-x_yavg))/size(x,1));
            T1 = [1/dx1 0 (-1*x_xavg)/dx1; 0 1/dy1 (-1*x_yavg)/dy1; 0 0 1];
            for i = 1:size(x,1)
                xT(i,:) = (T1*x(i,:).').';
            end
            x1_xavg = mean(x1(:,1));
            x1_yavg = mean(x1(:,2));
            dx2 = sum(abs((x1(:,1)-x1_xavg))/size(x1,1));
            dy2 = sum(abs((x1(:,2)-x1_yavg))/size(x1,1));
            T2 = [1/dx2 0 (-1*x1_xavg)/dx2; 0 1/dy2 (-1*x1_yavg)/dy2; 0 0 1];
            for i = 1:size(x1,1)
                x1T(i,:) = (T2*x1(i,:).').';
            end
            %Begin calculation of Fundamental Matrix using normalized
            %points
            A=[xT(:,1).*x1T(:,1),xT(:,1).*x1T(:,2),xT(:,1),xT(:,2).*x1T(:,1),xT(:,2).*x1T(:,2),xT(:,2),x1T(:,1),x1T(:,2),ones(size(xT,1),1)];
            [U,S,V] = svd(A);
            [m,n] = size(V);
            F =[V(1,n) V(2,n) V(3,n) ;V(4,n) V(5,n) V(6,n); V(7,n) V(8,n) V(9,n)];
            [U2,S2,V2] = svd(F);
            [m2,n2]=size(S2);
            S2(:,n2) = zeros(1,m2); %enforce rank 2
            F_=U2*S2*V2';
            F_=T1'*F_*T2;
            
            x = matched_pts_org{N};
            x1 = matched_pts_new{N};
            x = x.';
            x1 = x1.';
            for i = 1:size(x1,1)%calculate error for points in image 1 to their corresponding epipolar lines
                line=F_*x1(i,:)';
                avgerr =avgerr+ abs(line(1)*x(i,1)+line(2)*x(i,2)+line(3))/(line(1)^2+line(2)^2)^0.5;
                if (abs(line(1)*x(i,1)+line(2)*x(i,2)+line(3))/(line(1)^2+line(2)^2)^0.5)>5
                    outliner = outliner+1;
                end
            end
            for i = 1:size(x,1)%calculate error for points in image 2 to their corresponding epipolar lines
                line=F_'*x(i,:)';
                avgerr =avgerr+ abs(line(1)*x1(i,1)+line(2)*x1(i,2)+line(3))/(line(1)^2+line(2)^2)^0.5;
                if (abs(line(1)*x1(i,1)+line(2)*x1(i,2)+line(3))/(line(1)^2+line(2)^2)^0.5) >5
                    outliner = outliner+1;
                end
            end
            avgerr = avgerr/(size(x1,1)+size(x,1)); %calculate average error
            if minEOutliner==-1%check if the new F matrix is better than the previous one
                minE=avgerr;
                minEOutliner = outliner;
                Ftemp = F_;
            elseif minEOutliner>outliner
                minE=avgerr;
                minEOutliner = outliner;
                Ftemp = F_;
            elseif minEOutliner==outliner && minE>avgerr
                minE=avgerr;
                minEOutliner = outliner;
                Ftemp = F_;
            end
        end
        NumOfInliers(N) = (2*size(matched_pts_org{N},2) - minEOutliner)/(2*size(matched_pts_org{N},2));
        F_array{N} = Ftemp;
    end
end