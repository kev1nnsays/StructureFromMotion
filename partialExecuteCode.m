% %For partial execution of files
% % figure()
% % 
% % for i = 1:length(t)
% %     T{i} = t{i}./norm(t{i});
% % 
% % end
% % 
% % for i = 1:length(T)-1
% %   plot(T{i}(1),T{i}(2),'+r')
% % %     plot([T{i}(1),T{i}(2)],[T{i+1}(1),T{i+1}(2)])
% %     hold on
% % end
% 
%%Visualize Epipolar
% for i = 1:length(images_proc)-1
%     epipolar_line_eq = fundMatrix{i}*matched_points_org{i};
%     figure()
%     imshow(images_proc{i+1})
%     hold on
%     graphEpipolarLines(matched_points_new{i},epipolar_line_eq,8);
% end

%%
% number = 3;
% epipolar_line_eq = fundMatrix{number}*matched_points_org_excluded{number};
% figure()
% imshow(images_proc{number+1})
% hold on
% graphEpipolarLines(matched_points_new_excluded{number},epipolar_line_eq,20);

% figure()
% scatter3(-triangulated_pts{1}(1,:), triangulated_pts{1}(3,:),triangulated_pts{1}(2,:))
% axis([-10 10 -10 10 -10 5])
% xlabel('X')
% ylabel('Z')
% zlabel('Y')
% 
% figure()
% plot(triangulated_pts{1}(1,:),triangulated_pts{1}(2,:),'x')
% figure()
% plot(triangulated_pts{1}(1,:),triangulated_pts{1}(3,:),'x')
% figure()
% plot(triangulated_pts{1}(2,:),triangulated_pts{1}(3,:),'x')


% for i = 1:size(r,1)
%     for j = 1:size(r,2)
%         i
%         j
%         if det(r{i,j})<0
%             r{i,j} = -r{i,j};
%             disp('done')
%         end
%     end
% end

% 
% for i = 1:4
% for j = 1:6
%     AA(i,j) = det(r{i,j});
% end
% end

% for i = 1:length(T_world)
% scatter3(T_world{1,i}(3), T_world{1,i}(1),-T_world{1,i}(2))
% hold on
% end

% figure()
% for i = 1:length(T_world)
% scatter3(t_best{1,i}(1), t_best{1,i}(3),-t_best{1,i}(2))
% hold on
% end
% title('2 Run')
% visualize(R_world, T_world,r_best,t_best, triangulated_pts_scaled)

% for i = 1:length(images_proc)
%  figure()
%  imshow(images_proc{i})
% end

% cameraParams = [1901.61685419446    0    0;
% 0    1894.94457228005    0;
% 1051.33708372959    778.616424720309    1]'; %GLOBE
% camParam = [1    0   0;
%                 0    1    0;
%                 0    0    1]'; %HOTEL
% 
% save('hotelCal.mat', 'camParam')

%% Visualize matched points
% for i = 1:length(matched_points_org_excluded)
% figure()
% showMatchedFeatures(images_proc{i}, images_proc{i+1},...
% (matched_points_org{i}(1:2,:))', (matched_points_new{i}(1:2,:))',...
% 'montage')
% end

% Visualize triangulated points
%     figure()
% imshow(images_org{1})
% hold on
% plot(matched_points_org{1}(1,:), matched_points_org{1}(2,:), '.b', 'MarkerSize', 20)
% 
% visualize(R_world, T_world,r_best,t_best, triangulated_pts_scaled,matched_points_org_excluded,images_org, NewThreeDPoints,ColorForNewPoints)

figure()
semilogx(graphThis(:,1), graphThis(:,2).*100)
title('F Matrix Calculation Using RANSAC')
ylabel('Percentage of Inliers')
xlabel('Number of RANSAC Iterations')
axis([0 10000 0 100])

