function [] = visualize(R_world, T_world,r_best,t_best, triangulated_pts_scaled,matched_points_org_excluded,images_org, NewThreeDPoints,ColorForNewPoints)


%% Visualize Bund Adj. 
% 
% axis_X = rand(1, 400);
% axis_Y = rand(1, 400);
% axis_Z = rand(1, 400);
% figure()
% %create 360 snapshots (1 per degree)
% t = 100;
% for degree=1:360
%     clear graph
% clf
% 
% % plot 3d snapshot with small dots "."
% scatter3(NewThreeDPoints(3,:), -NewThreeDPoints(1,:),-NewThreeDPoints(2,:),20,ColorForNewPoints/255,'filled')
% hold on
% for camera = 1:size(T_world, 2)
%         scatter3(T_world{camera}(3,:), -T_world{camera}(1,:),...
%             -T_world{camera}(2,:), 'MarkerFaceColor', [0 1 0]);
%         hold on
% end
% axis([0 10 -5 5 -5 5]);
%    
% title('3D points and cameras')
%     zlabel('Y')
%     xlabel('X')
%     ylabel('Z')
%     
% %     legend('1','2','3','4','5','6','7','8','9')
% legend('Camera 1','Camera 2','3D Points')
%     
% % configure label names and axis intervals [0, 1]
% 
% %rotate the graph according to current degree
% view(degree, 30 + 15 * sin(degree/60));
% 
% % save the current snapshot file
% plotname = ['scatter_t', num2str(t), '.png'];
% print(plotname, '-dpng');
% t = t + 1;
% end;
%  


%% VISUALIZE World Coordinate Camera Poses
%     figure()
% %     plotCamera('Location',[0 0 0],'Orientation',[1 0 0; 0 1 0; 0 0 1],...
% %         'Opacity',0, 'Size', 0.1,'Color', [0 0 1], 'Label', num2str(1));
%     hold on;
%     grid on
%     for camera = 1:size(R_world, 2)
%         plotCamera('Location',(T_world{camera})','Orientation',R_world{camera},...
%         'Opacity',0,'Size', 0.1,'Color', [1 0 0], 'Label', num2str(camera));
%     end
%     title('World')
%     temp = 8;
%     axis equal

%% Visualize 3D points 
% figure()
% for camera = 1:size(T_world, 2)
%         scatter3(-T_world{camera}(3,:), T_world{camera}(1,:),...
%             -T_world{camera}(2,:), 'MarkerFaceColor', [0 1 0]);
%         hold on
%     end
% 
% for camera = 1:size(triangulated_pts_scaled, 2)
%     	
%     	C = getPixelColor(matched_points_org_excluded{camera},images_org{camera});
%     	C = C/255;
%     	display(C)
%     	scatter3(-triangulated_pts_scaled{camera}(3,:), triangulated_pts_scaled{camera}(1,:),...
%         	-triangulated_pts_scaled{camera}(2,:), 50, C,'filled');
%     	hold on
% 	end
%     axis equal
%  %axis([-10 10 -10 10 -10 10])
% 
%     title('3D points and cameras')
%     zlabel('Y')
%     xlabel('X')
%     ylabel('Z')
%     
%     legend('1','2','3','4','5','6','7','8','9')
% legend('Camera 1','Camera 2','3D Points')

%% Bundle Adjust
figure()
scatter3(NewThreeDPoints(3,:).*10, -NewThreeDPoints(1,:).*10,-NewThreeDPoints(2,:).*10,20,ColorForNewPoints/255,'filled')
hold on
% for camera = 1:size(T_world, 2)
%         scatter3(T_world{camera}(3,:), -T_world{camera}(1,:),...
%             -T_world{camera}(2,:), 'MarkerFaceColor', [0 1 0]);
%         hold on
% end
for camera = 1:size(R_world, 2)
    plotCamera('Location',[T_world{camera}(3,:), -T_world{camera}(1,:),...
            -T_world{camera}(2,:)].*10,...
    'Orientation',R_world{camera}*[0 0 -1; 0 1 0 ; 1 0 0],'Opacity',0,'Size', 1.5,'Color', [1 0 0], 'Label', num2str(camera));
legend('Camera 1', 'Camera 2', 'Camera 3')
end

axis([-5 15 -5 15 -5 15].*10);
% axis equal 

title('3D Points and Cameras After Scaling')
    zlabel('Y (cm)')
    xlabel('Z (cm)')
    ylabel('X (cm)')
    

%% Visualize 3D points in a Video
% 
% axis_X = rand(1, 400);
% axis_Y = rand(1, 400);
% axis_Z = rand(1, 400);
% figure()
% %create 360 snapshots (1 per degree)
% t = 100;
% for degree=1:360
%     clear graph
% clf
% 
% % plot 3d snapshot with small dots "."
% 
% for camera = 1:size(T_world, 2)
%         scatter3(-T_world{camera}(3,:), T_world{camera}(1,:),...
%             -T_world{camera}(2,:), 'MarkerFaceColor', [0 camera/2 1-camera/2]);
%         hold on
%     end
% 
% for camera = 1:size(triangulated_pts_scaled, 2)
%     	
%     	C = getPixelColor(matched_points_org_excluded{camera},images_org{camera});
%     	C = C/255;
%     	display(C)
%     	scatter3(-triangulated_pts_scaled{camera}(3,:), triangulated_pts_scaled{camera}(1,:),...
%         	-triangulated_pts_scaled{camera}(2,:), 50, C,'filled');
%     	hold on
% 	end
%     axis equal
% % axis([-10 10 -10 10 -10 10])
%     title('3D points and cameras')
%     zlabel('Y')
%     xlabel('X')
%     ylabel('Z')
%     
% %     legend('1','2','3','4','5','6','7','8','9')
% legend('Camera 1','Camera 2','3D Points')
%     
% % configure label names and axis intervals [0, 1]
% 
% %rotate the graph according to current degree
% view(degree, 30 + 15 * sin(degree/60));
% 
% % save the current snapshot file
% plotname = ['scatter_t', num2str(t), '.png'];
% print(plotname, '-dpng');
% t = t + 1;
% end;
%  
    
%% VISUALIZE Scene Coordinate Camera Poses
%     figure()
%     plotCamera('Location',[0 0 0],'Orientation',[1 0 0; 0 1 0; 0 0 1],...
%     'Opacity',0, 'Size', 0.05,'Color', [0 0 1], 'Label', num2str(1));
%     title('Scene')
%     hold on;
%     grid on
% %     axis([-1 1 -1 1 -1 1])
%     for camera = 1:size(R_world, 2)-1
%         plotCamera('Location',(t_best{camera})',...
%         'Orientation',r_best{camera},'Opacity',0,'Size', 0.05,'Color', [1 0 0], 'Label', num2str(camera+1));
%     end
%     
%% VISUALIZE Triangulated Pts
% for scene = 1:length(triangulated_pts_scaled)
% figure()
% scatter3(-triangulated_pts_scaled{scene}(1,:), triangulated_pts_scaled{scene}(3,:),-triangulated_pts_scaled{scene}(2,:))
% end

%% Visualize Camera and World 

% temp2 = cell(1);
% temp2{1} = zeros(3,1);
% t_best = [temp2, t_best];
% figure()
% for camera = 1:size(R_world, 2)
%     plotCamera('Location',[T_world{camera}(3,:), -T_world{camera}(1,:),...
%             -T_world{camera}(2,:)].*1,...
%     'Orientation',R_world{camera}*[0 0 -1; 0 1 0 ; 1 0 0],'Opacity',0,'Size', .15,'Color', [1 0 0], 'Label', num2str(camera));
% hold on
% plotCamera('Location',[t_best{camera}(3,:), -t_best{camera}(1,:),...
%             -t_best{camera}(2,:)].*1,...
%     'Orientation',R_world{camera}*[0 0 -1; 0 1 0 ; 1 0 0],'Opacity',0,'Size', .15,'Color', [0 0 1], 'Label', num2str(camera));
% hold on
% 
% legend('Before Scaling', 'After Scaling')
% end
   
end
