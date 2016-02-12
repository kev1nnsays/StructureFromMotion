function [triangulated_pts] = triangulation1(cameraParams, r0,t0,r1,t1,  matched_points_org, matched_points_new)
%Linear trangulation method x1 = P1*X ; x2 = P2*X where P1 and P2 are
%camera matrices. A*X=0, use SVD to solve X. Homogenize X after solving
%SVD, so that X(4)=1
% for j = 1:4 % for 4 combinations of r and t
    for i = 1:size(matched_points_org,2)
%         P1 = cameraParams*[eye(3), zeros(3,1)];
%         P2 = cameraParams*[r1{j}, t1{j}];.
        P1 = cameraParams*[r0, t0];
        P2 = cameraParams*[r1, t1];
        x2 = matched_points_org(1,i);
        x1 = matched_points_new(1,i);
        y2 = matched_points_org(2,i);
        y1 = matched_points_new(2,i);
        p1_1 = P1(1,:)';
        p1_2 = P1(2,:)';
        p1_3 = P1(3,:)';
        p2_1 = P2(1,:)';
        p2_2 = P2(2,:)';
        p2_3 = P2(3,:)';
        A = [(x1*p1_3' - p1_1') ;
             (y1*p1_3' - p1_2') ;
             (x2*p2_3' - p2_1') ;
             (y2*p2_3' - p2_2') ];
        [U S V] = svd(A);
        X = V(:,size(V,2));
%         triangulated_pts{j,1}(:,i) = X./X(4); % 4 r & t combinations and 4*N World points
        triangulated_pts(:,i) = X./X(4); % 4 r & t combinations and 4*N World points
    end
% end
% t2=K2\P2(:,4)
% c2 = -R2\t2
% WP = zeros(3,size(x,1));
% for i=1:size(x,1)
%     v1=x(i,:)'/norm(x(i,:)');
%     v2=inv(R2)*inv(K2)*x1(i,:)';
%     v2=v2/norm(v2);
%     Front=[];
%     Back=[];
%     I=eye(3);
%     Front=I -v1*v1'+I-v2*v2';
%     Front = inv(Front);
%     Back = (I-v2*v2')*c2;
%     WP(:,i)=Front*Back;
% end
end